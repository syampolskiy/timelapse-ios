//
//  TCPClient.h

#import <Foundation/Foundation.h>

#import "Socket.h"
#import "Result.h"

#import "../../../../camera_ctrl/Packet.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

void ytcpsocket_set_block(int socket, int on);
int ytcpsocket_connect(const char *host, int port, int timeout);
int ytcpsocket_close(int socketfd);
int ytcpsocket_pull(int socketfd, char *data, int len, int timeout_sec);
int ytcpsocket_send(int socketfd, const char *data, int len);
int ytcpsocket_send2(int socketfd, const cmp_pack * packet);
int ytcpsocket_listen(const char *address, int port);
int ytcpsocket_accept(int onsocketfd, char *remoteip, int *remoteport, int timeouts);
int ytcpsocket_port(int socketfd);

#pragma clang diagnostic pop


@interface TCPClient : Socket

- (Result * _Nonnull) connectUntilTimeout: (NSInteger) timeout_s;
- (void) close;

- (Result *_Nonnull) sendData: (NSData *_Nonnull) data;
- (Result *_Nonnull) sendString: (NSString *_Nonnull) string;
- (Result *_Nonnull) sendStringFormated: (NSString *_Nonnull) string;
- (Result *_Nonnull) sendPacket: (cmp_pack *_Nonnull) data;

- (NSData * _Nullable) read: (NSUInteger) expectLen
               untilTimeout: (NSInteger) timeout_s;

@end
