//
//  ImageIOTestViewController.m
//  tableView
//
//  Created by wuw on 2018/1/30.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "ImageIOTestViewController.h"
#import <ImageIO/ImageIO.h>
#import <YYWebImage.h>

@interface ImageIOTestViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ImageIOTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
//    CFArrayRef mySourceTypes = CGImageSourceCopyTypeIdentifiers();
//    CFShow(mySourceTypes);
//    CFArrayRef myDestinationTypes = CGImageDestinationCopyTypeIdentifiers();
//    CFShow(myDestinationTypes);
}

CGImageRef MyCreateCGImageFromFile(NSString *path)
{
    NSURL *url = [NSURL URLWithString:path];
    
    CGImageRef image;
    CGImageSourceRef imageSource;
    
    CFDictionaryRef imageOptions;
    CFStringRef imageKeys[2];
    CFTypeRef imageValues[2];
    //缓存键值对
    imageKeys[0] = kCGImageSourceShouldCache;
    imageValues[0] = (CFTypeRef)kCFBooleanTrue;
    //float-point键值对
    imageKeys[1] = kCGImageSourceShouldAllowFloat;
    imageValues[1] = (CFTypeRef)kCFBooleanTrue;
    //获取Dictionary，用来创建资源
    imageOptions = CFDictionaryCreate(NULL, (const void **) imageKeys,
                                      (const void **) imageValues, 2,
                                      &kCFTypeDictionaryKeyCallBacks,
                                      &kCFTypeDictionaryValueCallBacks);
    //资源创建
    imageSource = CGImageSourceCreateWithURL((CFURLRef)url, imageOptions);
    CFRelease(imageOptions);
    
    if (imageSource == NULL) {
        return NULL;
    }
    //图片获取，index=0
    image = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
    return image;
}
- (IBAction)onclickRun:(id)sender {
    
    NSString *str1 = [NSString stringWithFormat:@"我去\n%@", @"xx"];
    
    
    NSString* outputStr = [[NSBundle mainBundle] pathForResource:@"321561508582151" ofType:@"jpg"];
    NSString *str = NSHomeDirectory();
    NSString *url = @"http://www.lighthouse-cove.com/images/home-banner-1.jpg";
    CGImageRef image = MyCreateCGImageFromFile(url);
    self.imageView.image = [UIImage imageWithCGImage:image];
    
    /*
    NSString *url = @"http://www.lighthouse-cove.com/images/home-banner-1.jpg";
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionProgressive];
     */
    
    NSLog(@"");
}

@end
