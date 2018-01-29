//
//  MainViewController.m
//  tableView
//
//  Created by 吴伟 on 15/10/9.
//  Copyright © 2015年 com.weizong. All rights reserved.
//

#import "MainViewController.h"
#import "XYTableViewCell.h"
#import "UIImageView+SLAsyncImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+AFNetworking.h"

static NSString * const kXYTableViewCell = @"XYTableViewCell";

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArray;
@end

@implementation MainViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *arr = @[].mutableCopy;
    for (NSInteger i = 0; i < 1000; i ++) {
        NSString *url = @"http://img.biangejia.com/wp-content/uploads/2016/12/19-b00.jpg";
        float height = (float)((arc4random() % 101) + 200);
        [arr addObject:@{@"url":url, @"height":[NSNumber numberWithFloat:height]}];
    }
    self.dataArray = arr;
    
    [self setupViews];
}

#pragma mark - Initialize
- (void)setupViews{
    [self.tableView registerNib:[UINib nibWithNibName:kXYTableViewCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kXYTableViewCell];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kXYTableViewCell];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSURL *imageUrl = [NSURL URLWithString:dict[@"url"]];
    
//    [cell.photoImageView sl_setImageWithURL:imageUrl];
    [cell.photoImageView sd_setImageWithURL:imageUrl];
    [cell.photoImageView setImageWithURL:imageUrl];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.row];
    return [dict[@"height"] floatValue];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
