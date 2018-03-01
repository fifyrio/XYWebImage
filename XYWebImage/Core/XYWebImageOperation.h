//
//  XYWebImageOperation.h
//  tableView
//
//  Created by wuw on 2018/2/23.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYWebImageManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYWebImageOperation : NSOperation

@property (nonatomic, strong, readonly) NSURLRequest *request;  ///< The image URL request.

@property (nonatomic, readonly) XYWebImageOptions options;   ///< The operation's option.

@property (nonatomic, strong) NSURLCredential *credential;

/**
 * The expected size of data.
 */
@property (assign, nonatomic) NSInteger expectedSize;

- (instancetype)initWithRequest:(NSURLRequest *)request
                        options:(XYWebImageOptions)options
                          cache:(XYImageCache *)cache
                       cacheKey:(NSString *)cacheKey
                       progress:(XYWebImageProgressBlock)progress
                     completion:(XYWebImageCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
