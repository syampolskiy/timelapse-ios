#import "Command.h"
#import "SocketConnection.h"

@interface CommandGetFootageList  : NSObject <Command>

@property (nonatomic) NSInteger isVideoOrShot;//0:Shot,1:Video
@property (nonatomic) NSInteger firstIndex;
@property (nonatomic) NSInteger lastIndex;

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
