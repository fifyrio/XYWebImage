//
//  XYImageDecoder.m
//  tableView
//
//  Created by wuw on 2018/2/27.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "XYImageDecoder.h"
#import <pthread.h>
#import <ImageIO/ImageIO.h>
#import <CoreFoundation/CoreFoundation.h>

#define XY_FOUR_CC(c1,c2,c3,c4) ((uint32_t)(((c4) << 24) | ((c3) << 16) | ((c2) << 8) | (c1)))
#define XY_TWO_CC(c1,c2) ((uint16_t)(((c2) << 8) | (c1)))

@interface XYImageDecoder ()

@property (nullable, nonatomic, readonly) NSData *data;    ///< Image data.

@property (nonatomic, assign) BOOL isFinal;

@property (nonatomic, readonly) CGFloat scale;             ///< Image scale.

@end


@implementation XYImageDecoder{
    pthread_mutex_t _recursiveLock; // recursive lock
    BOOL _sourceTypeDetected;
    CGImageSourceRef _source;
}

#pragma mark - Life cycle

+ (instancetype)decoderWithData:(NSData *)data scale:(CGFloat)scale {
    if (!data) return nil;
    XYImageDecoder *decoder = [[[self class] alloc] initWithScale:scale];
    [decoder updateData:data isFinal:YES];
    return decoder;
}

- (instancetype)init {
    return [self initWithScale:[UIScreen mainScreen].scale];
}

- (instancetype)initWithScale:(CGFloat)scale{
    self = [super init];
    if (self) {
        if (scale <= 0) scale = 1;
        _scale = scale;
        
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);//定义锁的类别
        pthread_mutex_init(&_recursiveLock, &attr);
        pthread_mutexattr_destroy (&attr);
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_recursiveLock);
    if (_source) CFRelease(_source);
}

#pragma mark - Public methods
- (BOOL)updateData:(NSData *)data isFinal:(BOOL)isFinal{
    BOOL result = NO;
    pthread_mutex_lock(&_recursiveLock);
    result = [self _updateData:data isFinal:isFinal];
    pthread_mutex_unlock(&_recursiveLock);
    return result;
}

- (UIImage *)getRenderedImage{
    UIImage *image = nil;
    pthread_mutex_lock(&_recursiveLock);
    image = [self _getRenderedImage];
    pthread_mutex_unlock(&_recursiveLock);
    return image;    
}

#pragma mark - Private
- (UIImage *)_getRenderedImage{
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_source, 0, NULL);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
//    CFRelease(_source);
//    _source = NULL;
    return image;
}

- (BOOL)_updateData:(NSData *)data isFinal:(BOOL)isFinal{
    if (data.length < _data.length) {
        return NO;
    }
    _data = data;
    _isFinal = isFinal;
    
    XYImageType type = XYImageDetectType((__bridge CFDataRef)data);
    if (_sourceTypeDetected) {
        if (_type != type) {
            return NO;
        } else {
            [self _updateSource];
        }
    }else{
        if (_data.length > 16) {
            _type = type;
            _sourceTypeDetected = YES;
            [self _updateSource];
        }
    }
    return YES;
}

- (void)_updateSource{
    switch (_type) {

        case XYImageTypePNG: {
            [self _updateSourceAPNG];
        } break;
            
        default: {
            [self _updateSourceImageIO];
        } break;
    }
}

- (void)_updateSourceAPNG{
    [self _updateSourceImageIO];
}

- (void)_updateSourceImageIO{
    if (_source) {
        CGImageSourceUpdateData(_source, (__bridge CFDataRef)_data, _isFinal);
    }else{
        if (_isFinal) {
            _source = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
        }else{
            _source = CGImageSourceCreateIncremental(NULL);
            if (_source) CGImageSourceUpdateData(_source, (__bridge CFDataRef)_data, _isFinal);
        }
    }
}

#pragma mark - coder
XYImageType XYImageDetectType(CFDataRef data) {
    if (!data) return XYImageTypeUnknown;
    uint64_t length = CFDataGetLength(data);
    if (length < 16) return XYImageTypeUnknown;
    
    const char *bytes = (char *)CFDataGetBytePtr(data);
    
    uint32_t magic4 = *((uint32_t *)bytes);
    switch (magic4) {
        case XY_FOUR_CC(0x4D, 0x4D, 0x00, 0x2A): { // big endian TIFF
            return XYImageTypeTIFF;
        } break;
            
        case XY_FOUR_CC(0x49, 0x49, 0x2A, 0x00): { // little endian TIFF
            return XYImageTypeTIFF;
        } break;
            
        case XY_FOUR_CC(0x00, 0x00, 0x01, 0x00): { // ICO
            return XYImageTypeICO;
        } break;
            
        case XY_FOUR_CC(0x00, 0x00, 0x02, 0x00): { // CUR
            return XYImageTypeICO;
        } break;
            
        case XY_FOUR_CC('i', 'c', 'n', 's'): { // ICNS
            return XYImageTypeICNS;
        } break;
            
        case XY_FOUR_CC('G', 'I', 'F', '8'): { // GIF
            return XYImageTypeGIF;
        } break;
            
        case XY_FOUR_CC(0x89, 'P', 'N', 'G'): {  // PNG
            uint32_t tmp = *((uint32_t *)(bytes + 4));
            if (tmp == XY_FOUR_CC('\r', '\n', 0x1A, '\n')) {
                return XYImageTypePNG;
            }
        } break;
            
        case XY_FOUR_CC('R', 'I', 'F', 'F'): { // WebP
            uint32_t tmp = *((uint32_t *)(bytes + 8));
            if (tmp == XY_FOUR_CC('W', 'E', 'B', 'P')) {
                return XYImageTypeWebP;
            }
        } break;
            /*
             case XY_FOUR_CC('B', 'P', 'G', 0xFB): { // BPG
             return XYImageTypeBPG;
             } break;
             */
    }
    
    uint16_t magic2 = *((uint16_t *)bytes);
    switch (magic2) {
        case XY_TWO_CC('B', 'A'):
        case XY_TWO_CC('B', 'M'):
        case XY_TWO_CC('I', 'C'):
        case XY_TWO_CC('P', 'I'):
        case XY_TWO_CC('C', 'I'):
        case XY_TWO_CC('C', 'P'): { // BMP
            return XYImageTypeBMP;
        }
        case XY_TWO_CC(0xFF, 0x4F): { // JPEG2000
            return XYImageTypeJPEG2000;
        }
    }
    
    // JPG             FF D8 FF
    if (memcmp(bytes,"\377\330\377",3) == 0) return XYImageTypeJPEG;
    
    // JP2
    if (memcmp(bytes + 4, "\152\120\040\040\015", 5) == 0) return XYImageTypeJPEG2000;
    
    return XYImageTypeUnknown;
}

@end
