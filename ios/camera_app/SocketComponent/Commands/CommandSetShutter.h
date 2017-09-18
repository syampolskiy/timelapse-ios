#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetShutter  : NSObject <Command>

@property (nonatomic) NSInteger shutter;

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
