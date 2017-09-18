#import "CommandSetExposure.h"


@interface CommandSetExposure ()

@property (strong, nonatomic) SocketConnection *socketConnection;
@property (strong, nonatomic) ApplicationData * app_state;

@end


@implementation CommandSetExposure


#pragma mark - Init Methods

- (id)initWithSocketConnection:(SocketConnection *)socketConnection state:(ApplicationData*)app_data
{
    self = [super init];
    if (self) {
        self.socketConnection = socketConnection;
        self.app_state = app_data;
    }
    return self;
}

#pragma mark - <Command>

- (void)execute
{
    @synchronized (self.app_state) {
        NSLog(@"%@", [self.socketConnection connect]);

        unsigned char data[2];
        data[0] = iExposure;
        data[1] = _exposure;
        cmp_pack packet;
        packet.Header.Type = 'S';
        packet.Header.len = 2;
        memcpy(packet.data, data, packet.Header.len);

        int locIsServerConnected = 0;
        if ([self.socketConnection sendPacket:&packet] == 0)
        {
            cmp_pack packet = [self.socketConnection pull];
            if (packet.Header.Type == 'R' && packet.data[0] == iExposure)
            {
                locIsServerConnected = 1;
                //
                SCameraState0 * serverCamState0 = (SCameraState0 *)(&(packet.data[1]));
                
                [self.app_state fill: serverCamState0];
            }
        }
        self.app_state.bIsServerConnected = locIsServerConnected;
        
        NSLog(@"%@", [self.socketConnection close]);
    }
}

@end
