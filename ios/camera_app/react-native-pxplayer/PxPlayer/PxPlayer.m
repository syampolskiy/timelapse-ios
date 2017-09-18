//
#import "RCTConvert.h"
#import "RCTBridgeModule.h"
#import "RCTEventDispatcher.h"
#import "UIView+React.h"
#import "PxPlayer.h"

@implementation PxPlayer

@synthesize outputWidth, outputHeight , src_video, source_data;

@synthesize nextFrameTimer = _nextFrameTimer;
@synthesize displayNextFrameQueue = _displayNextFrameQueue;
@synthesize d_group = _d_group;
@synthesize displayNextFrameQueueBusyFlag = _displayNextFrameQueueBusyFlag;

///////////////////

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
    if ((self = [super init])) {
        self._eventDispatcher = eventDispatcher;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
/*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
*/
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
    }
    _canPlay = NO;
    _paused  = NO;
    _errorMsg = @"";
    _useGLView = NO;
    _releaseInstance = NO;
    outputHeight = 0;
    outputWidth  = 0;
    _d_group = NULL;
    _displayNextFrameQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _displayNextFrameQueueBusyFlag = false;

    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)applicationWillResignActive:(NSNotification *)notification
{
    if (!_paused)
        [self setPaused:!_paused];

    if (_playing == YES)
        [self stop];

    [self releaseVideo:true];
}


/*
- (void)applicationWillEnterForeground:(NSNotification *)notification
{

}
*/
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    // initialize ffmpeg with presaved source data
    if (source_data)
    [self setSource:source_data];
    
    if (_playing == NO)
    [self start];
    
    if (_paused)
    [self setPaused:!_paused];
}
    
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)setSource:(NSDictionary *)source
{
    if(src_video){
        [self stop];
        [self releaseVideo:false];
    }
    
    source_data = [source copy];
    NSString* uri    = [source objectForKey:@"uri"];
    BOOL    useTcp   = [RCTConvert BOOL:[source objectForKey:@"useTcp"]];
    int     width    = [RCTConvert int:[source objectForKey:@"width"]];
    int     height   = [RCTConvert int:[source objectForKey:@"height"]];
    NSLog(@"width=%i,height=%i",width,height);
    if( ![self isBlankString:uri] ){
        [self setDataSource:uri useTcp:useTcp width:width height:height];
    }
 
}

-(void)setSnapshotPath:(NSString*)path
{
    if(src_video)
        [self savePicture:path];
}

- (void)setPaused:(BOOL)paused
{
    if(src_video){
        if(paused && _playing){
            [self pause];
        }
        if(_paused){
            [self playerStateChanged:PLAYER_STATE_PAUSED];
        }else{
            [self playerStateChanged:PLAYER_STATE_PLAYING];
        }
    }
}

/////////////////

-(void)setDataSource:(NSString*)uri useTcp:(BOOL)useTcp width:(int)width height:(int)height
{
    NSString *osSpecificUri = nil;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iOS 3.2 or later.
        osSpecificUri = [NSString stringWithFormat:@"%@%@", uri, @"x2"];
    }
    else
    {
        // The device is an iPhone or iPod touch.
        osSpecificUri = [NSString stringWithFormat:@"%@", uri];
    }
    
    [self setDisplay:self width:width height:height];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // ros: todo: Really?
        // \video started from shadow thread. During this time user may go to Home(emit stop or pause),
        // reassign the new \specificUri (see begin of \setSource()) and so on
        src_video = [[RTSPPlayer alloc] initWithVideo:osSpecificUri usesTcp:useTcp];
        if(src_video == nil){
            if (_d_group)
                dispatch_group_wait(_d_group, DISPATCH_TIME_FOREVER);
            _d_group = NULL;
            
            _errorMsg = @"PxPlayer cannot open source URI";
            [self playerStateChanged:PLAYER_STATE_ERROR];
        }else{
            // To provide ability scale with aspect fit, we need to save the original frame size
//            NSLog(@"width=%i,height=%i",width,height);
//            video.outputWidth  = width;
//            video.outputHeight = height;
            dispatch_async(dispatch_get_main_queue(),^{
                _d_group                = dispatch_group_create();
                [self start];
            });
        }
    });
}

-(void)start
{
    if(src_video){
        float fps = src_video.outputFPS;
        if (fps < 1.0f)
            fps = 25.0f;
        _displayNextFrameQueueBusyFlag = false;
        [_nextFrameTimer invalidate];
        _nextFrameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/fps
                                                             target:self
                                                             selector:@selector(displayNextFrame)
                                                             userInfo:nil
                                                             repeats:YES];
        [self playerStateChanged:PLAYER_STATE_START];
    }
}

-(void)stop
{
    _displayNextFrameQueueBusyFlag = true;
    
    // 1. Stop repeating
    [_nextFrameTimer invalidate];
    _nextFrameTimer = nil;
    
    //
    // 2. Inform other loops about stopping
    _playing = NO;
    [self playerStateChanged:PLAYER_STATE_STOPPED];
}

-(void)pause
{
    if(src_video){
        _paused = !_paused;
    }
}

-(void)setDisplay:(UIView*)videoView width:(int)width height:(int)height
{
    outputWidth  = width;
    outputHeight = height;
    
    _videoView = videoView;
    NSArray *viewsToRemove = [_videoView subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    CGRect frame = CGRectMake(0, 0, width, height);
    
    if(_useGLView){
        [self initGLViewWith:frame];
    }else{
        // about content view mode:
        // https://stackoverflow.com/questions/4895272/difference-between-uiviewcontentmodescaleaspectfit-and-uiviewcontentmodescaletof/26547006
        [self initImageViewWith:frame contentVideMode:UIViewContentModeScaleAspectFit];
    }
    
}

-(void)initGLViewWith:(CGRect)frame
{

}

-(void)initImageViewWith:(CGRect)frame contentVideMode:(UIViewContentMode)contentVideMode
{
    _imageView=[[UIImageView alloc] initWithFrame:frame];
    [_imageView setContentMode:contentVideMode];
    [_videoView addSubview:_imageView];
}

-(void)setFullscreen:(BOOL)isFull
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    int width = (int)screenBounds.size.width;
    int height = (int)screenBounds.size.height;
    if(isFull && _fullscreen==NO){
        _fullscreen = YES;
        CGAffineTransform transform = CGAffineTransformMakeRotation(90 * M_PI/180.0);
        if(_useGLView){

        }else{
            [_imageView setTransform:transform];
            [_imageView setFrame:CGRectMake(0, 0, width,height)];
        }
    }else if(isFull == NO && _fullscreen == YES){
        _fullscreen = NO;
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        if(_useGLView){

        }else{
            [_imageView setTransform:transform];
            [_imageView setFrame:CGRectMake(0, 0, outputWidth, outputHeight)];
        }
    }
}

-(void)setOutputWidth:(int)value
{
    outputWidth = value;
}

-(void)setOutputHeight:(int)value
{
    outputHeight = value;
}


- (UIImage *)imageFromAVPicture:(AVPicture)pict width:(int)width height:(int)height
{
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CFDataRef data = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, pict.data[0], pict.linesize[0]*height,kCFAllocatorNull);
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(data);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       8,
                                       24,
                                       pict.linesize[0],
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(data);

    return image;
}


- (void)playerStateChanged:(playerState)state
{
    switch (state) {
        case PLAYER_STATE_PAUSED:
            _paused = YES;
            //NSLog(@"VLCMediaPlayerStatePaused %i",VLCMediaPlayerStatePaused);
            [self._eventDispatcher sendInputEventWithName:@"onVideoPaused"
                                                body:@{
                                                       @"target": self.reactTag
                                                       }];
            break;
        case PLAYER_STATE_STOPPED:
            //NSLog(@"VLCMediaPlayerStateStopped %i",VLCMediaPlayerStateStopped);
            [self._eventDispatcher sendInputEventWithName:@"onVideoStopped"
                                                body:@{
                                                       @"target": self.reactTag
                                                       }];
            break;
        case PLAYER_STATE_START:
            _paused = NO;
            [self._eventDispatcher sendInputEventWithName:@"onVideoStartPlay"
                                                body:@{
                                                       @"target": self.reactTag
                                                       }];
            break;
        case PLAYER_STATE_BUFFERING:
            _paused = NO;
            [self._eventDispatcher sendInputEventWithName:@"onVideoBuffering"
                                                body:@{
                                                       @"target": self.reactTag
                                                       }];
            break;
        case PLAYER_STATE_PLAYING:
            _paused = NO;
            [self._eventDispatcher sendInputEventWithName:@"onVideoPlaying"
                                                body:@{
                                                       @"target": self.reactTag
                                                       }];
            break;
         case PLAYER_STATE_ERROR:
            [self._eventDispatcher sendInputEventWithName:@"onVideoError"
                                                body:@{
                                                       @"target": self.reactTag,
                                                       @"error":  self.errorMsg
                                                       }];
            [self _release];
            break;
        default:
            //NSLog(@"state %i",state);
            break;
    }
}

#define LERP(A,B,C) ((A)*(1.0-C)+(B)*C)

-(void)displayNextFrame
{
    if(src_video && _paused)return;//pause
    /*
    @autoreleasepool {
        if (![video stepFrame]) {
            [video closeAudio];
            return;
        }
        if(!_playing){
            _playing = YES;
            [self playerStateChanged:PLAYER_STATE_PLAYING];
        }
        [self playerStateChanged:PLAYER_STATE_PLAYING];
        _imageView.image = video.currentImage;
    }
     */
    if (_displayNextFrameQueueBusyFlag == true || _d_group == nil)
        return;
    

    
    _displayNextFrameQueueBusyFlag = true;
    dispatch_group_async(_d_group, _displayNextFrameQueue, ^{
        //stuffs to do in background thread
        @autoreleasepool {
            @try {
                if (![src_video stepFrame]) {
                    [src_video closeAudio];
                    // Interrupt translation from server-side
                    _displayNextFrameQueueBusyFlag = false;
                    return;
                }
                if(!_playing){
                    _playing = YES;
                    [self playerStateChanged:PLAYER_STATE_PLAYING];
                }
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
                _displayNextFrameQueueBusyFlag = false;
                return;
            }
            @finally {
                //NSLog(@"finally");
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //stuffs to do in foreground thread, mostly UI updates
                @try {
                    if (_playing && src_video && _displayNextFrameQueueBusyFlag == true) {
                        _imageView.image = src_video.currentImage;
                    }
                }
                @catch (NSException * e) {
                    NSLog(@"Exception: %@", e);
                }
                @finally {
                    //NSLog(@"finally");
                    _displayNextFrameQueueBusyFlag = false;
                }
            });
        }
    });
}

- (void)releaseVideo:(BOOL) async
{
    // ensure that frame grabber loop stopped
    [_nextFrameTimer invalidate];
    _nextFrameTimer = nil;
    //
    // Release ffmpeg
    // Wait till queue finished
    //
    if (async == false) {
        dispatch_barrier_async(_displayNextFrameQueue, ^{
            if (_d_group)
                dispatch_group_wait(_d_group, DISPATCH_TIME_FOREVER);
            _d_group = NULL;
            src_video = nil;
        });
    } else {
        if (_d_group)
            dispatch_group_wait(_d_group, DISPATCH_TIME_FOREVER);
        _d_group = NULL;
        src_video = nil;
    }
}

- (NSData *)copYUVData:(UInt8 *)src linesize:(int)linesize width:(int)width height:(int)height {
    
    width = MIN(linesize, width);
    NSMutableData *md = [NSMutableData dataWithLength: width * height];
    Byte *dst = md.mutableBytes;
    for (NSUInteger i = 0; i < height; ++i) {
        memcpy(dst, src, width);
        dst += width;
        src += linesize;
    }
    return md;
}


- (void)_release
{
    if(src_video){
        [self pause];
        [self stop];
    }
}

-(void)savePicture:(NSString*)path
{
    //    NSString *strPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:path];
    NSLog(@"path=%@",path);
    //Document/saveimg.png
    [UIImagePNGRepresentation(_imageView.image) writeToFile:path atomically:YES];
}

#pragma mark - Lifecycle
- (void)removeFromSuperview
{
    [self _release];
    [self releaseVideo:true];
    [super removeFromSuperview];
}


@end
