//
//  YYWebImageTestController.m
//  tableView
//
//  Created by wuw on 2018/2/23.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "YYWebImageTestController.h"
#import <YYWebImage.h>
#import "XYWebImageOperation.h"
#import "UIImageView+XYWebImage.h"
#import <pthread.h>
#import "UIImage+XYWebImage.h"

typedef NS_OPTIONS(NSUInteger, XYWebImageOperationOption){
    XYWebImageOperationOption1 = 0,
    XYWebImageOperationOption2 = 1 << 0,
    XYWebImageOperationOption3 = 1 << 1,
    XYWebImageOperationOption4 = 1 << 2,
};

@interface YYWebImageTestController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) XYWebImageOperation *operation;
@end

@implementation YYWebImageTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"method1");
        sleep(10);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"method2");
        dispatch_semaphore_signal(semaphore);
    });
    */
}

- (IBAction)onclickRun:(id)sender {
    self.imageView.image = nil;
    
    /*
//    NSString *url = @"https://i.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg";
    NSString *url = @"http://imgsrc.baidu.com/imgad/pic/item/cc11728b4710b912c0057563c9fdfc0393452262.jpg";
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionProgressive];
   */
    
    /*
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for (NSInteger i = 0; i < 10; i ++) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@""]];
        XYWebImageOperation *operation = [[XYWebImageOperation alloc] initWithRequest:request];
        operation.name = @"com.will.1";
        [queue addOperation:operation];
    }
    */
    
    /*
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@""]];
    XYWebImageOperation *operation = [[XYWebImageOperation alloc] initWithRequest:request];
    operation.name = @"com.will.1";
    [operation start];
     */
    
    /*
    XYWebImageOperationOption op = XYWebImageOperationOption1;
    NSLog(@"%ld", op);
    
    op = XYWebImageOperationOption2;
    NSLog(@"%ld", op);
    
    op = XYWebImageOperationOption3;
    NSLog(@"%ld", op);
    
    op = XYWebImageOperationOption4;
    NSLog(@"%ld", XYWebImageOperationOption3 | XYWebImageOperationOption4);
     */
    
    /*
    NSString *url = @"https://i.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    */
    
    /*
//    NSString *url = @"https://i.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg";
    NSString *url = @"http://cc.cocimg.com/api/uploads/20170707/1499394752139363.png";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];    
    _operation = [[XYWebImageOperation alloc] initWithRequest:request];
    [_operation start];
    
    __weak __typeof(self)_self = self;
    [_operation setCompletionBlock:^(UIImage * _Nullable image, NSError * _Nullable error) {
        __strong typeof(_self) self = _self;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    }];
    */
    
    /*
    UIImage *oriImage = [UIImage imageNamed:@"lena.jpg"];
    oriImage = [oriImage xy_imageByBlurRadius:10 tintColor:nil tintMode:0 saturation:1 maskImage:nil];
    self.imageView.image = oriImage;
    */

    /*
    static int32_t counter = 0;
    int32_t cur = OSAtomicIncrement32(&counter);
    NSLog(@"");
     */
    
    /*
    dispatch_queue_t queue = dispatch_queue_create("com.will.image.decode", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < 10; i ++) {
        dispatch_sync(queue, ^{
            NSLog(@"%@ - %d", [NSThread currentThread],i);
                  });
    }
    */
    
    /**/
    NSString *url = @"https://i.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg";
    url = @"http://imgsrc.baidu.com/imgad/pic/item/cc11728b4710b912c0057563c9fdfc0393452262.jpg";
//    NSString *url = @"http://cc.cocimg.com/api/uploads/20170707/1499394752139363.png";
    [self.imageView xy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:XYWebImageOptionProgressive];
     
}



- (IBAction)onclickClear:(id)sender {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    
    // clear cache
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
    
    NSUInteger memoryCapacity = [[NSURLCache sharedURLCache] memoryCapacity];
    NSUInteger currentMemoryUsage = [[NSURLCache sharedURLCache] currentMemoryUsage];
    NSUInteger diskCapacity = [[NSURLCache sharedURLCache] diskCapacity];
    NSUInteger currentDiskUsage = [[NSURLCache sharedURLCache] currentDiskUsage];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    memoryCapacity = [[NSURLCache sharedURLCache] memoryCapacity];
    currentMemoryUsage = [[NSURLCache sharedURLCache] currentMemoryUsage];
    diskCapacity = [[NSURLCache sharedURLCache] diskCapacity];    
    currentDiskUsage = [[NSURLCache sharedURLCache] currentDiskUsage];
    NSLog(@"");
}

@end
