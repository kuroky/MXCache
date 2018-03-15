//
//  MXCache.m
//  MXCache
//
//  Created by kuroky on 2018/1/12.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import "MXCache.h"
#import <YYCache.h>

#define kCahceName [[[NSBundle mainBundle] infoDictionary] valueForKey:(__bridge NSString *)kCFBundleNameKey]
static NSInteger const kMemoryCacheMaxCount    =   100;  // 内存缓存对象个数上限
static NSInteger const kMemoryCacheExpirytime   =   600; // 内存缓存过期时间上限 10分钟
static NSInteger const kDiskCacheExpirytime   =   259200; // 磁盘缓存过期时间 3天

@interface MXCache ()

@property (strong, nonatomic) YYCache *yyCache;

@end

@implementation MXCache

+ (instancetype)sharedCache {
    static MXCache *mxCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mxCache = [MXCache new];
    });
    return mxCache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [cachePath stringByAppendingPathComponent:kCahceName];
    self.yyCache = [[YYCache alloc] initWithPath:filePath];
    [self.yyCache.memoryCache setCountLimit:kMemoryCacheMaxCount];
    [self.yyCache.memoryCache setAgeLimit:kMemoryCacheExpirytime];
    [self.yyCache.diskCache setAgeLimit:kDiskCacheExpirytime];
}

//MARK:- 读取当前key的缓存(内存)
- (id)mx_memoryCacheForKey:(NSString *)key {
    return [self.yyCache.memoryCache objectForKey:key];
}

//MARK:- 读取当前key的缓存(磁盘)
- (id)mx_diskCacheForKey:(NSString *)key {
    return [self.yyCache.diskCache objectForKey:key];
}

//MARK:- 当前key的缓存是否存在
- (BOOL)mx_containsObjectForKey:(NSString *)key {
    return [self.yyCache containsObjectForKey:key];
}

//MARK:- 小数据缓存到内存
- (void)mx_setObjectMemory:(id)object
                    forKey:(NSString *)key {
    [self.yyCache.memoryCache setObject:object forKey:key];
}

//MARK:- 移除内存中的对应key缓存
- (void)mx_removeMemoryCacheForKey:(NSString *)key {
    [self.yyCache.memoryCache removeObjectForKey:key];
}

//MARK:- 小数据缓存到磁盘
- (void)mx_setObjectDisk:(id)object
                  forKey:(NSString *)key {
    [self.yyCache.diskCache setObject:object forKey:key];
}

//MARK:- 移除磁盘中的对应key缓存
- (void)mx_removeDiskCacheForKey:(NSString *)key {
    [self.yyCache.diskCache removeObjectForKey:key];
}

//MARK:- 小数据缓存到磁盘和内存
- (void)mx_setObject:(id)object
              forKey:(NSString *)key {
    [self.yyCache setObject:object forKey:key];
}

//MARK:- 移除缓存
- (void)mx_removeCacheForKey:(NSString *)key {
    [self.yyCache removeObjectForKey:key];
}

//MARK:- 移除内存缓存
- (void)mx_removeMemoryCache {
    [self.yyCache.memoryCache removeAllObjects];
}

//MARK: - 异步读取磁盘缓存
- (void)mx_objectForKey:(NSString *)key
              withBlock:(void (^)(id<NSCoding> object))block {
    [_yyCache.diskCache objectForKey:key
                           withBlock:^(NSString *key, id<NSCoding> object) {
                               if (block) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       block(object);
                                   });
                               }
                           }];
}

//MARK: - 异步数据缓存到磁盘
- (void)mx_setObject:(id<NSCoding>)object
              ForKey:(NSString *)key
           withBlock:(void (^)(BOOL finish))block {
    [_yyCache.diskCache setObject:object
                           forKey:key
                        withBlock:^{
                            if (block) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    block(YES);
                                });
                            }
                        }];
}

//MARK: - 异步判断磁盘缓存是否存在
- (void)mx_containsObjectForKey:(NSString *)key
                      withBlock:(void (^)(BOOL contains))block {
    [_yyCache.diskCache containsObjectForKey:key
                                   withBlock:^(NSString * _Nonnull key, BOOL contains) {
                                       if (block) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               block(contains);
                                           });
                                       }
                                   }];
}

//MARK: - 异步删除磁盘缓存
- (void)mx_removeObjectForKey:(NSString *)key
                    withBlock:(void (^)(BOOL finish))block {
    [_yyCache.diskCache removeObjectForKey:key
                                 withBlock:^(NSString *key) {
                                     if (block) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             block(YES);
                                         });
                                     }
                                 }];
}

@end
