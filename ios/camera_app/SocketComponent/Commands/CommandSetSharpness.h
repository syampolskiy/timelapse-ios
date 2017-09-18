#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetSharpness  : NSObject <Command>

@property (nonatomic) NSInteger sharpness; // percent: 0..100

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
