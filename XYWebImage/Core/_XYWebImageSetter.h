//
//  _XYWebImageSetter.h
//  tableView
//
//  Created by wuw on 2018/2/27.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@interface _XYWebImageSetter : NSObject

@end
