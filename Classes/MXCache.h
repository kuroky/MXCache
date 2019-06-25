//
//  MXCache.h
//  MXCache
//
//  Created by kuroky on 2018/1/12.
//  Copyright © 2018年 kuroky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 基于YYCache的封装  https://github.com/ibireme/YYCache
 */
@interface MXCache : NSObject

/**
 MXCache

 @return MXCache 初始化
 */
+ (instancetype)sharedCache;

/**
 设置缓存路径

 @param path file path
 */
- (void)mx_setCachePath:(nullable NSString *)path;

/**
 缓存设置 可选

 @param count 内存缓存对象个数上限
 @param timer1 内存缓存过期时间上限
 @param timer2 磁盘缓存过期时间
 */
- (void)mx_mCacheCount:(NSInteger)count
           mExpirytime:(NSInteger)timer1
           dExpirytime:(NSInteger)timer2;

/**
 读取当前key的缓存(内存)
 
 @param key 缓存的key
 @return 缓存值
 */
- (id)mx_memoryCacheForKey:(NSString *)key;

/**
 读取当前key的缓存(磁盘)
 
 @param key 缓存的key
 @return 缓存值
 */
- (id)mx_diskCacheForKey:(NSString *)key;

/**
 当前key的缓存是否存在
 
 @param key 缓存的key
 @return BOOL
 */
- (BOOL)mx_containsObjectForKey:(NSString *)key;

/**
 小数据缓存到内存
 
 @param object 需要保存的数据(需实现NSCoding协议)
 @param key 缓存的key
 */
- (void)mx_setObjectMemory:(id)object
                    forKey:(NSString *)key;


/**
 移除内存中的对应key缓存
 
 @param key 缓存的key
 */
- (void)mx_removeMemoryCacheForKey:(NSString *)key;

/**
 小数据缓存到磁盘
 
 @param object 数据
 @param key 缓存的key
 */
- (void)mx_setObjectDisk:(id)object
                  forKey:(NSString *)key;

/**
 移除磁盘中的对应key缓存
 
 @param key 缓存的key
 */
- (void)mx_removeDiskCacheForKey:(NSString *)key;

/**
 小数据缓存到磁盘和内存
 
 @param object 数据
 @param key 缓存的key
 */
- (void)mx_setObject:(id)object
              forKey:(NSString *)key;

/**
 移除缓存
 
 @param key 缓存的key
 */
- (void)mx_removeCacheForKey:(NSString *)key;

/**
 移除内存缓存
 */
- (void)mx_removeMemoryCache;

#pragma mark 大数据异步

/**
 读取磁盘缓存 异步
 
 @param key 缓存的key
 @param block blcok
 */
- (void)mx_objectForKey:(NSString *)key
              withBlock:(void (^)(id<NSCoding> object))block;

/**
 插入数据
 
 @param object 缓存数据到磁盘
 @param key 缓存的key
 @param block block
 */
- (void)mx_setObject:(id<NSCoding>)object
              ForKey:(NSString *)key
           withBlock:(void (^)(BOOL finish))block;

/**
 判断磁盘缓存是否存在
 
 @param key 缓存的key
 @param block block
 */
- (void)mx_containsObjectForKey:(NSString *)key
                      withBlock:(void (^)(BOOL contains))block;

/**
 异步删除指定key的磁盘缓存
 
 @param key 缓存的key
 */
- (void)mx_removeObjectForKey:(NSString *)key
                    withBlock:(void (^)(BOOL finish))block;

@end

NS_ASSUME_NONNULL_END
