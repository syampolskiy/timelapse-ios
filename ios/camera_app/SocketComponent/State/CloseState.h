#import "State.h"
#import "SocketConnection.h"


@interface CloseState : NSObject <State>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection;

@end
