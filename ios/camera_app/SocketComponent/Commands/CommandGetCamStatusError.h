#import "Command.h"
#import "SocketConnection.h"

@interface CommandGetCamStatusError  : NSObject <Command>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
