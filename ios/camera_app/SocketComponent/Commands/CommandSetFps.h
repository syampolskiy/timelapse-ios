#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetFps  : NSObject <Command>

@property (nonatomic) NSInteger fps;

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
