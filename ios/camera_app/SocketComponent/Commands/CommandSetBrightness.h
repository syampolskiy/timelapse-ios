#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetBrightness  : NSObject <Command>

@property (nonatomic) NSInteger brightness; // percent: 0..100

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
