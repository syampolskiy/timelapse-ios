#import "Command.h"
#import "SocketConnection.h"

@interface CommandWritingStart  : NSObject <Command>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
