#import "Command.h"
#import "SocketConnection.h"

@interface CommandGetCamStatus  : NSObject <Command>

@property (nonatomic) CMPCameraStatus camStatus;

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

@end
