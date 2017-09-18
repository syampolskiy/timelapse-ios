#import <Foundation/Foundation.h>
#import "../TCPClient.h"

@protocol State <NSObject>

- (NSString *)connect;
- (int)send:(NSString *)message;
- (int)sendPacket:(cmp_pack *)packet;
- (cmp_pack)pull;
- (NSString *)close;

@end
