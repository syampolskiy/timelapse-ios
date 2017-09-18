#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetBPP  : NSObject <Command>

@property (nonatomic) NSInteger pixFmtIndex; //0:8bit,1:12bit,2:16bit

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
