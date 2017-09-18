//
//  ViewController.h
//  camera_app
//
//  Created by MacPC on 6/12/17.
//  Copyright © 2017 jazzros. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

- (instancetype _Nullable) initEx;

- (void) doRefreshStateFromServer;
- (void) doUpdateCamStatus:(BOOL)errorMsgOnly;
- (void) doGetCamState0;
- (void) doStartStopWriting:(int)needsToStart;
- (void) doOneShotPhoto;
- (void) doSetFps:(int)fps;
- (void) doSetISO:(int)iso;
- (void) doSetBPP:(int)bppIndex;
- (void) doSetCamResolution:(int)resolutionIndex;
- (void) doSetAWB:(int)awb;
- (void) doSetExposure:(int)exposure;
- (void) doSetShutterspeed:(int)shutter;
- (void) doSetBrightness:(int)brightness;
- (void) doSetContrast:(int)contrast;
- (void) doSetSaturation:(int)saturation;
- (void) doSetSharpness:(int)sharpness;
- (void) doGetWritingTime;
- (void) doGetRemainWritingTime;
- (void) doSetCamStateCurrentCam:(int)newCamIndex;
- (void) doSetCamStateCamMode:(int)modeIndex;
- (void) doGetFootageList:(int)isVideoOrShot firstIndex:(int)firstIndex lastIndex:(int)lastIndex;

- (void) update_ui;
@end

