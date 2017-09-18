//
//  TCPClient.m

#import "TCPClient.h"



@implementation TCPClient

- (Result * _Nonnull) connectUntilTimeout: (NSInteger) timeout_s {

    const char *a = [self.address cStringUsingEncoding:NSUTF8StringEncoding];
    int p = (int)self.port;
    int t = (int)timeout_s;
    
    int rc = ytcpsocket_connect(a, p, t);
    Result *result = nil;
    
    if (rc > 0) {
        self.fd = [NSNumber numberWithInt:rc];
        result = [Result success];
    
    } else {
        
        SocketErrorCode code;
        switch (rc) {
            case -1: code = Socket_QueryFailed;
                break;
            case -2: code = Socket_ConnectionClosed;
                break;
            case -3: code = Socket_ConnectionTimeout;
                break;
            default: code = Socket_UnknownError;
                break;
        }
        result = [Result resultWithError:code];
    }
    
    return result;
}

- (void) close {

    if (!self.fd) {
        return;
    }
    int fd = self.fd.intValue;
    self.fd = nil;
    
    ytcpsocket_close(fd);
}

- (Result *_Nonnull) sendData: (NSData *_Nonnull) data {
    
    if (!self.fd) {
        return [Result resultWithError:Socket_ConnectionClosed];
    }
    int fd = self.fd.intValue;
    
    NSUInteger len = [data length];
    Byte *byteData= (Byte*)malloc(len);
    [data getBytes:byteData length:len];
    
    int sendsize = ytcpsocket_send(fd, (char *)byteData, (int)len);
    free(byteData);
    
    return sendsize == len ? [Result success] : [Result resultWithError:Socket_UnknownError];
}

- (Result *_Nonnull) sendString: (NSString *_Nonnull) string {
    
    if (!self.fd) {
        return [Result resultWithError:Socket_ConnectionClosed];
    }
    int fd = self.fd.intValue;
    
    NSUInteger len = [string length];
    char *byteData= strdup([string cStringUsingEncoding:NSUTF8StringEncoding]);
    
    int sendsize = ytcpsocket_send(fd, (char *)byteData, (int)len);
    
    return sendsize == len ? [Result success] : [Result resultWithError:Socket_UnknownError];
}

- (Result *_Nonnull) sendStringFormated: (NSString *_Nonnull) string {
    NSString *length = [NSString stringWithFormat:@"%d",[string length]];
    NSString *strFormatted = [NSString stringWithFormat:@"%@ %@", length, string];

    return [self sendString : strFormatted];
}

- (Result *_Nonnull) sendPacket: (cmp_pack *_Nonnull) packet {

    if (!self.fd) {
        return [Result resultWithError:Socket_ConnectionClosed];
    }
    int fd = self.fd.intValue;
    
    int len = sizeof(cmp_header) + packet->Header.len;
    int sendsize = ytcpsocket_send2(fd, packet);
    
    return sendsize == len ? [Result success] : [Result resultWithError:Socket_UnknownError];
}

- (NSData * _Nullable) read: (NSUInteger) expectLen
               untilTimeout: (NSInteger) timeout_s {

    if (!self.fd) {
        return nil;
    }
    int fd = self.fd.intValue;
    
    Byte *byteData= (Byte*)malloc((size_t)expectLen);
    
    int readLen = ytcpsocket_pull(fd, (char *)byteData, (int)expectLen, (int)timeout_s);
    
    NSData *data = nil;
    if (readLen > 0) {
        data = [[NSData alloc] initWithBytes:byteData length: expectLen];
    }
    free(byteData);
    
    return data;
}

@end
