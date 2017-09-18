#import "PullState.h"
#import "SocketConnection.h"


@interface PullState ()

@property (strong, nonatomic) SocketConnection *socketConnection;

@end


@implementation PullState

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
    NSData *response = [self.socketConnection.tcpClient read: 1024*10 untilTimeout: 10];
    response = response ? response : [NSData data];
         
    //NSString * result = [[NSString alloc] initWithData: response encoding:NSUTF8StringEncoding];
    
    cmp_pack packet;
    [response getBytes:&packet length:sizeof(packet)];

    self.socketConnection.state = self.socketConnection.closeState;
    NSLog ( @"Socket has read pulled data from server!\n" );
    return packet;
}

- (NSString *)close
{
    [self.socketConnection.tcpClient close];
    self.socketConnection.state = self.socketConnection.connectState;
    return @"Socket has been closed!\n";
}

@end
