//
//  AppDelegate.m
//  tableView
//
//  Created by 吴伟 on 14-10-5.
//  Copyright (c) 2014年 com.weizong. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "XYSelfTestTool.h"
#import "BarrierTestViewController.h"
#import "NSURLSesstionTestViewController.h"
#import "NSOperationTestViewController.h"
#import "ImageIOTestViewController.h"
#import "YYWebImageTestController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    NSUInteger memorySize = 1024 * 1024 * 64;
//    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:memorySize diskCapacity:memorySize diskPath:nil];
//    [NSURLCache setSharedURLCache:sharedCache];
//    NSLog(@"cap: %ld", [[NSURLCache sharedURLCache] diskCapacity]);
    
    YYWebImageTestController* mainVC = [[YYWebImageTestController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navVC;
    
    [[XYSelfTestTool tool] showFPS];
    
    return YES;
}


@end
