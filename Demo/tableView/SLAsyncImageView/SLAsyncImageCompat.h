//
//  SLAsyncImageCompat.h
//  tableView
//
//  Created by 吴伟 on 2018/1/28.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLAsyncImageCompat : NSObject

#define dispatch_main_async_safely(block)\
if ([NSThread isMainThread]){\
    block();\
}else{\
    dispatch_async(dispatch_get_main_queue(), block);\
}\

@end
