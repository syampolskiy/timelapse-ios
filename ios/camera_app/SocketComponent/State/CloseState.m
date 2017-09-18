#import "CloseState.h"
#import "SocketConnection.h"
#import "../TCPClient.h"

@interface CloseState ()

@property (strong, nonatomic) SocketConnection *socketConnection;

@end


@implementation CloseState

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
    return @"try to re-connect socket which has been connected before!\n";
}

- (int)send:(NSString *)message
{
    NSLog( @"try to send socket which has been sent to server before!\n");
    return -1;
}

- (int)sendPacket:(cmp_pack *)packet
{
    NSLog( @"try to send socket which has been sent to server before!\n");
    return -1;
}


- (cmp_pack)pull
{
    NSLog(  @"try to pull socket which has read from server before!\n");
    cmp_pack data; data.Header.len = 0; data.Header.Type = 0;
    return data;
}

- (NSString *)close
{
    [self.socketConnection.tcpClient close];
    self.socketConnection.state = self.socketConnection.connectState;
    return @"Socket has been closed!\n";
}

@end
