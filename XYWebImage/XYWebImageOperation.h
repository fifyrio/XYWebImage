//
//  XYWebImageOperation.h
//  tableView
//
//  Created by wuw on 2018/2/23.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYWebImageOperation : NSOperation

@property (nonatomic, strong, readonly)           NSURLRequest      *request;  ///< The image URL request.

- (instancetype)initWithRequest:(NSURLRequest *)request;

@end
