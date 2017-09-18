//
//  AppDelegate.m
//  camera_app
//
//  Created by MacPC on 6/12/17.
//  Copyright © 2017 jazzros. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants/Constants.h"


#import <React/RCTBundleURLProvider.h>
#import <React/RCTEventDispatcher.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize rn_bridge;
@synthesize rootViewController;
@synthesize app_state;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.
    
    //
    // Obtain bridge to React Native
    //
    NSURL *jsCodeLocation = nil;
#if DEBUG
    NSLog(@"AppDelegate:DEBUG");
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"AppDelegate:DEBUG:TARGET_IPHONE_SIMULATOR");
    jsCodeLocation = [NSURL URLWithString:@"http://localhost:8081/index.ios.bundle"];
#else
    NSLog(@"AppDelegate:DEBUG:!TARGET_IPHONE_SIMULATOR");
    NSLog(@"To device debug, open RCTWebSocketExecutor.m & replace localhost with MacBook IP.");
    // Get dev host IP Address:
    //    ifconfig | grep inet\ | tail -1 | cut -d " " -f 2
    jsCodeLocation = [NSURL URLWithString:@"http://172.17.29.213:8081/index.ios.bundle"];
#endif
    
#else
    NSLog(@"AppDelegate:RELEASE jsbundle");
    jsCodeLocation = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
    
    NSLog(@"jsCodeLocation = %@",jsCodeLocation);
    
    rn_bridge = [[RCTBridge alloc] initWithBundleURL:jsCodeLocation
                                   moduleProvider:nil
                                    launchOptions:launchOptions];
    //
    // Register setting
    // Note: tests on the real device demonstrate that registering should be done
    // without any precondition. Otherwise it will be artifact when some props will
    // not be found via standart acessing
    //
    [self registerDefaultsFromSettingsBundle];
    //
    // Re-store data
    // It will load or create(default) state object \app_state
    [self loadApplicationDataFromFlatFile];
    
    //
    // Connect to React Native view with custom ViewController
    //

    //
    // Obtain presaved state
    //
    NSDictionary *presavedStateProps = [self.app_state getStateProps];
    
    RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:self.rn_bridge
                                             moduleName:@"RNCameraApp"
                                             initialProperties : presavedStateProps];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    rootViewController = [[ViewController alloc] initEx];
    rootViewController.view = rootView;
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Store data
    [self saveApplicationDataToFlatFile];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //
    // Each start will ask server for actual state
    // todo: actually, there is no trivial task to send events from AppDelegate to RN.
    // the simpliest way to use \RCTRootView but it does not guaranty that his bridge in actual state.
    RCTRootView * rootView = rootViewController.view;
    [rootView.bridge.eventDispatcher sendAppEventWithName:@"EventReminder"
                                           body:@{@"name": @"udtStateFromServer"}];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // Store data
    [self saveApplicationDataToFlatFile];
}

- (void)registerDefaultsFromSettingsBundle {

    // this function writes default settings as settings
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
            NSLog(@"writing as default %@ to the key %@",[prefSpecification objectForKey:@"DefaultValue"],key);
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    
}

- (NSString *)_dataFilePath {
    static NSString *path = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        path = [documentsDirectory stringByAppendingPathComponent:@"xAppData.dat"];
    });
    return path;
}

- (void)loadApplicationDataFromUserDefaults {
    NSData *archivedData = [[NSUserDefaults standardUserDefaults] objectForKey:@"appData"];
    self.app_state = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
}

- (void)saveApplicationDataToUserDefaults {
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.app_state];
    [[NSUserDefaults standardUserDefaults] setObject:archivedData forKey:@"appData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadApplicationDataFromFlatFile {
    NSData *archivedData = [NSData dataWithContentsOfFile:[self _dataFilePath]];
    self.app_state = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    if (self.app_state == nil)
    {
        self.app_state = [ApplicationData alloc].init;
        [self saveApplicationDataToFlatFile];
    }
}

- (void)saveApplicationDataToFlatFile {
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.app_state];
    [archivedData writeToFile:[self _dataFilePath] atomically:YES];
}

@end
