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
@property (copy, nonatomic) NSString *cachekey;

@end

@implementation ViewController

- (void)viewDidLoad {
    self.navigationItem.title = @"缓存";
    [super viewDidLoad];
    self.model = [TestModel new];
    NSLog(@"%@", self.model);
    self.cachekey = @"model";
    
    [[MXCache sharedCache] mx_removeCacheForKey:self.cachekey]; // 清除缓存
    self.dataList = @[@"save model to memory",
                      @"get model from memory",
                      @"remove model of memory",
                      @"save model to disk",
                      @"get model from disk",
                      @"remove model of disk",
                      @"save model to memory and disk",
                      @"get model from memory or disk",
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
                                           forKey:self.cachekey];
    }
    else if (indexPath.row == 1) {
        TestModel *model = [[MXCache sharedCache] mx_memoryCacheForKey:self.cachekey];
        NSLog(@"%@", model);
    }
    else if (indexPath.row == 2) {
        [[MXCache sharedCache] mx_removeMemoryCacheForKey:self.cachekey];
        TestModel *model = [[MXCache sharedCache] mx_memoryCacheForKey:self.cachekey];
        NSLog(@"%@", model);
    }
    else if (indexPath.row == 3) {
        [[MXCache sharedCache] mx_setObjectDisk:self.model
                                         forKey:self.cachekey];
    }
    else if (indexPath.row == 4) {
        TestModel *model = [[MXCache sharedCache] mx_diskCacheForKey:self.cachekey];
        NSLog(@"%@", model);
    }
    else if (indexPath.row == 5) {
        [[MXCache sharedCache] mx_removeDiskCacheForKey:self.cachekey];
    }
    else if (indexPath.row == 6) {
        [[MXCache sharedCache] mx_setObject:self.model
                                     forKey:self.cachekey];
    }
    else if (indexPath.row == 7) {
        TestModel *model = [[MXCache sharedCache] mx_diskCacheForKey:self.cachekey];
        NSLog(@"disk %@", model);
        
        model = [[MXCache sharedCache] mx_memoryCacheForKey:self.cachekey];
        NSLog(@"memory: %@", model);
    }
    else if (indexPath.row == 8) {
        [[MXCache sharedCache] mx_removeCacheForKey:self.cachekey];
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
    self.name = @"jack";
    self.age = @(20);
    self.address = @"上海";
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

- (NSString *)description {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:_name forKey:@"name"];
    [data setValue:_age forKey:@"age"];
    [data setValue:_address forKey:@"address"];
    return [NSString stringWithFormat:@"<%@:%p>:%@",[self class], &self, data];
}

- (NSString *)debugDescription {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setValue:_name forKey:@"name"];
    [data setValue:_age forKey:@"age"];
    [data setValue:_address forKey:@"address"];
    return [NSString stringWithFormat:@"<%@:%p>:%@",[self class], &self, data];
}

@end
