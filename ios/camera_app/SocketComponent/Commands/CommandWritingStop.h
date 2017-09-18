#import "Command.h"
#import "SocketConnection.h"

@interface CommandWritingStop  : NSObject <Command>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
