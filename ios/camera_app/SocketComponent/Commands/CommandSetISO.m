#import "CommandSetISO.h"


@interface CommandSetISO ()

@property (strong, nonatomic) SocketConnection *socketConnection;
@property (strong, nonatomic) ApplicationData * app_state;

@end


@implementation CommandSetISO

// [-1200..-400], [400..1200] => [-32001..-1], [1..32001]
- (short)iso2short:(NSInteger)iso {
    float absCoeff = round((fabs(iso)-400.0f)/800.0f * 32000.0) + 1;
    int coeff = absCoeff * (iso < 0 ? -1 : 1);
    return (short)coeff;
}

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

        short code = [self iso2short:_iso];
        unsigned char data[3];
        data[0] = iISO;
        memcpy(&data[1], & code, sizeof(short));
        cmp_pack packet;
        packet.Header.Type = 'S';
        packet.Header.len = 3;
        memcpy(packet.data, data, packet.Header.len);

        int locIsServerConnected = 0;
        if ([self.socketConnection sendPacket:&packet] == 0)
        {
            cmp_pack packet = [self.socketConnection pull];
            if (packet.Header.Type == 'R' && packet.data[0] == iISO)
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
