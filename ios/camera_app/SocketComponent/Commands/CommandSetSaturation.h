#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetSaturation  : NSObject <Command>

@property (nonatomic) NSInteger saturation; // percent: 0..100

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
