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

