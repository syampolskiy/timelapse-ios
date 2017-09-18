//
//  CamAppBridge.h
//  camera_app
//
//  Created by MacPC on 6/20/17.
//  Copyright © 2017 jazzros. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

// interacting
// https://hashrocket.com/blog/posts/tips-and-tricks-from-integrating-react-native-with-existing-native-apps#sending-messages-from-native-code-to-react

@interface CamAppBridge : RCTEventEmitter <RCTBridgeModule>
/*
@property (strong, nonatomic) NSTimer *clockRepeaterTimer;

- (void) clockRepeater:(NSTimer *)time;
*/
@end
