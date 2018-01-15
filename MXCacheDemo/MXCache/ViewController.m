//
//  ViewController.m
//  MXCache
//
//  Created by kuroky on 2018/1/12.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "ViewController.h"
#import "MXCache.h"

static NSString *const kCellId  =   @"cellId";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"缓存";
    [super viewDidLoad];
    self.dataList = @[@"", @"", @"", @""];
    self.tableView.rowHeight = 60;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
}

//MARK:- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[MXCache sharedCache] mx_containsObjectForKey:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
