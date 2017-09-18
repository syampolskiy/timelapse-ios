#import <Foundation/Foundation.h>
#import "ApplicationData.h"

@protocol Command <NSObject>

- (void)execute;

@end
