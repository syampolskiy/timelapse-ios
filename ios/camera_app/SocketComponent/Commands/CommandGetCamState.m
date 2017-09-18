#import "CommandGetCamState.h"


@interface CommandGetCamState ()

@property (strong, nonatomic) SocketConnection *socketConnection;
@property (strong, nonatomic) ApplicationData * app_state;

@end


@implementation CommandGetCamState

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
        data[0] = sCamState;
        cmp_pack packet;
        packet.Header.Type = 'G';
        packet.Header.len = 1;
        memcpy(packet.data, data, packet.Header.len);

    
    
        int locIsServerConnected = 0;
        if ([self.socketConnection sendPacket:&packet] == 0)
        {
            cmp_pack packet = [self.socketConnection pull];
            if (packet.Header.Type == 'R' && packet.data[0] == sCamState)
            {
                locIsServerConnected = 1;
                //
                SCameraState * serverCamState = (SCameraState *)(&(packet.data[1]));
                
                self.app_state.bStartStopWriting = serverCamState->bStartStopWriting == 0 ? 0 : 1;
                self.app_state.bWhiteBallance = serverCamState->iWhiteBallance;
                self.app_state.bBrightness = serverCamState->iBrightness;
                self.app_state.bPixFmtIndex = serverCamState->bPixFmt;
                self.app_state.bCamResolutionIndex = serverCamState->bResolution;
                self.app_state.bContrast = serverCamState->iConstrast;
                self.app_state.bSaturation = 100 * ((float)(serverCamState->bSaturation) / 255.0f);
                self.app_state.bSharpness = 100 * ((float)(serverCamState->bSharpness) / 255.0f);
                [self.app_state fill: & serverCamState->relPars];
            }
        }
        self.app_state.bIsServerConnected = locIsServerConnected;
        
        NSLog(@"%@", [self.socketConnection close]);
    }
}

@end
