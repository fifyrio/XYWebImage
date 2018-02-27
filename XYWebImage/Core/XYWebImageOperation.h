//
//  XYWebImageOperation.h
//  tableView
//
//  Created by wuw on 2018/2/23.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYWebImageManager.h"

@interface XYWebImageOperation : NSOperation

@property (nonatomic, strong, readonly) NSURLRequest *request;  ///< The image URL request.

@property (nonatomic, readonly) XYWebImageOptions options;   ///< The operation's option.

@property (nonatomic, strong) NSURLCredential *credential;

/**
 * The expected size of data.
 */
@property (assign, nonatomic) NSInteger expectedSize;

- (instancetype)initWithRequest:(NSURLRequest *)request;

@property (nonatomic, copy) XYWebImageCompletionBlock completionBlock;

@end
