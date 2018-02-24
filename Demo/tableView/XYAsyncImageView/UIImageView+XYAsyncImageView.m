//
//  UIImageView+SLAsyncImageView.m
//  tableView
//
//  Created by wuw on 2018/1/20.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "UIImageView+XYAsyncImageView.h"

@implementation UIImageView (SLAsyncImageView)

- (void)xy_setImageWithURL:(NSURL *)url{
    __block UIImage *image;
    
    dispatch_main_async_safely(^{
        NSLog(@"xxoo");
        }
    );
    
    dispatch_queue_t asyncQueue = dispatch_queue_create("XYImageDownloadQueue", NULL);
    dispatch_async(asyncQueue, ^{
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        if (imageData) {
            image = [UIImage imageWithData:imageData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:image];
        });
    });
    
}

@end
