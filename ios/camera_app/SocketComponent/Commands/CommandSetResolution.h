#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetResolution  : NSObject <Command>

@property (nonatomic) NSInteger camResolution; //0:2048x2048 1:1024x1024

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
