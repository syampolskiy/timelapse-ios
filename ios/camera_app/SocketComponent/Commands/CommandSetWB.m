#import "CommandSetWB.h"


@interface CommandSetWB ()

@property (strong, nonatomic) SocketConnection *socketConnection;
@property (strong, nonatomic) ApplicationData * app_state;

@end


@implementation CommandSetWB


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

        unsigned char data[3];
        data[0] = iWhiteBallance;
        memcpy(&data[1], & _kelvin, sizeof(short));
        cmp_pack packet;
        packet.Header.Type = 'S';
        packet.Header.len = 3;
        memcpy(packet.data, data, packet.Header.len);

    
        int locIsServerConnected = 0;
        if ([self.socketConnection sendPacket:&packet] == 0)
        {
            locIsServerConnected = 1;
            //
            self.app_state.bWhiteBallance = _kelvin;
        }
        self.app_state.bIsServerConnected = locIsServerConnected;
        
        NSLog(@"%@", [self.socketConnection close]);
    }
}

@end
