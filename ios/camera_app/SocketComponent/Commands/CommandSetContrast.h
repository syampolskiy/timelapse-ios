#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetContrast  : NSObject <Command>

@property (nonatomic) NSInteger contrast; // percent: 0..100

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
