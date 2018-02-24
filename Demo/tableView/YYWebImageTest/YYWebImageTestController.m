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

typedef NS_OPTIONS(NSUInteger, XYWebImageOperationOption){
    XYWebImageOperationOption1 = 0,
    XYWebImageOperationOption2 = 1 << 0,
    XYWebImageOperationOption3 = 1 << 1,
    XYWebImageOperationOption4 = 1 << 2,
};

@interface YYWebImageTestController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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
    /*
    NSString *url = @"http://5b0988e595225.cdn.sohucs.com/images/20171208/f394d60ed1a047d89561a1a7326c0f01.png";
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:url] options:YYWebImageOptionProgressive ];
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
    
    XYWebImageOperationOption op = XYWebImageOperationOption1;
    NSLog(@"%ld", op);
    
    op = XYWebImageOperationOption2;
    NSLog(@"%ld", op);
    
    op = XYWebImageOperationOption3;
    NSLog(@"%ld", op);
    
    op = XYWebImageOperationOption4;
    NSLog(@"%ld", XYWebImageOperationOption3 | XYWebImageOperationOption4);
}

- (IBAction)onclickClear:(id)sender {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    
    // clear cache
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
}

@end
