//
//  XYWebImageManager.h
//  tableView
//
//  Created by wuw on 2018/2/26.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYWebImageManager : NSObject

typedef NS_OPTIONS(NSUInteger, XYWebImageOptions) {
    XYWebImageOptionAllowInvalidSSLCertificates = 1 << 4,
};

typedef void(^XYWebImageProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void (^XYWebImageCompletionBlock)(UIImage * _Nullable image,
                                          NSError * _Nullable error);

@end
