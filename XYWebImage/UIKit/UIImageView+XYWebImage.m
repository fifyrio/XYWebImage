//
//  UIImageView+XYWebImage.m
//  tableView
//
//  Created by wuw on 2018/2/27.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "UIImageView+XYWebImage.h"
#import <objc/runtime.h>
#import "_XYWebImageAssistant.h"

@implementation UIImageView (XYWebImage)

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL{
    [self xy_setImageWithURL:imageURL
                 placeholder:nil
                     options:kNilOptions
                     manager:nil
                    progress:nil
                  completion:nil];
}

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder{
    [self xy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:kNilOptions
                     manager:nil
                    progress:nil
                  completion:nil];
}

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder  options:(XYWebImageOptions)options{
    [self xy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                  completion:nil];
}

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(XYWebImageOptions)options
                completion:(nullable XYWebImageCompletionBlock)completion{
    [self xy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:nil
                  completion:completion];
}

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(XYWebImageOptions)options
                  progress:(nullable XYWebImageProgressBlock)progress
                completion:(nullable XYWebImageCompletionBlock)completion{
    [self xy_setImageWithURL:imageURL
                 placeholder:placeholder
                     options:options
                     manager:nil
                    progress:progress
                  completion:completion];
}

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(XYWebImageOptions)options
                   manager:(XYWebImageManager *)manager
                  progress:(nullable XYWebImageProgressBlock)progress
                completion:(nullable XYWebImageCompletionBlock)completion{
    NSLog(@"xy_setImageWithURL");
    if ([imageURL isKindOfClass:[NSString class]]) imageURL = [NSURL URLWithString:(id)imageURL];
    manager = manager ? manager : [XYWebImageManager sharedManager];
    
    //取消之前的url请求
    
    _xy_dispatch_sync_on_main_queue(^{
        dispatch_async([_XYWebImageAssistant assistantQueue], ^{
            __block int32_t newSentinel = 0;
            
            [[self xy_assistant] setOperationWithSentinel:newSentinel url:imageURL options:options manager:manager progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.image = image;
                });
            }];
        });
    });
}

#pragma mark - Private
- (_XYWebImageAssistant*)xy_assistant{
    _XYWebImageAssistant *assistant = objc_getAssociatedObject(self, _cmd);
    if (!assistant) {
        assistant = [_XYWebImageAssistant new];
        objc_setAssociatedObject(self, _cmd, assistant, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return assistant;
}

@end
