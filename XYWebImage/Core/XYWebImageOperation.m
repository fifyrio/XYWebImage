//
//  XYWebImageOperation.m
//  tableView
//
//  Created by wuw on 2018/2/23.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "XYWebImageOperation.h"
#import <libkern/OSAtomic.h>

#warning 待定
#import <ImageIO/ImageIO.h>
#import <CoreFoundation/CoreFoundation.h>
#import "UIImage+YYWebImage.h"

@interface _XYWebImageWeakProxy: NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)proxyWithTarget:(id)target;

@end

@implementation _XYWebImageWeakProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}
+ (instancetype)proxyWithTarget:(id)target {
    return [[[self class] alloc] initWithTarget:target];
}
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}
- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}
- (NSUInteger)hash {
    return [_target hash];
}
- (Class)superclass {
    return [_target superclass];
}
- (Class)class {
    return [_target class];
}
- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}
- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}
- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}
- (BOOL)isProxy {
    return YES;
}
- (NSString *)description {
    return [_target description];
}
- (NSString *)debugDescription {
    return [_target debugDescription];
}

@end

@interface XYWebImageOperation ()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
#warning 待定
{
    CGImageSourceRef _incrementalImgSource;
}

@property (readwrite, getter=isExecuting) BOOL executing;
@property (readwrite, getter=isFinished) BOOL finished;
@property (readwrite, getter=isCancelled) BOOL cancelled;
@property (readwrite, getter=isStarted) BOOL started;

@property (nonatomic, strong) NSRecursiveLock *lock;//递归锁
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionTask *dataTask;

@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) XYWebImageProgressBlock progressBlock;



@end

@implementation XYWebImageOperation

@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;

#pragma mark - Init
- (instancetype)init{
    @throw [NSException exceptionWithName:@"XYWebImageOperation init error" reason:@"XYWebImageOperation must be initialized with a request. Use the method initWithRequest to init." userInfo:nil];
    return [self initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
}

- (instancetype)initWithRequest:(NSURLRequest *)request{
    self = [super init];
    if (self) {
        _request = request;
        _lock = [NSRecursiveLock new];
        _executing = NO;
        _finished = NO;
        _cancelled = NO;
    }
    return self;
}

#pragma mark - thread

/**
 network guard thread
 大量的线程的销毁比较吃内存，所以用NSRunLoop+单例来使线程一直存在
 @return NSThread
 */
+ (NSThread *)_networkThread{
     static NSThread *thread = nil;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
     thread = [[NSThread alloc] initWithTarget:self selector:@selector(_addRunLoop:) object:nil];
     [thread start];
     });
     return thread;
}

+ (void)_addRunLoop:(NSThread *)thread{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"com.will.webimage.request"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (dispatch_queue_t)_imageProcessQueue{
#define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT?MAX_QUEUE_COUNT:queueCount;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            for (NSUInteger i = 0; i < queueCount; i ++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0);
                queues[i] = dispatch_queue_create("com.will.image.process", attr);
            }
        }else{
            for (NSUInteger i = 0; i < queueCount; i ++) {
                queues[i] = dispatch_queue_create("com.will.image.process", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
            }
        }
    });
    int32_t cur = OSAtomicIncrement32(&counter);
    if (cur < 0) {
        cur = -cur;
    }
    return queues[(cur) % queueCount];
#undef MAX_QUEUE_COUNT
}

#pragma mark - Operation life cycle
- (void)_runOperation{
    NSLog(@"_runOperation");
    if ([self isCancelled]) {
        return;
    }
    @autoreleasepool{
        [self performSelector:@selector(_startRequest) onThread:[[self class] _networkThread] withObject:nil waitUntilDone:NO];
    }
}

- (void)_cancelOperation{
    NSLog(@"_cancelOperation");
}

- (void)_startRequest{
    [_lock lock];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 15;
    _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:[_XYWebImageWeakProxy proxyWithTarget:self] delegateQueue:nil];
    
    _dataTask = [_session dataTaskWithRequest:_request];
    [_dataTask resume];
    
    [_lock unlock];
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    
    BOOL isValid = YES;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (id) response;
        NSInteger statusCode = httpResponse.statusCode;
        if (statusCode >= 400 || statusCode == 304) {
            isValid = NO;
        }
    }
    
    if (isValid) {
        
#warning 待定
        _incrementalImgSource = CGImageSourceCreateIncremental(NULL);
        
        NSInteger expected = (NSInteger)response.expectedContentLength;
        expected = expected > 0 ? expected : 0;
        _expectedSize = expected;
        if (_expectedSize < 0) _expectedSize = -1;
        _data = [NSMutableData dataWithCapacity:_expectedSize > 0? _expectedSize : 0];
        
        if (_progressBlock) {
            [_lock lock];
            if (![self isCancelled]) _progressBlock(0, _expectedSize);
            [_lock unlock];
        }
    }else{
        disposition = NSURLSessionResponseCancel;
    }
    
    if (completionHandler) {
        completionHandler(disposition);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"didReceiveData");
    /**/
    [_data appendData:data];
    CGImageSourceUpdateData(_incrementalImgSource, (CFDataRef)_data, NO);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementalImgSource, 0, NULL);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
     
    
    /*
    CGFloat radius = 32;
    radius *= 1.0 / (3 * _data.length / (CGFloat)_expectedSize + 0.6) - 0.25;
    image = [image yy_imageByBlurRadius:radius tintColor:nil tintMode:0 saturation:1 maskImage:nil];
    NSLog(@"r: %0.1f",radius);
     */
    
    /**/
    if (self.completionBlock) {
        self.completionBlock(image, nil);
    }
    CGImageRelease(imageRef);
}

#pragma mark NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler{
    NSLog(@"willCacheResponse");
    completionHandler(nil);
#warning 待定
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"didCompleteWithError");
    @autoreleasepool{
        [_lock lock];
        __weak typeof(self) _self = self;
        dispatch_async([[self class] _imageProcessQueue], ^{
            __strong typeof(_self) self = _self;
            CGImageSourceUpdateData(_incrementalImgSource, (CFDataRef)_data, YES);
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementalImgSource, 0, NULL);
            if (self.completionBlock) {
                self.completionBlock([UIImage imageWithCGImage:imageRef], nil);
            }
            CGImageRelease(imageRef);
        });        
        [_lock unlock];
    }
    
    
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (_options & XYWebImageOptionAllowInvalidSSLCertificates) {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            disposition = NSURLSessionAuthChallengeUseCredential;
        }else{
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }else{
        if (challenge.previousFailureCount == 0) {
            if (self.credential) {
                credential = self.credential;
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark - Override NSOperation
- (void)start{
    @try{
        @autoreleasepool{
            [_lock lock];
            self.started = YES;
            
            if ([self isCancelled]) {
                [self performSelector:@selector(_cancelOperation) onThread:[[self class] _networkThread] withObject:nil waitUntilDone:NO];
                self.finished = YES;
            }else if ([self isReady] && ![self isFinished] && ![self isExecuting]){
                if (!_request) {
                    self.finished = YES;
                }else{
                    self.executing = YES;
                    [self performSelector:@selector(_runOperation) onThread:[[self class] _networkThread] withObject:nil waitUntilDone:NO];
                }
            }                        
            
            [_lock unlock];
        }
         
    }
    @catch(NSException *exception){
    }
}

- (void)cancel{
    
}

- (BOOL)isConcurrent{
    return YES;
}

- (BOOL)isAsynchronous{
    return YES;
}

- (BOOL)isExecuting{
    [_lock lock];
    BOOL isExecuting = _executing;
    [_lock unlock];
    return isExecuting;
}

- (void)setExecuting:(BOOL)executing{
    [_lock lock];
    if (_executing != executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
    [_lock unlock];
}

- (BOOL)isFinished{
    [_lock lock];
    BOOL isFinished = _finished;
    [_lock unlock];
    return isFinished;
}

- (void)setFinished:(BOOL)finished{
    [_lock lock];
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
    [_lock unlock];
}

- (BOOL)isCancelled{
    [_lock lock];
    BOOL isCancelled = _cancelled;
    [_lock unlock];
    return isCancelled;
}

- (void)setCancelled:(BOOL)cancelled{
    [_lock lock];
    if (_cancelled != cancelled) {
        [self willChangeValueForKey:@"isCancelled"];
        _cancelled = cancelled;
        [self didChangeValueForKey:@"isCancelled"];
    }
    [_lock unlock];
}

@end
