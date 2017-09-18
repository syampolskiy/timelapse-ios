#import "Command.h"
#import "SocketConnection.h"

@interface CommandGetRemainWritingTime  : NSObject <Command>

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
