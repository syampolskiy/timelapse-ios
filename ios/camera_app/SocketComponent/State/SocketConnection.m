#import "SocketConnection.h"
#import "ConnectState.h"
#import "SendState.h"
#import "PullState.h"
#import "CloseState.h"
#import "../TCPClient.h"

@interface SocketConnection ()

@property (strong, nonatomic, readwrite) id<State> connectState;
@property (strong, nonatomic, readwrite) id<State> sendState;
@property (strong, nonatomic, readwrite) id<State> pullState;
@property (strong, nonatomic, readwrite) id<State> closeState;

@end


@implementation SocketConnection


#pragma mark - Init Methods

#pragma mark - Public Methods

- (id)initWithAdress:(NSString * _Nonnull) a
              port: (NSUInteger) p
{
    self = [super init];
    if (self) {
        self.connectState = [[ConnectState alloc] initWithSocketConnection:self];
        self.sendState = [[SendState alloc] initWithSocketConnection:self];
        self.pullState = [[PullState alloc] initWithSocketConnection:self];
        self.closeState = [[CloseState alloc] initWithSocketConnection:self];
        
        self.state = self.connectState;

        self.tcpClient = [[TCPClient alloc] initWithAddress:a port:p];
    }
    return self;
}

- (NSString *)connect
{
    return [self.state connect];
}

- (int)send:(NSString *)message
{
    return [self.state send:message];
}

- (int)sendPacket:(cmp_pack *)packet
{
    return [self.state sendPacket:packet];
}


- (cmp_pack)pull
{
    return [self.state pull];
}

- (NSString *)close
{
    return [self.state close];
}

@end
