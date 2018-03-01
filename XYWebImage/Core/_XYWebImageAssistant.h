//
//  _XYWebImageAssistant.h
//  tableView
//
//  Created by wuw on 2018/2/28.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYWebImageManager.h"
#import <pthread.h>

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
static inline void _xy_dispatch_sync_on_main_queue(void (^block)()) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@interface _XYWebImageAssistant : NSObject

+ (dispatch_queue_t)assistantQueue;

- (int32_t)setOperationWithSentinel:(int32_t)sentinel
                                url:(NSURL *)imageURL
                            options:(XYWebImageOptions)options
                            manager:(XYWebImageManager *)manager
                           progress:(XYWebImageProgressBlock)progress
                         completion:(XYWebImageCompletionBlock)completion ;

@end
