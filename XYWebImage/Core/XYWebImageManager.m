//
//  XYWebImageManager.m
//  tableView
//
//  Created by wuw on 2018/2/26.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "XYWebImageManager.h"
#import "XYWebImageOperation.h"


@implementation XYWebImageManager

#pragma mark - Life cycle
+ (instancetype)sharedManager {
    static XYWebImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        NSOperationQueue *queue = [NSOperationQueue new];
        if ([queue respondsToSelector:@selector(setQualityOfService:)]) {
            queue.qualityOfService = NSQualityOfServiceBackground;
        }
        manager = [[self alloc] initWithCache:nil queue:queue];
    });
    return manager;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"XYWebImageManager init error" reason:@"Use the designated initializer to init." userInfo:nil];
    return [self initWithCache:nil queue:nil];
}

- (instancetype)initWithCache:(XYImageCache *)cache queue:(NSOperationQueue *)queue{
    self = [super init];
    if (!self) return nil;
    _cache = cache;
    _queue = queue;
    _timeout = 15.0;
    return self;
}

- (XYWebImageOperation *)requestImageWithURL:(NSURL *)url
                                     options:(XYWebImageOptions)options
                                    progress:(XYWebImageProgressBlock)progress
                                  completion:(XYWebImageCompletionBlock)completion {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = _timeout;
    request.HTTPShouldHandleCookies = (options & XYWebImageOptionHandleCookies) != 0;
//    request.allHTTPHeaderFields = [self headersForURL:url];
    request.HTTPShouldUsePipelining = YES;
    request.cachePolicy = (options & XYWebImageOptionUseNSURLCache) ?
    NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData;
    
    XYWebImageOperation *operation = [[XYWebImageOperation alloc] initWithRequest:request options:options cache:_cache cacheKey:@"" progress:progress completion:completion];
    if (operation) {
        if (_queue) {
            [_queue addOperation:operation];
        }else{
            [operation start];
        }
    }
    return operation;
}

@end
