#import "State.h"
#import "../TCPClient.h"

/**
 @brief: State-pattern implements step-strategy for dealing with socket
 */
@interface SocketConnection : NSObject

@property (strong, nonatomic, readonly) id<State> connectState;
@property (strong, nonatomic, readonly) id<State> sendState;
@property (strong, nonatomic, readonly) id<State> pullState;
@property (strong, nonatomic, readonly) id<State> closeState;

@property (strong, nonatomic) id<State> state;
@property (strong,nonatomic) TCPClient *tcpClient;


- (id)initWithAdress:(NSString * _Nonnull) a
              port: (NSUInteger) p;

- (NSString *)connect;
- (int)send:(NSString *)message;
- (int)sendPacket:(cmp_pack *)packet;
- (cmp_pack)pull;
- (NSString *)close;

@end
