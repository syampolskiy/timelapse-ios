#import "Command.h"
#import "SocketConnection.h"

@interface CommandSetCamStatus  : NSObject <Command>

@property (nonatomic) CMPCameraStatus camStatus;

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data;

- (void) setCamIndex:(int)index;
- (void) setCamMode:(int)modeIndex;


@end
