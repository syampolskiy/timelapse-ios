#import "CommandGetFootageList.h"


@interface CommandGetFootageList ()

@property (strong, nonatomic) SocketConnection *socketConnection;
@property (strong, nonatomic) ApplicationData * app_state;

@end


@implementation CommandGetFootageList

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

        unsigned char data[4];
        data[0] = sFootageList;
        data[1] = _isVideoOrShot;//0:Shot,1:Video
        data[2] = _firstIndex;
        data[3] = _lastIndex;
        
        cmp_pack packet;
        packet.Header.Type = 'G';
        packet.Header.len = 4;
        memcpy(packet.data, data, packet.Header.len);


    
        int locIsServerConnected = 0;
        if ([self.socketConnection sendPacket:&packet] == 0)
        {
            cmp_pack packet = [self.socketConnection pull];
            if (packet.Header.Type == 'R' && packet.data[0] == sFootageList)
            {
                locIsServerConnected = 1;
                //
                NSString * msg = [NSString stringWithUTF8String:(const char *)&(packet.data[1])];
                self.app_state.bFootageList = [msg copy];
            }
        }
        self.app_state.bIsServerConnected = locIsServerConnected;
        
        NSLog(@"%@", [self.socketConnection close]);
    }
}

@end
