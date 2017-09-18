#import "CommandGetWritingTime.h"


@interface CommandGetWritingTime ()

@property (strong, nonatomic) SocketConnection *socketConnection;
@property (strong, nonatomic) ApplicationData * app_state;

@end


@implementation CommandGetWritingTime

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

        unsigned char data[1];
        data[0] = iWritingMiliseconds;
        cmp_pack packet;
        packet.Header.Type = 'G';
        packet.Header.len = 1;
        memcpy(packet.data, data, packet.Header.len);

    
        int locIsServerConnected = 0;
        if ([self.socketConnection sendPacket:&packet] == 0)
        {
            cmp_pack packet = [self.socketConnection pull];
            if (packet.Header.Type == 'R' && packet.data[0] == iWritingMiliseconds)
            {
                locIsServerConnected = 1;
                //
                long long  ms= *(long long *)(&(packet.data[1]));
                
                self.app_state.pWritingProgressMS = ms;
            }
        }
        self.app_state.bIsServerConnected = locIsServerConnected;
        
        NSLog(@"%@", [self.socketConnection close]);
    }
}

@end
