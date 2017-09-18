#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetExposure  : NSObject <Command>

@property (nonatomic) NSInteger exposure;

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
