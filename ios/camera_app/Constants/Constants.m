#import "Constants.h"

@implementation Constants

// @synthesize could be left for latest XCode
@synthesize rootSavingPath = _rootSavingPath;
@synthesize keyStrServerPort = _keyStrServerPort;
@synthesize keyStrServerIP = _keyStrServerIP;
@synthesize colorStartWriting = _colorStartWriting;
@synthesize colorStopWriting = _colorStopWriting;


+ (instancetype _Nonnull) sharedInstance {
    
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^ {
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}


- (instancetype) init {
    
    if(self = [super init]) {
        
        _rootSavingPath = @"/";
        _keyStrServerPort = @"serverPort";
        _keyStrServerIP = @"serverIP";
        _colorStartWriting = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        _colorStopWriting = [UIColor colorWithRed:255.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    }
    
    return self;
}

@end
