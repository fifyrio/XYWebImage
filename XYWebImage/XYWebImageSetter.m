//
//  XYWebImageSetter.m
//  tableView
//
//  Created by wuw on 2018/2/23.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "XYWebImageSetter.h"

@interface XYWebImageSetter (){
    dispatch_semaphore_t _lock;
    NSURL *_imageURL;
    NSOperation *_operation;
    int32_t _sentinel;
}

@end

@implementation XYWebImageSetter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

@end
