//
//  CamAppBridge.m
//  camera_app
//
//  Created by MacPC on 6/20/17.
//  Copyright © 2017 jazzros. All rights reserved.
//

#import "CamAppBridge.h"
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import "Constants/Constants.h"
#import "AppDelegate.h"

@implementation CamAppBridge
{
}

BOOL isWritingProgressAskRemainTiming = false;

// According to list from MainNav.js
// todo: could be exported via \constantsToExport and reused in JS
+ (NSArray *)settingsList
{
    static NSArray *_list = nil;
    static dispatch_once_t onceToken;
    if (_list == nil) dispatch_once(&onceToken, ^{
        _list = @[@"resolution",
                  @"format",
                  @"iso",
                  @"shutterspeed",
                  @"awb",
                  @"fps",
                  @"exposure",
                  @"timelapse",
                  @"brightness",
                  @"photoVideoMode",
                  @"CamStateCurrentCam",
                  @"CamStateCamMode",
                  @"contrast",
                  @"saturation",
                  @"sharpness"];
        });
    return _list;
}
+ (NSArray *)resulutionList
{
    static NSArray *_list = nil;
    static dispatch_once_t onceToken;
    if (_list == nil) dispatch_once(&onceToken, ^{
        _list = @[@"2K",
                  @"1K"];
        });
    return _list;
}
+ (NSArray *)formatList
{
    static NSArray *_list = nil;
    static dispatch_once_t onceToken;
    if (_list == nil) dispatch_once(&onceToken, ^{
        _list = @[@"8 bit",
                  @"12 bit",
                  @"16 bit"];
        });
    return _list;
}
+ (NSArray *)timelapseList
{
    static NSArray *_list = nil;
    static dispatch_once_t onceToken;
    if (_list == nil) dispatch_once(&onceToken, ^{
        _list = @[@"x1",
                  @"x2",
                  @"x3"];
        });
    return _list;
}
+ (NSArray *)camStateCamMode
{
    static NSArray *_list = nil;
    static dispatch_once_t onceToken;
    if (_list == nil) dispatch_once(&onceToken, ^{
        _list =  @[@"2d",
                   @"cam",
                   @"pan",
                   @"vr"];
        });
    return _list;
}



// Export a module named CamAppBridge
RCT_EXPORT_MODULE();

// This would name the module AwesomeCamAppBridge instead
// RCT_EXPORT_MODULE(AwesomeCamAppBridge);



- (NSDictionary *)constantsToExport
{
    return @{ @"firstConst": @"ConstValue1",
              @"secondConst": @"ConstValue2"};
}


RCT_EXPORT_METHOD(toggleWritingProgress)
{
    isWritingProgressAskRemainTiming = ! isWritingProgressAskRemainTiming;
    /*
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (delegate != nil) {
        if (delegate.app_state.bStartStopWriting == 0 &&
            delegate.app_state.bIsServerConnected != 0) { // if stopped, re-ask new state
            [self  clockRepeater:nil];
        }
    }
     */
}

RCT_EXPORT_METHOD(pickButton:(NSString *)btnName)
{
    //
    // Emit event with name corresponded to button's name
    //
    [self sendEventWithName:@"EventReminder" body:@{@"name": btnName}];
}

RCT_EXPORT_METHOD(pickSettings:(NSString *)settingName value:(NSString *)value state:(NSDictionary*)state)
{
    NSArray *settingsList = [[self class] settingsList];
    NSArray *resulutionList = [[self class] resulutionList];
    NSArray *formatList = [[self class] formatList];
    NSArray *timelapseList = [[self class] timelapseList];
    NSArray *camStateCamMode = [[self class] camStateCamMode];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate == nil) return;
    ViewController *viewController = delegate.rootViewController;
    if (viewController == nil) return;
    
    NSUInteger settingIndex = [settingsList indexOfObject:settingName];
    switch (settingIndex) {
        case 0: // resolution
        {
            NSUInteger valueIndex = [resulutionList indexOfObject:value];

            dispatch_queue_t myQueue = dispatch_queue_create("doSetCamResolution", NULL);
            dispatch_async(myQueue, ^{
                [viewController doSetCamResolution:valueIndex];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            if (state != nil) [delegate.app_state updateCamResolutionIndex:state value:valueIndex];
            break;
        }
        case 1: // format
        {
            NSUInteger valueIndex = [formatList indexOfObject:value];

            dispatch_queue_t myQueue = dispatch_queue_create("doSetBPP", NULL);
            dispatch_async(myQueue, ^{
                [viewController doSetBPP:valueIndex];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            if (state != nil) [delegate.app_state updatePixFmtIndex:state value:valueIndex];
            break;
        }
        case 2: // iso
        {
            int iso = [value isEqualToString:@"Auto"] ? -1 : [value intValue];
            int value = iso;
            if (value < 0)
                value = -abs(delegate.app_state.bISO);

            dispatch_queue_t myQueue = dispatch_queue_create("doSetISO", NULL);
            dispatch_async(myQueue, ^{
                [viewController doSetISO:value];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            if (state != nil) [delegate.app_state updateISO:state value:value];
            break;
        }
        case 3: // shutterspeed
        {
            int iShutter = [value isEqualToString:@"Auto"] ? -1 : 1000.0f / [value floatValue];
            int value = iShutter;
            if (value < 0)
                value = -abs(delegate.app_state.bShutter);
            
            dispatch_queue_t myQueue = dispatch_queue_create("doSetShutterspeed", NULL);
            dispatch_async(myQueue, ^{
                [viewController doSetShutterspeed:value];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            if (state != nil) [delegate.app_state updateShutter:state value:value];
            break;
        }
        case 4: // awb
        {
            int iKelvin = [value isEqualToString:@"Auto"] ? -1 : [value intValue];
            int value = iKelvin;
            if (value < 0)
                value = -abs(delegate.app_state.bWhiteBallance);

            dispatch_queue_t myQueue = dispatch_queue_create("doSetAWB", NULL);
            dispatch_async(myQueue, ^{
                [viewController doSetAWB:value];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            if (state != nil) [delegate.app_state updateAWB:state value:value];
            break;
        }
        case 5: // fps
        {
            int fps = [value isEqualToString:@"Auto"] ? -1 : [value intValue];
            int value = fps;
            if (value < 0)
                value = -abs(delegate.app_state.bFPS);
            int absFrameTime_ms = floor(1000 / abs(value));

            dispatch_queue_t myQueue = dispatch_queue_create("doSetFps", NULL);
            dispatch_async(myQueue, ^{
                [viewController doSetFps:value];
                if (1000 / delegate.app_state.bShutter > absFrameTime_ms)
                    [viewController doSetShutterspeed:absFrameTime_ms];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            if (state != nil) {
                [delegate.app_state updateFPS:state value:value];
                if (1000 / delegate.app_state.bShutter > absFrameTime_ms)
                    [delegate.app_state updateShutter:state value:absFrameTime_ms];
            }
            break;
        }
        case 6: // exposure
        {
            float fExposure = [value floatValue];
            int iExposure = 10 * (fExposure + 7.5);
            
            dispatch_queue_t myQueue = dispatch_queue_create("doSetExposure", NULL);
            dispatch_async(myQueue, ^{
                // Reset ISO and ShutterSpeed to auto
                if (delegate.app_state.bShutter > 0)
                    [viewController doSetShutterspeed: -delegate.app_state.bShutter];
                if (delegate.app_state.bISO > 0)
                    [viewController doSetISO: -delegate.app_state.bISO];
                [viewController doSetExposure:iExposure];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            if (state != nil) {
                if (delegate.app_state.bShutter > 0)
                    [delegate.app_state updateShutter:state value:-delegate.app_state.bShutter];
                if (delegate.app_state.bISO > 0)
                    [delegate.app_state updateISO:state value:-delegate.app_state.bISO];
                [delegate.app_state updateEV:state value:iExposure];
            }
            break;
        }
        case 7: // timelapse
        {
            NSUInteger valueIndex = [timelapseList indexOfObject:value];
            break;
        }
        case 8: // brightness
        {
            // remove last char "%"
            value = [value substringToIndex:value.length-(value.length>0)];
            int valuePercent = [value intValue];

            dispatch_queue_t myQueue = dispatch_queue_create("doSetBrightness", NULL);
            dispatch_async(myQueue, ^{
                [viewController doSetBrightness:valuePercent];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //stuffs to do in foreground thread, mostly UI updates
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            if (state != nil) [delegate.app_state updateBrightness:state value:valuePercent];
            break;
        }
        case 9: // photoVideoMode
        {
                int photoVideoMode = [value intValue];
                //
                // Shadow thread strategy for slow methods worked with network
                //
                dispatch_queue_t myQueue = dispatch_queue_create("switchPhotoVideoMode", NULL);
                dispatch_async(myQueue, ^{
                    //stuffs to do in background thread
                    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (delegate != nil) {
                        ViewController *viewController = delegate.rootViewController;
                        
                        if (viewController != nil) {
                            // If new mode is PHOTO
                            if (photoVideoMode == 1) {
                                // Turn off camera writing
                                if (delegate.app_state.bStartStopWriting != 0) {
                                    [viewController doStartStopWriting:0];
                                    //[self clockRepeaterStop];
                                }
                            }
                        }
                    }
                    // All necessary UI updating done in RN-UI
                    /*
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //stuffs to do in foreground thread, mostly UI updates
                        [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                    });
                     */
                });

            break;
        }
        case 10: { // CamStateCurrentCam
            int newCamIndex = [value intValue];
            //
            // Shadow thread strategy for slow methods worked with network
            //
            dispatch_queue_t myQueue = dispatch_queue_create("doSetCamStateCurrentCam", NULL);
            dispatch_async(myQueue, ^{
                //stuffs to do in background thread
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (delegate != nil) {
                    ViewController *viewController = delegate.rootViewController;
                    
                    if (viewController != nil) {
                        [viewController doSetCamStateCurrentCam:newCamIndex];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //stuffs to do in foreground thread, mostly UI updates
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            break;
        }
        case 11: { // CamStateCamMode
            NSUInteger modeIndex = [camStateCamMode indexOfObject:value];
            //
            // Shadow thread strategy for slow methods worked with network
            //
            dispatch_queue_t myQueue = dispatch_queue_create("doSetCamStateCamMode", NULL);
            dispatch_async(myQueue, ^{
                //stuffs to do in background thread
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (delegate != nil) {
                    ViewController *viewController = delegate.rootViewController;
                    
                    if (viewController != nil) {
                        [viewController doSetCamStateCamMode:modeIndex];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //stuffs to do in foreground thread, mostly UI updates
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            break;
        }
        case 12: { // contrast
            // remove last char "%"
            value = [value substringToIndex:value.length-(value.length>0)];
            int valuePercent = [value intValue];
            //
            // Shadow thread strategy for slow methods worked with network
            //
            dispatch_queue_t myQueue = dispatch_queue_create("doSetContrast", NULL);
            dispatch_async(myQueue, ^{
                //stuffs to do in background thread
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (delegate != nil) {
                    ViewController *viewController = delegate.rootViewController;
                    
                    if (viewController != nil) {
                        [viewController doSetContrast:valuePercent];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //stuffs to do in foreground thread, mostly UI updates
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            break;
        }
        case 13: { // saturation
            // remove last char "%"
            value = [value substringToIndex:value.length-(value.length>0)];
            int valuePercent = [value intValue];
            //
            // Shadow thread strategy for slow methods worked with network
            //
            dispatch_queue_t myQueue = dispatch_queue_create("doSetSaturation", NULL);
            dispatch_async(myQueue, ^{
                //stuffs to do in background thread
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (delegate != nil) {
                    ViewController *viewController = delegate.rootViewController;
                    
                    if (viewController != nil) {
                        [viewController doSetSaturation:valuePercent];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //stuffs to do in foreground thread, mostly UI updates
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            break;
        }
        case 14: { // sharpness
            // remove last char "%"
            value = [value substringToIndex:value.length-(value.length>0)];
            int valuePercent = [value intValue];
            //
            // Shadow thread strategy for slow methods worked with network
            //
            dispatch_queue_t myQueue = dispatch_queue_create("doSetSharpness", NULL);
            dispatch_async(myQueue, ^{
                //stuffs to do in background thread
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (delegate != nil) {
                    ViewController *viewController = delegate.rootViewController;
                    
                    if (viewController != nil) {
                        [viewController doSetSharpness:valuePercent];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //stuffs to do in foreground thread, mostly UI updates
                    [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                });
            });
            break;
        }
    }
}

RCT_REMAP_METHOD(syncPickSettings,
                 state:(NSDictionary *)state
                 settingName:(NSString *)settingName
                 value:(NSString *)value
                 findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (state && delegate) {
        NSMutableDictionary *newState = [state mutableCopy];
        [self pickSettings:settingName value:value state:newState];
        resolve(newState);
    } else {
        NSError *error = nil;
        reject(@"no_props", @"There were no props", error);
    }
}

RCT_REMAP_METHOD(processEvents,
                 state:(NSDictionary *)state
                 eventName:(NSString *)eventName
                 findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (state && delegate) {
        //
        NSNumber *startStopWritingData = [RCTConvert NSNumber:state[@"startStopWriting"]];
        NSNumber *photoVideoModeData = [RCTConvert NSNumber:state[@"photoVideoMode"]];
        
        NSArray *eventNameList = @[@"startStopWriting",
                                   @"udtStateFromServer",
                                   @"udtCamState0",
                                   @"udtCamStatusError",
                                   @"updateState",
                                   @"doUpdateWritingProgress",
                                   @"updateWritingProgress",
                                   @"updateFootageList"];
        NSUInteger itemIndex = [eventNameList indexOfObject:eventName];
        switch (itemIndex) {
            case 0: // startStopWriting
            {
                if (startStopWritingData && photoVideoModeData) {
                    int photoVideoMode = photoVideoModeData.intValue;
                    if (photoVideoMode == 1) // PHOTO mode
                    {
                        //
                        // Shadow thread strategy for slow methods worked with network
                        //
                        dispatch_queue_t myQueue = dispatch_queue_create("doStartStopWriting", NULL);
                        dispatch_async(myQueue, ^{
                            //stuffs to do in background thread
                            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            if (delegate != nil) {
                                ViewController *viewController = delegate.rootViewController;
                                
                                if (viewController != nil) {
                                    [viewController doOneShotPhoto];
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //stuffs to do in foreground thread, mostly UI updates
                                // Does making one photo needs to update UI?
                                // Yes, because it could update Connection state
                                [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                            });
                        });
                    } else // VIDEO mode
                    {
                        //
                        // Switch current value
                        //
                        int needsToStart = startStopWritingData.intValue;
                        needsToStart = needsToStart == 0 ? 1 : 0;
                        //
                        // Update state imideately(in current thread) to prevent button blick
                        //
                        NSMutableDictionary *newDict = [state mutableCopy];
                        [newDict setObject:[NSNumber numberWithInt:needsToStart] forKey:@"startStopWriting"];
                        state = newDict;
                        
                        //
                        // Shadow thread strategy for slow methods worked with network
                        //
                        dispatch_queue_t myQueue = dispatch_queue_create("doStartStopWriting", NULL);
                        dispatch_async(myQueue, ^{
                            //stuffs to do in background thread
                            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            if (delegate != nil) {
                                ViewController *viewController = delegate.rootViewController;
                                
                                if (viewController != nil) {
                                    [viewController doStartStopWriting:needsToStart];
                                    /*
                                    if (delegate.app_state.bStartStopWriting != 0)
                                        [self clockRepeaterStart];
                                    else
                                        [self clockRepeaterStop];
                                    */
                                }
                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //stuffs to do in foreground thread, mostly UI updates
                                [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                            });
                        });
                    }
                }
                break;
            }
            case 1: // udtStateFromServer
            {
                NSLog (@" >>> udtStateFromServer <<< ");
                //
                // Shadow thread strategy for slow methods worked with network
                //
                dispatch_queue_t myQueue = dispatch_queue_create("doRefreshStateFromServer",
                                                                 DISPATCH_QUEUE_SERIAL);
                dispatch_async(myQueue, ^{
                    //stuffs to do in background thread
                    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (delegate != nil) {
                        ViewController *viewController = delegate.rootViewController;
                        
                        if (viewController != nil) {
                            [viewController doRefreshStateFromServer];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //stuffs to do in foreground thread, mostly UI updates
                        [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                    });
                });
                
                break;
            }
            case 2: // udtCamState0
            {
                //
                // Shadow thread strategy for slow methods worked with network
                //
                dispatch_queue_t myQueue = dispatch_queue_create("doGetCamState0",
                                                                 DISPATCH_QUEUE_SERIAL);
                dispatch_async(myQueue, ^{
                    //stuffs to do in background thread
                    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (delegate != nil) {
                        ViewController *viewController = delegate.rootViewController;
                        
                        // Update camera status error message only
                        if (viewController != nil) {
                            [viewController doGetCamState0];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //stuffs to do in foreground thread, mostly UI updates
                        [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                    });
                });
                
                break;
            }
            case 3: // udtCamStatusError
            {
                //
                // Shadow thread strategy for slow methods worked with network
                //
                dispatch_queue_t myQueue = dispatch_queue_create("doUdtCamStatusError",
                                                                 DISPATCH_QUEUE_SERIAL);
                dispatch_async(myQueue, ^{
                    //stuffs to do in background thread
                    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (delegate != nil) {
                        ViewController *viewController = delegate.rootViewController;
                        
                        // Update camera status error message only
                        if (viewController != nil) {
                            [viewController doUpdateCamStatus:true];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //stuffs to do in foreground thread, mostly UI updates
                        [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateState"}];
                    });
                });
                
                break;
            }
            case 4: // updateState
            {
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (delegate != nil) {
                    state = [delegate.app_state.getStateProps copy];
                }
                break;
            }
            case 5: // doUpdateWritingProgress
            {
                dispatch_queue_t myQueue = dispatch_queue_create("doUpdateWritingProgress",
                                                                 DISPATCH_QUEUE_SERIAL);
                dispatch_async(myQueue, ^{
                    //stuffs to do in background thread
                    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    if (delegate != nil) {
                        ViewController *viewController = delegate.rootViewController;
                        
                        if (viewController != nil) {
                            
                            if (isWritingProgressAskRemainTiming)
                                [viewController doGetRemainWritingTime];
                            else
                                [viewController doGetWritingTime];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //stuffs to do in foreground thread, mostly UI updates
                        [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateWritingProgress"}];
                    });
                });

                break;
            }
            case 6: // updateWritingProgress
            {
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (delegate != nil) {
                    NSDictionary *defStateProps = [[NSMutableDictionary alloc] init];

                    [defStateProps setValue:[NSNumber numberWithInt:delegate.app_state.pWritingProgressMS]
                                     forKey:@"writingProgressMS"];

                    [defStateProps setValue:[NSNumber numberWithInt:delegate.app_state.bIsServerConnected]
                                     forKey:@"isServerConnected"];
                    state = [defStateProps copy];
                }
                break;
            }
            case 7: // updateFootageList
            {
                //stuffs to do in background thread
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if (delegate != nil) {
                    ViewController *viewController = delegate.rootViewController;
                    
                    if (viewController != nil) {
                        int isVideoOrShots = (photoVideoModeData.intValue == 0) ? 1 : 0;
                        [viewController doGetFootageList:isVideoOrShots firstIndex:0 lastIndex:100];
                        
                        NSMutableDictionary *newDict = [state mutableCopy];
                        [delegate.app_state updateFootageList:newDict value: delegate.app_state.bFootageList];
                        state = newDict;
                    }
                }
            }
        }
        /*
        NSNumber * isConnectedNumber = [RCTConvert NSNumber:state[@"isServerConnected"]];
        int isConnectedIntValue = isConnectedNumber.intValue;
        if (isConnectedIntValue != 1)
        {
            int checkvalue = 0;
        }
        */
        
        resolve(state);
    } else {
        NSError *error = nil;
        reject(@"no_props", @"There were no props", error);
    }
}
/*
- (void) clockRepeaterStart
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        // Prevent repeat starting
        //
        [_clockRepeaterTimer invalidate];
        _clockRepeaterTimer = nil;
        
        _clockRepeaterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clockRepeater:) userInfo:nil repeats:YES];
    });
    
}
- (void) clockRepeaterStop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_clockRepeaterTimer invalidate];
        _clockRepeaterTimer = nil;
    });
    
}

- (void) clockRepeater:(NSTimer *)time
{
    dispatch_queue_t myQueue = dispatch_queue_create("updateWritingProgress",
                                                     DISPATCH_QUEUE_SERIAL);
    dispatch_async(myQueue, ^{
        //stuffs to do in background thread
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate != nil) {
            ViewController *viewController = delegate.rootViewController;
            
            if (viewController != nil) {
                
                if (isWritingProgressAskRemainTiming)
                    [viewController doGetRemainWritingTime];
                else
                    [viewController doGetWritingTime];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //stuffs to do in foreground thread, mostly UI updates
            [self sendEventWithName:@"EventReminder" body:@{@"name": @"updateWritingProgress"}];
        });
    });
}
*/

#pragma mark - RCTEventEmitter

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventReminder"];
}


@end
