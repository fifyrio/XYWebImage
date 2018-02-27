//
//  UIImageView+XYWebImage.m
//  tableView
//
//  Created by wuw on 2018/2/27.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "UIImageView+XYWebImage.h"

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
}

@end
