//
//  Result.h


#import <Foundation/Foundation.h>

#import "Socket.h"


@interface Result : NSObject

@property (readonly, nonatomic) SocketErrorCode errorCode;
@property (readonly, nonatomic) BOOL isSuccess;
@property (readonly, nonatomic) BOOL isFailure;

+ (instancetype _Nonnull) success;
+ (instancetype _Nonnull) resultWithError: (SocketErrorCode) errorCode;

@end
