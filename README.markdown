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

##### *参数*

value       id              要存入的缓存值
key         NSString        缓存键名
duration    NSInteger       过期时长

##### *返回值*

无

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

##### *参数*

value       id              要存入的缓存值
key         NSString        缓存键名
duration    NSInteger       过期时长

##### *返回值*

无

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

向默认队列压入一个值

Kache提供一个缓存队列，队列默认长度为 KACHE_DEFAULT_QUEUE_SIZE (10)，压入队列的值在默认时间内过期。

##### *参数*

value       id              要存入的缓存值

##### *返回值*

无

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

## + (id)popValue
##### *描述*

从默认队列中取出一个值

##### *参数*

无

##### *返回值*

如果队列不为空，则返回队列底部的值

## + (id)valueForKey:(NSString *)key;
##### *描述*

从缓存中取出某个值

##### *参数*

key         NSString        要取值的键名    

##### *返回值*

如果该键对应有值，则返回缓存值，否则返回空

## + (void)newQueueWithName:(NSString *)name size:(NSInteger)size
##### *描述*

新建一个缓存队列

##### *参数*

name        NSString        新建队列的名称
size        NSInteger       队列长度

##### *返回值*

无

## *举例*

<pre>
[Kache newQueueWithName:@"new_queue" size:10];
[Kache pushValue:@"QueueValueIn:new_queue" toQueue:@"new_queue"];
NSString *queueValue = [Kache popFromQueue:@"new_queue"]; // queueValue: @"QueueValueIn:new_queue"
</pre>

## + (void)newPoolWithName:(NSString *)name size:(NSInteger)size
##### *描述*

新建一个缓存池

##### *参数*

name        NSString        新建缓存池的名称
size        NSInteger       池的最大容量

##### *返回值*

无

## *举例*

<pre>
[Kache newPoolWithName:@"new_pool" size:10];
[Kache setValue:@"NewPoolValueIn:new_pool" inPool:@"new_pool" forKey:@"cache_key_in_new_pool" expiredAfter:3600];
NSString *poolValue = [Kache valueForKey:@"cache_key_in_new_pool"]; // poolValue: @"NewPoolValueIn:new_pool"
</pre>


## + (void)setValue:(id)value inPool:(NSString *)name forKey:(NSString *)key expiredAfter:(NSInteger)duration
##### *描述*

添加一个值到指定缓存池中。

注意：在添加之前，需要确认该池已经创建

##### *参数*

value       id              要存入的缓存值
name        NSString        要存入的池名称
key         NSString        缓存键名
duration    NSInteger       过期时长

##### *返回值*

无

## + (void)pushValue:(id)value toQueue:(NSString *)name
##### *描述*

添加一个值到指定队列中。

注意：在添加之前，需要确认该队列已经创建

##### *参数*

value       id              要存入的缓存值
name        NSString        要存入的队列名称

##### *返回值*

无

## + (id)popFromQueue:(NSString *)name
##### *描述*

从指定队列中输出一个值

##### *参数*

name        NSString        要取值的队列名称

##### *返回值*

如果队列不为空，则返回队列底部的值

## + (void)saveToStorage
##### *描述*

把默认缓存对象持久化，一般在应用退出时调用

##### *参数*

无

##### *返回值*

无

## + (void)loadFromStorage
##### *描述*

从持久化存储中读取缓存对象，一般应用启动时调用

##### *参数*

无

##### *返回值*

无

## - (id)initWithFiletoken:(NSString *)filetoken
##### *描述*

初始化一个新的Kache实例

##### *参数*

filetoken       NSString        用于区分持久化时的存储位置，相同的filetoken将被持久化为一个文件

##### *返回值*

一个新的Kache实例

##### *举例*

<pre>
Kache *kache = [[Kache alloc] initWithFiletoken:@"new_kache_instance"];
[kache setValue:@"KacheValueForInstance" forKey:@"cache_key" expiredAfter:3600];
NSString *cacheValue = [kache valueForKey:@"cache_key"]; // cacheValue: @"KacheValueForInstance"
</pre>

## - (void)newQueueWithName:(NSString *)name size:(NSInteger)size
##### *描述*

在该实例下建立一个新的缓存队列

##### *参数*

name        NSString        新建队列的名称
size        NSInteger       队列长度

##### *返回值*

无


## - (void)newPoolWithName:(NSString *)name size:(NSInteger)size
##### *描述*

在该实例下建立一个新的缓存池

##### *参数*

name        NSString        新建缓存池的名称
size        NSInteger       池的最大容量

##### *返回值*

无

## - (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration
##### *描述*

在该实例下设置一个普通的缓存值。

##### *参数*

value       id              要存入的缓存值
key         NSString        缓存键名
duration    NSInteger       过期时长

##### *返回值*

无

## - (void)setValue:(id)value inPool:(NSString *)name forKey:(NSString *)key expiredAfter:(NSInteger)duration
##### *描述*

在该实例下添加一个值到指定缓存池中。

注意：在添加之前，需要确认该池已经创建

##### *参数*

value       id              要存入的缓存值
name        NSString        要存入的池名称
key         NSString        缓存键名
duration    NSInteger       过期时长

##### *返回值*

无

## - (void)pushValue:(id)value toQueue:(NSString *)name
##### *描述*

在该实例下添加一个值到指定队列中。

注意：在添加之前，需要确认该队列已经创建

##### *参数*

value       id              要存入的缓存值
name        NSString        要存入的队列名称

##### *返回值*

无

## - (id)popFromQueue:(NSString *)name
##### *描述*

在该实例下从指定队列中输出一个值

##### *参数*

name        NSString        要取值的队列名称

##### *返回值*

如果队列不为空，则返回队列底部的值

## - (id)valueForKey:(NSString *)key
##### *描述*

在该实例下从缓存中取出某个值

##### *参数*

key         NSString        要取值的键名    

##### *返回值*

如果该键对应有值，则返回缓存值，否则返回空

## - (void)save
##### *描述*

把该实例缓存对象持久化，一般在应用退出时调用

##### *参数*

无

##### *返回值*

无

## - (void)load
##### *描述*

从持久化存储中读取缓存对象，通过该实例的filetoken区分，一般应用启动时调用

##### *参数*

无

##### *返回值*

无

