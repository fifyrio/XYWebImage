//
//  UIImage+XYWebImage.h
//  tableView
//
//  Created by wuw on 2018/2/28.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XYWebImage)

- (UIImage *)xy_imageByGrayscale;

- (UIImage *)xy_imageByBlurSoft;

- (UIImage *)xy_imageByBlurLight;

- (UIImage *)xy_imageByBlurExtraLight;

- (UIImage *)xy_imageByBlurDark;

- (UIImage *)xy_imageByBlurWithTint:(UIColor *)tintColor;

- (UIImage *)xy_imageByBlurRadius:(CGFloat)blurRadius
                        tintColor:(UIColor *)tintColor
                         tintMode:(CGBlendMode)tintBlendMode
                       saturation:(CGFloat)saturation
                        maskImage:(UIImage *)maskImage ;

@end
