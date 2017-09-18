//
//  ApplicationData.h
//  camera_app
//
//  Created by MacPC on 6/21/17.
//  Copyright © 2017 jazzros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../../../camera_ctrl/Packet.h"

// https://stackoverflow.com/questions/8727508/ios-persistent-storage-strategy
// https://www.raywenderlich.com/1914/nscoding-tutorial-for-ios-how-to-save-your-app-data
//
@interface ApplicationData : NSObject  <NSCopying, NSCoding>

- (id)init;
// Params which not serialized localy
@property (nonatomic) int pWritingProgressMS;
@property (nonatomic, nonnull)NSString * bCamStatusError; // camera status error msg. Empty-No Errors
@property (nonatomic, nonnull)NSString * bFootageList; // string list of delimeted by ';'
// Serialized localy params
@property (nonatomic) int bIsServerConnected; // 0:disconnected,1:connected
@property (nonatomic) int bStartStopWriting; // 1:Started,0:Stopped
@property (nonatomic) int bFPS; // 30,60,90,Negative-IsAutoMode
@property (nonatomic) int bExposure; // -99..99 (manual corresponds to val/10-7.5) and -val/10-7.5(automatic)
@property (nonatomic) short bShutter; // - .. +. Negative means param in auto-mode
@property (nonatomic) short bWhiteBallance; // Kelvein [-10000..-2000],[2000..10000]
@property (nonatomic) int bISO; // 400,500,600,700,800,900,1000,1100,1200,and negative for AutoMode
@property (nonatomic) int bBrightness; // percent: 0..100
@property (nonatomic) int bContrast; // percent 0..100
@property (nonatomic) int bSaturation; // percent 0..100
@property (nonatomic) int bSharpness; // percent 0..100
@property (nonatomic, nonnull)NSString * sVStreamURL;
@property (nonatomic) int bStreamVideoMode; // Video Stream Camera Mode. Range: [0..3],
                                        // 0: 2D, 1: CAM, 2: Panoram, 3: Stereoscopic
@property (nonatomic) int bCAMindex; // Zero-based Index of current streaming cam for mode 2D
@property (nonatomic) int bCAMnb; // Number of cameras which could be accessed in CAM-mode
@property (nonatomic) int bPixFmtIndex; //0:8bit,1:12bit,2:16bit
@property (nonatomic) int bCamResolutionIndex; //0:2048x2048,1:1024x1024

- (void) fill :(SCameraState0 * _Nonnull)state0;
- (NSDictionary * _Nonnull) getStateProps;


//
- (void) updateCamResolutionIndex: (NSDictionary *)defStateProps value:(int) value;
- (void) updatePixFmtIndex: (NSDictionary *)defStateProps value:(int) value;
- (void) updateISO: (NSDictionary *)defStateProps value:(int) value;
- (void) updateShutter: (NSDictionary *)defStateProps value:(short) value;
- (void) updateAWB: (NSDictionary *)defStateProps value:(short) value;
- (void) updateFPS: (NSDictionary *)defStateProps value:(int) value;
- (void) updateEV: (NSDictionary *)defStateProps value:(int) value;
- (void) updateBrightness: (NSDictionary *)defStateProps value:(int) value;
- (void) updateFootageList: (NSDictionary *)defStateProps value:(NSString *) value;


@end
