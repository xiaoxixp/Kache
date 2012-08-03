Kache
=============
Kache is an iOS Cache packing unit.

Kache是为iOS App开发的一款缓存组件。

Installing/Configuring
======================

Copy the Kache directory to your project.

把Kache目录拷贝到你的工程下。

<pre>
#import "KCH.h"
</pre>

##### *KConfig.h*
<pre>
// If it is set as 1 it will print some debug info.
// 被设置为1，则会打印debug信息。
#define     KACHE_DEBUG                 0

#define     KACHE_DEFAULT_POOL_SIZE     20
#define     KACHE_DEFAULT_QUEUE_SIZE    10

// Default expired time, 10 Days.
// 缓存默认过期时间为10天。
#define     KACHE_DEFAULT_LIFE_DURATION 864000
</pre>

Static Methods
=========

## +(void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration
##### *Description*

Set a simple value.
设置一个普通的缓存值。

##### *Example*

<pre>
// Set a NSString: @"CacheValueForKeyTest" for key: @"cache_key", and it will be expired after an hour.
// 设置一个缓存，NSString类型的缓存，值为@"CacheValueForKeyTest"，键为@"cache_key"，1小时候过期。
[Kache setValue:@"CacheValueForKeyTest" forKey:@"cache_key" expiredAfter:3600];
</pre>

Instance Methods
================

