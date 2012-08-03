Kache
=============

Kache是为iOS App开发的一款缓存组件。

安装/配置
======================

把Kache目录拷贝到你的工程下。

<pre>
#import "KCH.h"
</pre>

##### *KConfig.h*
<pre>
// 被设置为1，则会打印debug信息。
#define     KACHE_DEBUG                 0

#define     KACHE_DEFAULT_POOL_SIZE     20
#define     KACHE_DEFAULT_QUEUE_SIZE    10

// 缓存默认过期时间为10天。
#define     KACHE_DEFAULT_LIFE_DURATION 864000
</pre>

方法
=========

## + (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration
##### *描述*

设置一个普通的缓存值。

##### *举例*

<pre>
[Kache setValue:@"CacheValueForKeyTest" forKey:@"cache_key" expiredAfter:3600];
NSString *cacheValueA = [Kache valueForKey:@"cache_key"]; // cacheValueA: @"CacheValueForKeyTest"
//1小时后
NSString *cacheValueB = [Kache valueForKey:@"cache_key"]; // cacheValueB: nil
</pre>

## + (void)setValue:(id)value inDefaultPoolForKey:(NSString *)key expiredAfter:(NSInteger)duration
##### *描述*

向默认缓存池中写入一个值。

缓存池是Kache提供的一个有限集合，默认大小为 KACHE_DEFAULT_POOL_SIZE (20)，当池中的缓存数量超过限制，则最先过期的缓存将被清理掉。

##### *举例*

<pre>
 // 设置21个缓存
for (int i = 20; i >= 0; i --) {
    // 当i=0，第21个缓存设置的时候，最先过期的 cache_key_1 将被清理
    [Kache setValue:@"CacheValueForKeyTest"
inDefaultPoolForKey:[NSString stringWithFormat:@"cache_key_%d", i]
       expiredAfter:i+10];
}

NSString *cacheValueA = [Kache valueForKey:@"cache_key_0"]; // cacheValueA: @"CacheValueForKeyTest"
NSString *cacheValueB = [Kache valueForKey:@"cache_key_1"]; // cacheValueB: @"nil"
</pre>

## + (void)pushValue:(id)value
##### *描述*

想默认队列压入一个值

Kache提供一个缓存队列，队列默认长度为 KACHE_DEFAULT_QUEUE_SIZE (10)，压入队列的值在默认时间内过期。

##### *举例*

<pre>
// 把11个值压入队列
for (int i = 10; i >= 0; i --) {
    // 当低11个值 @"QueueValue_0" 压入队列时，最先进入队列的 @"QueueValue_10" 将被清理
    [Kache pushValue:[NSString stringWithFormat:@"QueueValue_%d", i]];
}
NSString *queueValueA = [Kache popValue]; // queueValueA: @"QueueValue_9"，此时队列中还剩9个值
NSString *queueValueB = [Kache popValue]; // queueValueB: @"QueueValue_8"，此时队列中还剩8个值
</pre>
