//
//  XYSelfTestTool.m
//  XYHiRepairs
//
//  Created by wuw on 2017/5/4.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYSelfTestTool.h"
#import "YYFPSLabel.h"

@interface XYSelfTestTool ()

@property (nonatomic, strong) UIButton *testBtn;

@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation XYSelfTestTool

#pragma mark - 单例
static XYSelfTestTool * __singleton__;
+ (XYSelfTestTool *)tool{
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{ __singleton__ = [[[self class] alloc] init]; } );
    return __singleton__;
}

#pragma mark - Public
- (void)showFPS{
    _fpsLabel = [YYFPSLabel new];
    _fpsLabel.alpha = 0.9;
    _fpsLabel.frame = CGRectMake(0, 200, 50, 30);
    [_fpsLabel sizeToFit];
    [[UIApplication sharedApplication].keyWindow addSubview:_fpsLabel];
}

- (void)beginTest{
    
}

#pragma mark - Life cycle
- (UIButton *)testBtn{
    if (_testBtn == nil) {
        _testBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _testBtn.backgroundColor = [UIColor blackColor];
        _testBtn.alpha = 0.2;
        [_testBtn setTitle:@"test" forState:UIControlStateNormal];
        _testBtn.layer.cornerRadius = 4;
        _testBtn.layer.masksToBounds = YES;
        [_testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _testBtn;
}

@end
