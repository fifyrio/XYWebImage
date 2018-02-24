//
//  XYWebImageOperation.m
//  tableView
//
//  Created by wuw on 2018/2/23.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "XYWebImageOperation.h"

@interface XYWebImageOperation ()

@property (readwrite, getter=isExecuting) BOOL executing;
@property (readwrite, getter=isFinished) BOOL finished;
@property (readwrite, getter=isCancelled) BOOL cancelled;
@property (readwrite, getter=isStarted) BOOL started;

@property (nonatomic, strong) NSRecursiveLock *lock;//递归锁

@end

@implementation XYWebImageOperation

@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;

#pragma mark - Init
- (instancetype)init{
    @throw [NSException exceptionWithName:@"XYWebImageOperation init error" reason:@"YYWebImageOperation must be initialized with a request. Use the method initWithRequest to init." userInfo:nil];
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

#pragma mark - network guard thread

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

#pragma mark - Operation life cycle
- (void)_runOperation{
    NSLog(@"_runOperation");
}

- (void)_cancelOperation{
    NSLog(@"_cancelOperation");
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
