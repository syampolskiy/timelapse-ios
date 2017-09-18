//
//  AppDelegate.h
//  camera_app
//
//  Created by MacPC on 6/12/17.
//  Copyright © 2017 jazzros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTRootView.h>
#import "ViewController.h"
#import "ApplicationData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RCTBridge *rn_bridge;
@property (nonatomic, strong) ViewController * rootViewController;

@property (nonatomic, strong) ApplicationData * app_state;

- (void)saveApplicationDataToFlatFile;
- (void)loadApplicationDataFromFlatFile;
- (void)saveApplicationDataToUserDefaults;
- (void)loadApplicationDataFromUserDefaults;

@end

