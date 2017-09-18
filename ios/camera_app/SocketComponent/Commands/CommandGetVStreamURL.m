#import "CommandGetVStreamURL.h"


@interface CommandGetVStreamURL ()

@property (strong, nonatomic) SocketConnection *socketConnection;
@property (strong, nonatomic) ApplicationData * app_state;

@end


@implementation CommandGetVStreamURL

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
        data[0] = sVStreamURL;
        cmp_pack packet;
        packet.Header.Type = 'G';
        packet.Header.len = 1;
        memcpy(packet.data, data, packet.Header.len);


    
        int locIsServerConnected = 0;
        self.app_state.sVStreamURL = @"";
        if ([self.socketConnection sendPacket:&packet] == 0)
        {
            cmp_pack packet = [self.socketConnection pull];
            if (packet.Header.Type == 'R' && packet.data[0] == sVStreamURL)
            {
                locIsServerConnected = 1;
                //
                NSString * url = [NSString stringWithUTF8String:(const char *)&(packet.data[1])];
                self.app_state.sVStreamURL = [url copy];
            }
        }
        self.app_state.bIsServerConnected = locIsServerConnected;
        
        NSLog(@"%@", [self.socketConnection close]);
    }
}

@end
