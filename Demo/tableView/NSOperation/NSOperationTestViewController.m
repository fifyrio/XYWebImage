//
//  NSOperationTestViewController.m
//  tableView
//
//  Created by wuw on 2018/1/30.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "NSOperationTestViewController.h"
#import "XYWebImageDownloaderOperation.h"

@interface NSOperationTestViewController ()

@end

@implementation NSOperationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)onclickRun:(id)sender {
    NSOperationQueue *queue = [NSOperationQueue new];
    
    dispatch_apply(6, dispatch_get_global_queue(0, 0), ^(size_t i) {
        NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517314899394&di=ea2afc21523af456abb73f049c48fb8b&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F503d269759ee3d6db032f61b48166d224e4ade6e.jpg"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        XYWebImageDownloaderOperation *op = [[XYWebImageDownloaderOperation alloc] initWithRequest:request session:nil];
        op.name = [NSString stringWithFormat:@"XYWebImageDownloaderOperation-%zu", i];
        [queue addOperation:op];
    });
    
}

@end
