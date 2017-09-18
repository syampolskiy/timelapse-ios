#import "State.h"
#import "SocketConnection.h"


@interface SendState : NSObject <State>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection;

@end
