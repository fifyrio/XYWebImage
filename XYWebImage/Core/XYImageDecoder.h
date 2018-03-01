//
//  XYImageDecoder.h
//  tableView
//
//  Created by wuw on 2018/2/27.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Image file type.
 */
typedef NS_ENUM(NSUInteger, XYImageType) {
    XYImageTypeUnknown = 0, ///< unknown
    XYImageTypeJPEG,        ///< jpeg, jpg
    XYImageTypeJPEG2000,    ///< jp2
    XYImageTypeTIFF,        ///< tiff, tif
    XYImageTypeBMP,         ///< bmp
    XYImageTypeICO,         ///< ico
    XYImageTypeICNS,        ///< icns
    XYImageTypeGIF,         ///< gif
    XYImageTypePNG,         ///< png
    XYImageTypeWebP,        ///< webp
    XYImageTypeOther,       ///< other image format
};

@interface XYImageDecoder : NSObject

@property (nonatomic, readonly) XYImageType type;          ///< Image data type.

+ (instancetype)decoderWithData:(NSData *)data scale:(CGFloat)scale;

- (instancetype)init;

- (instancetype)initWithScale:(CGFloat)scale;

#pragma mark - Public methods
- (BOOL)updateData:(NSData *)data isFinal:(BOOL)isFinal;

- (UIImage *)getRenderedImage;

@end
