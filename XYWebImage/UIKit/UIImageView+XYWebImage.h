//
//  UIImageView+XYWebImage.h
//  tableView
//
//  Created by wuw on 2018/2/27.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYWebImageManager.h"

@interface UIImageView (XYWebImage)

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL;

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder;

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(XYWebImageOptions)options;

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(XYWebImageOptions)options
                completion:(nullable XYWebImageCompletionBlock)completion;

- (void)xy_setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(XYWebImageOptions)options
                  progress:(nullable XYWebImageProgressBlock)progress
                completion:(nullable XYWebImageCompletionBlock)completion;

@end
