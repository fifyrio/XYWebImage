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

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
            
    NSURLSesstionTestViewController* mainVC = [[NSURLSesstionTestViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navVC;
    
    [[XYSelfTestTool tool] showFPS];
    
    return YES;
}


@end
