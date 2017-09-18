

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Constants : NSObject

+ (instancetype _Nonnull) sharedInstance;

@property (readonly, nonatomic, nonnull) NSString *rootSavingPath;
//@property (readonly, nonatomic) NSInteger someNum;
// Key-values for Settings access (see Settings.bundle.en.lproj.Root.plist)
@property (readonly, nonatomic, nonnull) NSString *keyStrServerPort;
@property (readonly, nonatomic, nonnull) NSString *keyStrServerIP;
//
@property (readonly, nonatomic, nonnull) UIColor* colorStartWriting;
@property (readonly, nonatomic, nonnull) UIColor* colorStopWriting;


@end
