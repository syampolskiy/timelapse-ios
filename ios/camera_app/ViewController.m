//
//  ViewController.m
//  camera_app
//
//  Created by MacPC on 6/12/17.
//  Copyright © 2017 jazzros. All rights reserved.
//

#import "ViewController.h"
//
#import "SocketComponent/State/SocketConnection.h"
#import "SocketComponent/Commands/CommandWritingStart.h"
#import "SocketComponent/Commands/CommandWritingStop.h"
#import "SocketComponent/Commands/CommandGetCamState0.h"
#import "SocketComponent/Commands/CommandGetCamState.h"
#import "SocketComponent/Commands/CommandOneShotPhoto.h"
#import "SocketComponent/Commands/CommandSetFps.h"
#import "SocketComponent/Commands/CommandSetWB.h"
#import "SocketComponent/Commands/CommandSetExposure.h"
#import "SocketComponent/Commands/CommandSetISO.h"
#import "SocketComponent/Commands/CommandSetBPP.h"
#import "SocketComponent/Commands/CommandSetResolution.h"
#import "SocketComponent/Commands/CommandSetShutter.h"
#import "SocketComponent/Commands/CommandSetBrightness.h"
#import "SocketComponent/Commands/CommandSetContrast.h"
#import "SocketComponent/Commands/CommandSetSaturation.h"
#import "SocketComponent/Commands/CommandSetSharpness.h"
#import "SocketComponent/Commands/CommandGetWritingTime.h"
#import "SocketComponent/Commands/CommandGetRemainWritingTime.h"
#import "SocketComponent/Commands/CommandGetVStreamURL.h"
#import "SocketComponent/Commands/CommandGetCamStatus.h"
#import "SocketComponent/Commands/CommandSetCamStatus.h"
#import "SocketComponent/Commands/CommandGetCamStatusError.h"
#import "SocketComponent/Commands/CommandGetFootageList.h"
//
#import "Constants/Constants.h"
//
#import "AppDelegate.h"
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <React/RCTEventDispatcher.h>

@interface ViewController ()

@property (strong,nonatomic) SocketConnection * connection;

@end

@implementation ViewController

// Declare state of the ViewController
{
//BOOL isWritingStarted;
NSUInteger m_server_port;
NSString * m_server_ip;
}

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

 //
 // Connect to necessary notification to be able refresh the state after exit by Home-button
 // or any changes has had been aplied to application
 //
    [[NSNotificationCenter defaultCenter]addObserver:self
                                         selector:@selector(refresh:)
                                         name:NSUserDefaultsDidChangeNotification
                                         object:nil];
}
*/
- (instancetype _Nullable) initEx {
    
    if (self = [super init]) {
        //
        // Connect to necessary notification to be able refresh the state after exit by Home-button
        // or any changes has had been aplied to application
        //
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(refresh:)
                                                    name:NSUserDefaultsDidChangeNotification
                                                  object:nil];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self refresh:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) doStartStopWriting:(int)needsToStart {
    
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // No sense to control \self.view.userInteractionEnabled because we deal with React Native UI
    // self.view.userInteractionEnabled = NO;

    id<Command>  p_command;
    
    if (needsToStart != 0){
        p_command = [[CommandWritingStart alloc] initWithSocketConnection:self.connection state:delegate.app_state];
        
    } else {
        p_command = [[CommandWritingStop alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    }
    
    [p_command execute];
    
    // self.view.userInteractionEnabled = YES;
}

- (void) doOneShotPhoto {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    id<Command>  p_command = [[CommandOneShotPhoto alloc] initWithSocketConnection:self.connection state:delegate.app_state];

    [p_command execute];
}

- (void) doSetFps:(int)fps {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetFps *  p_command = [[CommandSetFps alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.fps = fps;
    
    [p_command execute];
}

- (void) doSetExposure:(int)exposure {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetExposure *  p_command = [[CommandSetExposure alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.exposure = exposure;
    
    [p_command execute];
}

- (void) doSetShutterspeed:(int)shutter {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetShutter *  p_command = [[CommandSetShutter alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.shutter = shutter;
    
    [p_command execute];
}

- (void) doSetISO:(int)iso {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetISO *  p_command = [[CommandSetISO alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.iso = iso;
    
    [p_command execute];
}

- (void) doSetBPP:(int)bppIndex {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetBPP *  p_command = [[CommandSetBPP alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.pixFmtIndex = bppIndex;
    
    [p_command execute];
}

- (void) doSetCamResolution:(int)resolutionIndex {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetResolution *  p_command = [[CommandSetResolution alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.camResolution = resolutionIndex;
    
    [p_command execute];
}

- (void) doSetAWB:(int)awb {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetWB *  p_command = [[CommandSetWB alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.kelvin = awb;
    
    [p_command execute];
}

- (void) doSetBrightness:(int)brightness {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetBrightness *  p_command = [[CommandSetBrightness alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.brightness = brightness;
    
    [p_command execute];
}

- (void) doSetContrast:(int)contrast {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetContrast *  p_command = [[CommandSetContrast alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.contrast = contrast;
    
    [p_command execute];
}

- (void) doSetSaturation:(int)saturation {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetSaturation *  p_command = [[CommandSetSaturation alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.saturation = saturation;
    
    [p_command execute];
}

- (void) doSetSharpness:(int)sharpness {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandSetSharpness *  p_command = [[CommandSetSharpness alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    p_command.sharpness = sharpness;
    
    [p_command execute];
}

- (void) doGetWritingTime {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandGetWritingTime *  p_command = [[CommandGetWritingTime alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    [p_command execute];
}

- (void) doGetRemainWritingTime {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandGetRemainWritingTime *  p_command = [[CommandGetRemainWritingTime alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    
    [p_command execute];
}

- (void) doSetCamStateCurrentCam:(int)newCamIndex {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandGetCamStatus *  p_command = [[CommandGetCamStatus alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    [p_command execute];
    if (delegate.app_state.bIsServerConnected) {
        CommandSetCamStatus *  p_command2 = [[CommandSetCamStatus alloc] initWithSocketConnection:self.connection state:delegate.app_state];
        
        p_command2.camStatus = p_command.camStatus;
        [p_command2 setCamIndex:newCamIndex];
        
        [p_command2 execute];
    }
}

- (void) doSetCamStateCamMode:(int)modeIndex {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandGetCamStatus *  p_command = [[CommandGetCamStatus alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    [p_command execute];
    if (delegate.app_state.bIsServerConnected) {
        CommandSetCamStatus *  p_command2 = [[CommandSetCamStatus alloc] initWithSocketConnection:self.connection state:delegate.app_state];
        
        p_command2.camStatus = p_command.camStatus;
        [p_command2 setCamMode:modeIndex];
        
        [p_command2 execute];
    }
}

- (void) doGetFootageList:(int)isVideoOrShot firstIndex:(int)firstIndex lastIndex:(int)lastIndex {
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandGetFootageList *  p_command = [[CommandGetFootageList alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    p_command.isVideoOrShot = isVideoOrShot;
    p_command.firstIndex = firstIndex;
    p_command.lastIndex = lastIndex;
    
    [p_command execute];
}

- (void) doRefreshStateFromServer {
    
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // No sense to control \self.view.userInteractionEnabled because we deal with React Native UI
    // self.view.userInteractionEnabled = NO;
    
    id<Command>  p_command = [[CommandGetCamState alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    [p_command execute];

    // Refresh video stream URL
    p_command = [[CommandGetVStreamURL alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    [p_command execute];

    // Refresh full camera status
    [self doUpdateCamStatus:false];

    
    // self.view.userInteractionEnabled = YES;
}


- (void) doGetCamState0 {
    
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    CommandGetCamState0 *  p_command = [[CommandGetCamState0 alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    [p_command execute];
}

- (void) doUpdateCamStatus:(BOOL)errorMsgOnly
{
    if (!self.connection) {
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    CommandGetCamStatus *p_command = [[CommandGetCamStatus alloc] initWithSocketConnection:self.connection state:delegate.app_state];
    [p_command execute];
    
    if (delegate.app_state.bIsServerConnected) { // is successed executing
        
        if (errorMsgOnly == false) {
            delegate.app_state.bStreamVideoMode = p_command.camStatus.iMode;
            delegate.app_state.bCAMindex = p_command.camStatus.iCAMindex;
            delegate.app_state.bCAMnb = p_command.camStatus.iCAMnb;
        }
        if (p_command.camStatus.iErrCode != 0) {
            
            CommandGetCamStatusError *p_command = [[CommandGetCamStatusError alloc] initWithSocketConnection:self.connection state:delegate.app_state];
            [p_command execute];
        } else {
            delegate.app_state.bCamStatusError = @"";
        }
    }
}

- (void) init_state{
    //isWritingStarted = false;
}


- (void) update_ui{
    //
    // Update RN according to state
    //
    //
    //
    /*
    //dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *stateProps = [delegate.app_state getStateProps];
        
        RCTRootView *rootView = self.view;
        
        if ([stateProps isEqual:rootView.appProperties] == false)
        {
            // 1
            // unfortunately it does not update it each time after start
            // rootView.appProperties = [stateProps copy];
            // 2
            // Such method is depricated and worked only once
             [rootView.bridge.eventDispatcher sendDeviceEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
        }
        else
            NSLog(@"update_ui ignored");
    //});
    */
}

- (void) refresh: (id) sender {
    //
    // Determine necessarity to refresh settings & UI
    //
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *pServerPort = [standardUserDefaults stringForKey:[Constants sharedInstance].keyStrServerPort];
    NSUInteger server_port = [pServerPort intValue];
    NSString * server_ip = [standardUserDefaults stringForKey:[Constants sharedInstance].keyStrServerIP];
    //
    BOOL isModified = false;
    //
    if (server_port != m_server_port || server_ip != m_server_ip) {
        isModified = true;
    }
    
    //
    // Update state from the server
    //
    {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        ApplicationData *prevState = [delegate.app_state copy];

        [self doRefreshStateFromServer];
        
        if ([prevState isEqual:delegate.app_state] == NO) {
            isModified = true;
        }
    }

    if (isModified) {
        // Initialize setting before socket' params definition
        m_server_port = server_port;
        m_server_ip = server_ip;
        
        // Initialize Socket-connection
        self.connection = [[SocketConnection alloc] initWithAdress:m_server_ip port:m_server_port];
        

    }
    // Initialize UI
    [self init_state];
    [self update_ui];
}

@end
