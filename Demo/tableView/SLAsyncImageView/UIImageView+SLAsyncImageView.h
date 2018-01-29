//
//  UIImageView+SLAsyncImageView.h
//  tableView
//
//  Created by wuw on 2018/1/20.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLAsyncImageCompat.h"

@interface UIImageView (SLAsyncImageView)

- (void)sl_setImageWithURL:(NSURL *)url;

@end
