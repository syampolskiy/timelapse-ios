//
//  Socket.h


#import <Foundation/Foundation.h>

@interface Socket : NSObject

@property (readonly, copy, nonatomic, nonnull) NSString *address;
@property (readonly, nonatomic) NSUInteger port;
@property (copy, nonatomic, nullable) NSNumber *fd;

- (instancetype _Nullable) initWithAddress: (NSString * _Nonnull) a
                                      port: (NSUInteger) p;
@end


typedef enum {
    Socket_NoError = 0,
    Socket_QueryFailed,
    Socket_ConnectionClosed,
    Socket_ConnectionTimeout,
    Socket_UnknownError,
} SocketErrorCode;
