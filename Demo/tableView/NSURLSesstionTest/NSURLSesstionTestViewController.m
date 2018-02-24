//
//  NSURLSesstionTestViewController.m
//  tableView
//
//  Created by wuw on 2018/1/29.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "NSURLSesstionTestViewController.h"

@interface NSURLSesstionTestViewController ()<NSURLSessionDelegate,NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSURLSessionDataTask *task;

@property (nonatomic, retain) NSMutableData *receiveData;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NSURLSesstionTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* dispatch_apply相当于一个for循环
    dispatch_apply(6, dispatch_get_global_queue(0, 0), ^(size_t i) {
        [NSThread sleepForTimeInterval:arc4random()%5];
        NSLog(@"线程: %@ 第%zu次", [NSThread currentThread], i);
    });
    NSLog(@"结束");
     */
}

- (IBAction)onclickRun:(id)sender {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    sessionConfig.timeoutIntervalForRequest = 15;
    self.session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    NSURL *URL = [NSURL URLWithString:@"http://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517228561465&di=3d2fd1fe24e88e9d3226f074a8783546&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F503d269759ee3d6db032f61b48166d224e4ade6e.jpg"];
    self.task = [self.session dataTaskWithRequest:[NSURLRequest requestWithURL:URL]];
    [self.task resume];
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    NSLog(@"didReceiveResponse");
    NSInteger expected = (NSInteger)response.expectedContentLength;
    self.receiveData = [[NSMutableData alloc] initWithCapacity:expected];
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask{
    NSLog(@"didBecomeDownloadTask");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    NSLog(@"didReceiveData");
    [self.receiveData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    NSLog(@"didCompleteWithError");
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [[UIImage alloc] initWithData:self.receiveData];
//            self.imageView.image = image;
            self.view.layer.contents = (__bridge id)image.CGImage;
        });
        
    }
}


#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
    NSLog(@"didBecomeInvalidWithError");
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    NSLog(@"didReceiveChallenge");
}

@end
