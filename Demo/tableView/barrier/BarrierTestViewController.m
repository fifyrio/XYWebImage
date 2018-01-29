//
//  BarrierTestViewController.m
//  tableView
//
//  Created by wuw on 2018/1/29.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "BarrierTestViewController.h"

@interface BarrierTestViewController ()

@end

@implementation BarrierTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)onclickRun:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("APP_TEST", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"---1");
    });
    dispatch_async(queue, ^{
        NSLog(@"---2");
    });
    dispatch_async(queue, ^{
        NSLog(@"---3");
    });
    
    dispatch_barrier_sync(queue, ^{
        for (int i = 0; i < 50000; i ++) {
            if (i == 5000) {
                NSLog(@"p1");
            }else if (i == 6000){
                NSLog(@"p2");
            }else if (i == 7000){
                NSLog(@"p2");
            }
        }
        NSLog(@"barrier");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"---4");
    });
    dispatch_async(queue, ^{
        NSLog(@"---5");
    });
    dispatch_async(queue, ^{
        NSLog(@"---6");
    });
}


@end
