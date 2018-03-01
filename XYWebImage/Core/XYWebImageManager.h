//
//  XYWebImageManager.h
//  tableView
//
//  Created by wuw on 2018/2/26.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYImageCache.h"

@class XYWebImageOperation;

NS_ASSUME_NONNULL_BEGIN

@interface XYWebImageManager : NSObject

#pragma mark
typedef NS_OPTIONS(NSUInteger, XYWebImageOptions) {
    
    /// Display progressive/interlaced/baseline image during download (same as web browser).
    XYWebImageOptionProgressive = 1 << 1,
    
    /// Display blurred progressive JPEG or interlaced PNG image during download.
    /// This will ignore baseline image for better user experience.
    XYWebImageOptionProgressiveBlur = 1 << 2,
    
    /// Use NSURLCache instead of YYImageCache.
    XYWebImageOptionUseNSURLCache = 1 << 3,
    
    XYWebImageOptionAllowInvalidSSLCertificates = 1 << 4,
    
    /// Handles cookies stored in NSHTTPCookieStore.
    XYWebImageOptionHandleCookies = 1 << 6,
};

typedef void(^XYWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void (^XYWebImageCompletionBlock)(UIImage * image, NSURL *url, NSError * error);

#pragma mark

@property (nullable, nonatomic, strong) XYImageCache *cache;

@property (nullable, nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic) NSTimeInterval timeout;

#pragma mark

+ (instancetype)sharedManager;

- (XYWebImageOperation *)requestImageWithURL:(NSURL *)url
                                     options:(XYWebImageOptions)options
                                    progress:(XYWebImageProgressBlock)progress
                                  completion:(XYWebImageCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
