#import "State.h"
#import "SocketConnection.h"


@interface ConnectState : NSObject <State>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection;

@end
