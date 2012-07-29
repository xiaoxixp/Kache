//
//  Kache.m
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define KACHE_DEFAULT_QUEUE_NAME            @"kache_default_queue_name_QWEDFVHUIOPPLMUYTRDX:"
#define KACHE_DEFAULT_POOL_NAME             @"kache_default_pool_name_LKJHGFDWQSFASRTYUIOP:"

#import "Kache.h"

#import "KQueue.h"
#import "KPool.h"
#import "KHolder.h"

#import "KConfig.h"

@interface Kache ()

@property (strong, nonatomic) NSMutableDictionary           *queues;
@property (strong, nonatomic) NSMutableDictionary           *pools;
@property (strong, nonatomic) KHolder                       *holder;

@end

@implementation Kache

@synthesize queues      = _queues;
@synthesize pools       = _pools;
@synthesize holder      = _holder;

- (id)init
{
    self = [super init];
    if (self) {
        self.queues = [[NSMutableDictionary alloc] init];
        self.pools = [[NSMutableDictionary alloc] init];
        
        self.holder = [[KHolder alloc] init];
        
        [self newPoolWithName:nil size:0];
        [self newQueueWithName:nil size:0];
        
        return self;
    }
    
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration
{
    [self.holder setValue:value forKey:key expiredAfter:duration];
}

- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration inPool:(NSString *)name
{
    if (nil == name || 0 >= [name length]) {
        name = KACHE_DEFAULT_POOL_NAME;
    }
    if ([[self.pools allKeys] containsObject:name]) {
        KPool *pool = [self.pools objectForKey:name];
        [pool setValue:value forKey:key expiredAfter:duration];
    }
}

- (void)pushValue:(id)value toQueue:(NSString *)name
{
    if (nil == name || 0 >= [name length]) {
        name = KACHE_DEFAULT_QUEUE_NAME;
    }
    if ([[self.queues allKeys] containsObject:name]) {
        KQueue *queue = [self.queues objectForKey:name];
        [queue push:value];
    }
}

- (id)popFromQueue:(NSString *)name
{
    if (nil == name || 0 >= [name length]) {
        name = KACHE_DEFAULT_QUEUE_NAME;
    }
    if ([[self.queues allKeys] containsObject:name]) {
        KQueue *queue = [self.queues objectForKey:name];
        return [queue pop];
    }
    
    return nil;
}

- (id)valueForKey:(NSString *)key
{
    return [self.holder valueForKey:key];
}

- (void)newQueueWithName:(NSString *)name size:(NSInteger)size
{
    if (nil == name || 0 >= [name length]) {
        name = KACHE_DEFAULT_QUEUE_NAME;
    }
    if (! [[self.queues allKeys] containsObject:name]) {
        KQueue *queue = [[KQueue alloc] initWithHolder:self.holder];
        if (0 < size) {
            queue.size = size;
        }
        queue.name = name;
        [self.queues setValue:queue
                       forKey:name];
#if KACHE_DEBUG
        NSLog(@"Create a new Queue.");
#endif
    }
}

- (void)newPoolWithName:(NSString *)name size:(NSInteger)size;
{
    if (nil == name || 0 >= [name length]) {
        name = KACHE_DEFAULT_POOL_NAME;
    }
    if (! [[self.pools allKeys] containsObject:name]) {
        KPool *pool = [[KPool alloc] initWithHolder:self.holder];
        if (0 < size) {
            pool.size = size;
        }

        pool.name = name;
        [self.pools setValue:pool
                      forKey:name];
#if KACHE_DEBUG
        NSLog(@"Create a new Pool.");
#endif
    }
}

@end
