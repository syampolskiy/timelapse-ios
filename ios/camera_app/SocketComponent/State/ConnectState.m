#import "ConnectState.h"
#import "SocketConnection.h"
#import "../TCPClient.h"

@interface ConnectState ()

@property (strong, nonatomic) SocketConnection *socketConnection;

@end


@implementation ConnectState

#pragma mark - Init Methods

- (id)initWithSocketConnection:(SocketConnection *)socketConnection
{
    self = [super init];
    if (self) {
        self.socketConnection = socketConnection;
    }
    return self;
}

#pragma mark - <State>

- (NSString *)connect
{
    if ([self.socketConnection.tcpClient connectUntilTimeout:1].isSuccess == true) {
        
        self.socketConnection.state = self.socketConnection.sendState;
        return @"Socket has been connected!\n";
    }
    return @"Socket connection error";
}

- (int)send:(NSString *)message
{
    NSLog( @"try to send socket which does not connected!\n");
    return -1;
}

- (int)sendPacket:(cmp_pack *)packet
{
    NSLog( @"try to send socket which does not connected!\n");
    return -1;
}


- (cmp_pack)pull
{
    NSLog ( @"try to pull socket which does not connected!\n");
    cmp_pack data; data.Header.len = 0; data.Header.Type = 0;
    return data;
}

- (NSString *)close
{
    return @"try to close socket which does not connected!\n";
}

@end
