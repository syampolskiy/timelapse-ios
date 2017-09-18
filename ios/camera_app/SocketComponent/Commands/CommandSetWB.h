#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetWB  : NSObject <Command>

@property (nonatomic) NSInteger kelvin;

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
