//
//  Socket.m


#import "Socket.h"

@implementation Socket

@synthesize address = _address;
@synthesize port = _port;

- (instancetype _Nullable) initWithAddress: (NSString * _Nonnull) a
                                      port: (NSUInteger) p {
    
    BOOL isValid = [[self class] validateAddress:a] && [[self class] validatePort:p];
    if (!isValid) {
        return nil;
    }
    
    if (self = [super init]) {
        _address = a;
        _port = p;
    }
    return self;
}

+ (BOOL) validateAddress: (NSString *) address {
    // TODO
    return YES;
}

+ (BOOL) validatePort: (NSUInteger) address {
    //TODO
    return YES;
}

@end
