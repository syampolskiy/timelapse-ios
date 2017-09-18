#import "Command.h"
#import "SocketConnection.h"

@interface CommandGetCamState0  : NSObject <Command>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
