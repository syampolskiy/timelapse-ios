#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetISO  : NSObject <Command>

@property (nonatomic) NSInteger iso;

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
