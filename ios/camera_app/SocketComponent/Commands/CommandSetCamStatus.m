#import "CommandSetCamStatus.h"


@interface CommandSetCamStatus ()

@property (strong, nonatomic) SocketConnection *socketConnection;
@property (strong, nonatomic) ApplicationData * app_state;

@end


@implementation CommandSetCamStatus

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

- (void) setCamIndex:(int)index
{
    _camStatus.iCAMindex = index;
}

- (void) setCamMode:(int)modeIndex
{
    _camStatus.iMode = modeIndex;
}

#pragma mark - <Command>

- (void)execute
{
    @synchronized (self.app_state) {
        NSLog(@"%@", [self.socketConnection connect]);
        
        unsigned char data[1 + sizeof(CMPCameraStatus)];
        data[0] = iCameraStatus;
        memcpy (&(data[1]), &_camStatus, sizeof(CMPCameraStatus));
        cmp_pack packet;
        packet.Header.Type = 'S';
        packet.Header.len = 1 + sizeof(CMPCameraStatus);
        memcpy(packet.data, data, packet.Header.len);
        
        
        int locIsServerConnected = 0;
        if ([self.socketConnection sendPacket:&packet] == 0)
        {
            locIsServerConnected = 1;
            
            self.app_state.bCAMindex = _camStatus.iCAMindex;
            self.app_state.bStreamVideoMode = _camStatus.iMode;
        }
        self.app_state.bIsServerConnected = locIsServerConnected;
        
        NSLog(@"%@", [self.socketConnection close]);
    }
}

@end
