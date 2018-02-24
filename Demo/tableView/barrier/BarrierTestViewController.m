//
//  BarrierTestViewController.m
//  tableView
//
//  Created by wuw on 2018/1/29.
//  Copyright © 2018年 Kingnet. All rights reserved.
//

#import "BarrierTestViewController.h"

@interface BarrierTestViewController ()

@property (nonatomic, retain) NSMutableArray *URLOperations;

@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic, strong) dispatch_queue_t barrierQueue;

@end

@implementation BarrierTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup{
    _URLOperations = @[].mutableCopy;
    _downloadQueue = [NSOperationQueue new];
    _barrierQueue = dispatch_queue_create("XYBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 4; i ++) {
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            NSLog(@"%@", [NSString stringWithFormat:@"执行op-%ld", i]);
        }];
        op.name = [NSString stringWithFormat:@"op-%ld", i];
        [_URLOperations addObject:op];
    }
}

- (IBAction)onclickRun:(id)sender {
    NSBlockOperation *op1 = _URLOperations[0];
    [_downloadQueue addOperation:op1];
    
    NSBlockOperation *op2 = _URLOperations[1];
    [_downloadQueue addOperation:op2];
    
    /*有栅栏*/
    dispatch_barrier_sync(self.barrierQueue, ^{
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            
            NSLog(@"%@", [NSString stringWithFormat:@"执行op-新插入的"]);
        }];
        op.name = [NSString stringWithFormat:@"op-新插入的"];
        [self.URLOperations insertObject:op atIndex:2];
    });
     
    NSBlockOperation *op3 = _URLOperations[2];
    [_downloadQueue addOperation:op3];
    
    NSBlockOperation *op4 = _URLOperations[3];
    [_downloadQueue addOperation:op4];
    
    /*新加入的线程*/
    NSBlockOperation *op5 = _URLOperations[4];
    [_downloadQueue addOperation:op5];
    
    
    /*
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
     */
}


@end
