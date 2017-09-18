//
//  ApplicationData.m
//  camera_app
//
//  Created by MacPC on 6/21/17.
//  Copyright © 2017 jazzros. All rights reserved.
//

#import "ApplicationData.h"
#import "AppDelegate.h"


@implementation ApplicationData
{
}

@synthesize pWritingProgressMS;
@synthesize bCamStatusError;
@synthesize bFootageList;
//
@synthesize bIsServerConnected;
@synthesize bStartStopWriting;
@synthesize bFPS;
@synthesize bExposure;
@synthesize bShutter;
@synthesize bWhiteBallance;
@synthesize bISO;
@synthesize bBrightness;
@synthesize bContrast;
@synthesize bSaturation;
@synthesize bSharpness;
@synthesize sVStreamURL;
@synthesize bStreamVideoMode;
@synthesize bCAMindex;
@synthesize bCAMnb;
@synthesize bPixFmtIndex;
@synthesize bCamResolutionIndex;


#pragma mark - Init Methods

- (id)init
{
    self = [super init];
    if (self) {
        //
        self.pWritingProgressMS = 0;
        self.bCamStatusError = @""; // no errors
        self.bFootageList = @""; // empty
        //
        self.bIsServerConnected = 0; // disconnected
        self.bStartStopWriting = 0; // Stopped
        self.bFPS = 30;
        self.bExposure = 0;
        self.bShutter = 10;
        self.bWhiteBallance = 5200; //
        self.bISO = 400;
        self.bBrightness = 0;
        self.bContrast = 50;
        self.bSaturation = 50;
        self.bSharpness = 50;
        self.sVStreamURL = @"";
        self.bStreamVideoMode = 1; // CAM mode
        self.bCAMindex = 0;
        self.bCAMnb = 1;
        self.bPixFmtIndex = 0; // 8bit
        self.bCamResolutionIndex = 0; // 2048x2048
    }
    return self;
}

- (void) updateCamResolutionIndex: (NSDictionary *)defStateProps value:(int) value {
    if (defStateProps == nil) return;
    
    switch (value) {
        case 0: {
            [defStateProps setValue:[NSString stringWithFormat:@"%@", @"2K"] forKey:@"resolution"];
            break;
        }
        case 1: {
            [defStateProps setValue:[NSString stringWithFormat:@"%@", @"1K"] forKey:@"resolution"];
            break;
        }
    }
}

- (void) updatePixFmtIndex: (NSDictionary *)defStateProps value:(int) value {
    if (defStateProps == nil) return;
    
    [defStateProps setValue:[NSNumber numberWithInt:value]
                     forKey:@"pixFmtInd"];
}

- (void) updateISO: (NSDictionary *)defStateProps value:(int) value {
    if (defStateProps == nil) return;
    
    [defStateProps setValue:[@(value) stringValue]
                     forKey:@"iso"];
}

- (void) updateShutter: (NSDictionary *)defStateProps value:(short) value {
    if (defStateProps == nil) return;
    
    [defStateProps setValue:[@(value) stringValue]
                     forKey:@"shutterspeed"];
}

- (void) updateAWB: (NSDictionary *)defStateProps value:(short) value {
    if (defStateProps == nil) return;
    
    [defStateProps setValue:[@(value) stringValue]
                     forKey:@"awb"];
}

- (void) updateFPS: (NSDictionary *)defStateProps value:(int) value {
    if (defStateProps == nil) return;
    
    [defStateProps setValue:[@(value) stringValue]
                     forKey:@"fps"];
}

- (void) updateEV: (NSDictionary *)defStateProps value:(int) value {
    if (defStateProps == nil) return;
    
    [defStateProps setValue:[NSString stringWithFormat:@"%.01f", fabs((float)value) / 10.0f - 7.5f]
                     forKey:@"exposure"];
}

- (void) updateBrightness: (NSDictionary *)defStateProps value:(int) value {
    if (defStateProps == nil) return;
    
    [defStateProps setValue:[NSString stringWithFormat:@"%@%@", [@(value) stringValue], @"%"]
                     forKey:@"brightness"];
}

- (void) updateFootageList: (NSDictionary *)defStateProps value:(NSString *) value {
    if (defStateProps == nil) return;
    
    NSArray *list = [value componentsSeparatedByString: @";"];
    
    [defStateProps setValue:list forKey:@"footageList"];
}

- (NSDictionary * _Nonnull) getStateProps {
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *defStateProps = [[NSMutableDictionary alloc] init];


    [defStateProps setValue:[NSNumber numberWithInt:delegate.app_state.bIsServerConnected]
        forKey:@"isServerConnected"];
    [defStateProps setValue:[NSNumber numberWithInt:delegate.app_state.bStartStopWriting]
        forKey:@"startStopWriting"];
    
    [self updateFPS:defStateProps value:delegate.app_state.bFPS];
    
    [self updateShutter:defStateProps value:delegate.app_state.bExposure];
    
    [defStateProps setValue:[NSNumber numberWithInt:(delegate.app_state.bExposure < 0 ? 1 : 0)]
                     forKey:@"isAutoExposure"];
    
    [self updateShutter:defStateProps value:delegate.app_state.bShutter];

    [self updateAWB:defStateProps value:delegate.app_state.bWhiteBallance];
    
    [self updateISO:defStateProps value:delegate.app_state.bISO];

    [self updateBrightness:defStateProps value:delegate.app_state.bBrightness];
    
    [defStateProps setValue:[NSString stringWithFormat:@"%@%@", [@(delegate.app_state.bContrast) stringValue], @"%"]
                     forKey:@"contrast"];
    [defStateProps setValue:[NSString stringWithFormat:@"%@%@", [@(delegate.app_state.bSaturation) stringValue], @"%"]
                     forKey:@"saturation"];
    [defStateProps setValue:[NSString stringWithFormat:@"%@%@", [@(delegate.app_state.bSharpness) stringValue], @"%"]
                     forKey:@"sharpness"];
    [defStateProps setValue:[NSNumber numberWithInt:delegate.app_state.pWritingProgressMS]
                     forKey:@"writingProgressMS"];
    [defStateProps setValue:[NSString stringWithFormat:@"%@", delegate.app_state.sVStreamURL]
                     forKey:@"VStreamURL"];
    switch (delegate.app_state.bStreamVideoMode) {
        case 0: {
            [defStateProps setValue:[NSString stringWithFormat:@"%@", @"2d"] forKey:@"viewActiveCamMode"];
            break;
        }
        case 1: {
            [defStateProps setValue:[NSString stringWithFormat:@"%@", @"cam"] forKey:@"viewActiveCamMode"];
            break;
        }
        case 2: {
            [defStateProps setValue:[NSString stringWithFormat:@"%@", @"pan"] forKey:@"viewActiveCamMode"];
            break;
        }
        case 3: {
            [defStateProps setValue:[NSString stringWithFormat:@"%@", @"vr"] forKey:@"viewActiveCamMode"];
            break;
        }
    }
    [defStateProps setValue:[NSNumber numberWithInt:delegate.app_state.bCAMindex]
                     forKey:@"currentCamera"];
    [defStateProps setValue:[NSNumber numberWithInt:delegate.app_state.bCAMnb]
                     forKey:@"CAMnb"];
    
    [self updatePixFmtIndex:defStateProps value:delegate.app_state.bPixFmtIndex];

    [self updateCamResolutionIndex:defStateProps value:delegate.app_state.bCamResolutionIndex];
    
    [defStateProps setValue:[NSString stringWithFormat:@"%@", delegate.app_state.bCamStatusError]
                     forKey:@"camStatusError"];
    
    [self updateFootageList:defStateProps value:delegate.app_state.bFootageList];
    
    return defStateProps;
}

- (void) fill :(SCameraState0 * _Nonnull)state0 {
    
    self.bFPS = state0->iFps;
    self.bExposure = state0->siExposure;
    self.bShutter = state0->iShutterSpeed;
    float absCoeff = (float)(abs(state0->iISO)-1)/32000.0f; // [0..1]
    float absISO = 400.0f + 800.0f * absCoeff;
    int intISO = (int)round(absISO) * (state0->iISO < 0 ? -1 : 1);
    self.bISO = intISO;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[ApplicationData class]]) {
        return NO;
    }
    
    ApplicationData * other = (ApplicationData *)object;
    
    
    if (self.bIsServerConnected != other.bIsServerConnected)
        return NO;
    if (self.bStartStopWriting != other.bStartStopWriting)
        return NO;
    if (self.bFPS != other.bFPS)
        return NO;
    if (self.bExposure != other.bExposure)
        return NO;
    if (self.bShutter != other.bShutter)
        return NO;
    if (self.bWhiteBallance != other.bWhiteBallance)
        return NO;
    if (self.bISO != other.bISO)
        return NO;
    if (self.bBrightness != other.bBrightness)
        return NO;
    if (self.bContrast != other.bContrast)
        return NO;
    if (self.bSaturation != other.bSaturation)
        return NO;
    if (self.bSharpness != other.bSharpness)
        return NO;
    if (![self.sVStreamURL isEqualToString: other.sVStreamURL])
        return NO;
    if (self.bStreamVideoMode != other.bStreamVideoMode)
        return NO;
    if (self.bCAMindex != other.bCAMindex)
        return NO;
    if (self.bCAMnb != other.bCAMnb)
        return NO;
    if (self.bPixFmtIndex != other.bPixFmtIndex)
        return NO;
    if (self.bCamResolutionIndex != other.bCamResolutionIndex)
        return NO;

    return YES;
}


- (NSArray *)keys {
    static dispatch_once_t once;
    static NSArray *keys = nil;
    dispatch_once(&once, ^{
        keys = [NSArray arrayWithObjects:
                @"bIsServerConnected",
                @"bStartStopWriting",
                @"bFPS",
                @"bExposure",
                @"bShutter",
                @"bWhiteBallance",
                @"bISO",
                @"bBrightness",
                @"bContrast",
                @"bSaturation",
                @"bSharpness",
                @"sVStreamURL",
                @"bStreamVideoMode",
                @"bCAMindex",
                @"bCAMnb",
                @"bPixFmtIndex",
                @"bCamResolutionIndex",
                nil];
    });
    return keys;
}

- (id) copyWithZone:(NSZone *) zone {
    ApplicationData *data = [[[self class] allocWithZone:zone] init];
    if(data) {
        data.bIsServerConnected = bIsServerConnected;
        data.bStartStopWriting = bStartStopWriting;
        data.bFPS = bFPS;
        data.bExposure = bExposure;
        data.bShutter = bShutter;
        data.bWhiteBallance = bWhiteBallance;
        data.bISO = bISO;
        data.bBrightness = bBrightness;
        data.bContrast = bContrast;
        data.bSaturation = bSaturation;
        data.bSharpness = bSharpness;
        data.sVStreamURL = [sVStreamURL copy];
        data.bStreamVideoMode = bStreamVideoMode;
        data.bCAMindex = bCAMindex;
        data.bCAMnb = bCAMnb;
        data.bPixFmtIndex = bPixFmtIndex;
        data.bCamResolutionIndex = bCamResolutionIndex;
    }
    return data;
}

#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *) coder {
    //[super encodeWithCoder:coder];
    
    NSDictionary *pairs = [self dictionaryWithValuesForKeys:[self keys]];
    NSArray * keysloc = self.keys;
    for(NSString *key in keysloc) {
        [coder encodeObject:[pairs objectForKey:key] forKey:key];
    }
}


- (id) initWithCoder:(NSCoder *) decoder {
    //self = [super initWithCoder:decoder];
    
    if(self) {
        for(NSString *key in [self keys]) {
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

@end
