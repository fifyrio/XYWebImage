//
//  XYWebImageDownloader.m
//  tableView
//
//  Created by wuw on 2018/1/30.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "XYWebImageDownloader.h"
#import "XYWebImageDownloaderOperation.h"

@implementation XYWebImageDownloaderToken

@end

@interface XYWebImageDownloader ()<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, retain) NSMutableDictionary <NSURL *, XYWebImageDownloaderOperation *> *URLOperations;

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic, strong) dispatch_queue_t barrierQueue;

@property (nonatomic, strong) NSURLSession *session;

@end

static float const kDownloadTimeout = 15;

@implementation XYWebImageDownloader

#pragma mark - Life cycle
- (instancetype)init
{
    return [self initWithWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
}

- (instancetype)initWithWithSessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration
{
    self = [super init];
    if (self) {
        _downloadQueue = [NSOperationQueue new];
        _URLOperations = @{}.mutableCopy;
        _barrierQueue = dispatch_queue_create("com.will.XYWebImageDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        [self createSessionWithConfiguration:sessionConfiguration];
    }
    return self;
}

- (void)createSessionWithConfiguration:(NSURLSessionConfiguration *)sessionConfiguration{
    //clear previous opeeration queue and session
    [self.downloadQueue cancelAllOperations];
    [self.session invalidateAndCancel];
    
    sessionConfiguration.timeoutIntervalForRequest = kDownloadTimeout;
    
    _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
}

- (void)dealloc {
    [self.session invalidateAndCancel];
    self.session = nil;
    
    [self.downloadQueue cancelAllOperations];
}

- (XYWebImageDownloaderToken *)addToURLOperationsWithURL:(NSURL *)URL createCallback:(XYWebImageDownloaderOperation * (^)(void))createCallback{
    __block XYWebImageDownloaderToken *token = nil;
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        XYWebImageDownloaderOperation *operation = self.URLOperations[URL];
        if (!operation) {
            operation = createCallback();
            self.URLOperations[URL] = operation;
        }
        
        token = [XYWebImageDownloaderToken new];
        token.url = URL;
    });
    
    return token;
}
@end
