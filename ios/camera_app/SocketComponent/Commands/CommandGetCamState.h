#import "Command.h"
#import "SocketConnection.h"

@interface CommandGetCamState  : NSObject <Command>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
