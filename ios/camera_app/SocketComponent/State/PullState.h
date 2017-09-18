#import "State.h"
#import "SocketConnection.h"


@interface PullState : NSObject <State>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection;

@end
