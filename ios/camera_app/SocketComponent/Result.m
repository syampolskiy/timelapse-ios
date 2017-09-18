//
//  Result.m


#import "Result.h"

@implementation Result
@synthesize errorCode = _errorCode;

+ (instancetype _Nonnull) success {
    return [[Result alloc] initWithErrorCode: Socket_NoError];
}

+ (instancetype _Nonnull) resultWithError: (SocketErrorCode) errorCode {
     return [[Result alloc] initWithErrorCode: errorCode];
}

- (instancetype) initWithErrorCode: (SocketErrorCode) errorCode {
    
    if (self = [super init]) {
        _errorCode = errorCode;
    }
    return self;
}

- (BOOL) isSuccess {
    return self.errorCode == Socket_NoError;
}

- (BOOL) isFailure {
    return !self.isSuccess;
}

@end
