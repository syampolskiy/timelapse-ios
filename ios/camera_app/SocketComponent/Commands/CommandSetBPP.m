#import "CommandSetBPP.h"


@interface CommandSetBPP ()

@property (strong, nonatomic) SocketConnection *socketConnection;
@property (strong, nonatomic) ApplicationData * app_state;

@end


@implementation CommandSetBPP


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
        data[0] = bPixFmt;
        data[1] = _pixFmtIndex;
        cmp_pack packet;
        packet.Header.Type = 'S';
        packet.Header.len = 2;
        memcpy(packet.data, data, packet.Header.len);

        int locIsServerConnected = 0;
        if ([self.socketConnection sendPacket:&packet] == 0)
        {
            locIsServerConnected = 1;
            self.app_state.bPixFmtIndex = _pixFmtIndex;
        }
        self.app_state.bIsServerConnected = locIsServerConnected;
        
        NSLog(@"%@", [self.socketConnection close]);
    }
}

@end
