#import "SendState.h"
#import "SocketConnection.h"
#import "../TCPClient.h"

@interface SendState ()

@property (strong, nonatomic) SocketConnection *socketConnection;

@end


@implementation SendState

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
    cmp_pack packet;
    packet.Header.Type = 'M';
    packet.Header.len = message.length;
    memcpy(packet.data, [message UTF8String], packet.Header.len);

    
    if ([self.socketConnection.tcpClient sendPacket:&packet].isSuccess == true) {
        self.socketConnection.state = self.socketConnection.pullState;
        NSLog( @"Data has been sent to server!\n");
        return 0;
    }
    NSLog( @"Data CANNOT be sended to server!\n");
    return -1;
}

- (int)sendPacket:(cmp_pack *)packet
{
    if ([self.socketConnection.tcpClient sendPacket:packet].isSuccess == true) {
        self.socketConnection.state = self.socketConnection.pullState;
        NSLog( @"Data has been sent to server!\n");
        return 0;
    }
    NSLog( @"Data CANNOT be sended to server!\n");
    return -1;
}


- (cmp_pack)pull
{
    NSLog (@ "try to pull socket which does not send to server anything!\n");
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
