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
@property (strong, nonatomic) TestModel *model;
@property (copy, nonatomic) NSString *modelKey;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"缓存";
    [super viewDidLoad];
    self.model = [TestModel new];
    NSLog(@"init model :%@ %@ %@", self.model.name, self.model.age, self.model.address);
    self.modelKey = @"model";
    [[MXCache sharedCache] mx_removeCacheForKey:self.modelKey]; // 清除c缓存
    self.dataList = @[@"save model to memory",
                      @"get model from memory",
                      @"remove model of memory",
                      @"save model to disk",
                      @"get model from disk",
                      @"remove model of disk",
                      @"save model to memory and disk",
                      @"get model to memory and disk",
                      @"remove model of memory and disk"];
    self.tableView.rowHeight = 50;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellId];
}

//MARK:- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [[MXCache sharedCache] mx_setObjectMemory:self.model
                                           forKey:self.modelKey];
    }
    else if (indexPath.row == 1) {
        TestModel *model = [[MXCache sharedCache] mx_memoryCacheForKey:self.modelKey];
        NSLog(@"cache model :%@ %@ %@", model.name, model.age, model.address);
    }
    else if (indexPath.row == 2) {
        [[MXCache sharedCache] mx_removeMemoryCacheForKey:self.modelKey];
    }
    else if (indexPath.row == 3) {
        [[MXCache sharedCache] mx_setObjectDisk:self.model
                                         forKey:self.modelKey];
    }
    else if (indexPath.row == 4) {
        TestModel *model = [[MXCache sharedCache] mx_diskCacheForKey:self.modelKey];
        NSLog(@"cache model :%@ %@ %@", model.name, model.age, model.address);
    }
    else if (indexPath.row == 5) {
        [[MXCache sharedCache] mx_removeDiskCacheForKey:self.modelKey];
    }
    else if (indexPath.row == 6) {
        [[MXCache sharedCache] mx_setObject:self.model
                                     forKey:self.modelKey];
    }
    else if (indexPath.row == 7) {
        TestModel *model = [[MXCache sharedCache] mx_cacheForKey:self.modelKey];
        NSLog(@"cache model :%@ %@ %@", model.name, model.age, model.address);
    }
    else if (indexPath.row == 8) {
        [[MXCache sharedCache] mx_removeCacheForKey:self.modelKey];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface TestModel () <NSCoding, NSCopying>

@end

@implementation TestModel

- (NSArray *)names {
    __block NSArray *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[@"name1", @"name2", @"name3", @"name4", @"name5"];
    });
    return arr;
}

- (NSArray *)ages {
    __block NSArray *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[@1, @2, @3, @4, @5];
    });
    return arr;
}

- (NSArray *)addresss {
    __block NSArray *arr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        arr = @[@"address1", @"address2", @"address3", @"address4", @"address5"];
    });
    return arr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self createRandomValue];
}

- (void)createRandomValue {
    self.name = [self names][arc4random() % 5];
    self.age = [self ages][arc4random() % 5];
    self.address = [self addresss][arc4random() % 5];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.address forKey:@"address"];
}

- (id)copyWithZone:(NSZone *)zone {
    TestModel *model = [[self class] allocWithZone:zone];
    model.name = [self.name copy];
    model.age = [self.age copy];
    model.address = [self.address copy];
    return model;
}

@end
