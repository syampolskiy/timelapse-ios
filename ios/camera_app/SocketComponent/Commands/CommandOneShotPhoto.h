#import "Command.h"
#import "SocketConnection.h"

@interface CommandOneShotPhoto  : NSObject <Command>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
