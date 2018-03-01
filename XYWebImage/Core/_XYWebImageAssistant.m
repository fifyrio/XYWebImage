//
//  _XYWebImageAssistant.m
//  tableView
//
//  Created by wuw on 2018/2/28.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "_XYWebImageAssistant.h"
#import "XYWebImageOperation.h"
#import <libkern/OSAtomic.h>

@interface _XYWebImageAssistant (){
    dispatch_semaphore_t _lock;
    NSURL *_imageURL;
    XYWebImageOperation *_operation;
    int32_t _sentinel;
}

@end

@implementation _XYWebImageAssistant

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)dealloc {
    OSAtomicIncrement32(&_sentinel);
    [_operation cancel];
}

+ (dispatch_queue_t)assistantQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_DEFAULT, 0);
            queue = dispatch_queue_create("com.will.webimage.assistant", attr);
        }else{
            queue = dispatch_queue_create("com.will.webimage.assistant", DISPATCH_QUEUE_SERIAL);
            dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        }
    });
    return queue;
}

- (int32_t)setOperationWithSentinel:(int32_t)sentinel
                                url:(NSURL *)imageURL
                            options:(XYWebImageOptions)options
                            manager:(XYWebImageManager *)manager
                           progress:(XYWebImageProgressBlock)progress
                         completion:(XYWebImageCompletionBlock)completion {
    NSLog(@"setOperationWithSentinel");
    
    if (sentinel != _sentinel) {
        if (completion) completion(nil, imageURL, nil);
        return _sentinel;
    }
    
    XYWebImageOperation *operation = [manager requestImageWithURL:imageURL options:options progress:progress completion:completion];
    if (!operation && completion) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : @"XYWebImageOperation create failed." };
#warning completion待定
        completion(nil, imageURL, [NSError errorWithDomain:@"com.will.webimage" code:-1 userInfo:userInfo]);
    }
    
    return 0;
}



@end
