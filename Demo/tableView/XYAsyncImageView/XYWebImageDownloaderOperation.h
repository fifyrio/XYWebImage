//
//  XYWebImageDownloaderOperation.h
//  tableView
//
//  Created by wuw on 2018/1/30.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYWebImageDownloaderOperation : NSOperation

- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session;

@end
