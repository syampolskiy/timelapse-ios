#import "Command.h"
#import "SocketConnection.h"

@interface CommandGetWritingTime  : NSObject <Command>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
