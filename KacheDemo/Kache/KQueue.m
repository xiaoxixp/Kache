//
//  KQueue.m
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KQueue.h"

#import "KHolder.h"
#import "KUtil.h"
#import "KConfig.h"
#import "KObject.h"

@interface KQueue ()

@property KHolder               *holder;
@property NSMutableArray        *queue;
@property NSInteger             offset;

- (void)cleanExpiredObjects;

@end

@implementation KQueue

@synthesize size                = _size;
@synthesize name                = _name;
@synthesize holder              = _holder;
@synthesize queue               = _queue;
@synthesize offset              = _offset;

#pragma mark - init

- (KQueue *)initWithHolder:(KHolder *)aHolder
{
    self = [super init];
    
    if (self) {
        self.holder = aHolder;
        self.queue  = [[NSMutableArray alloc] init];
        self.size   = KACHE_DEFAULT_QUEUE_SIZE;
        self.offset = 0;
        
        return self;
    }
    
    return nil;
}

#pragma mark - private

- (void)cleanExpiredObjects
{
    if (self.queue && 0 < [self.queue count]) {
        for (int i = 0; i < [self.queue count] - 1; i ++) {
            NSString *tmpKey = [self.queue objectAtIndex:i];
            KObject *leftObject = [self.holder objectForKey:tmpKey];
            if ([leftObject expiredTimestamp] < [KUtil nowTimestamp]) {
                [self.queue removeObject:tmpKey];
            }
            else {
                break;
            }
        }
    }
}

#pragma mark - public

- (void)push:(id)data
{
    NSString *key = [NSString stringWithFormat:@"QUEUE_%@_%d", self.name, self.offset];
    self.offset ++;
    [self.holder setValue:data forKey:key expiredAfter:0];

    @synchronized(self)
    {
        [self cleanExpiredObjects];
        
        if (self.size <= [self.queue count]) {
            [self.holder removeObjectForKey:[self.queue objectAtIndex:0]];
            [self.queue removeObjectAtIndex:0];
        }

        [self.queue addObject:key];
    }

#if KACHE_DEBUG
    NSLog(@"Queue List: %@", self.queue);
#endif

}

- (id)pop
{
    if (0 < [self.queue count]) {
        NSString *key = [self.queue objectAtIndex:0];
        [self.queue removeObjectAtIndex:0];
        KObject *object = [self.holder objectForKey:key];
        [self.holder removeObjectForKey:key];

#if KACHE_DEBUG
        NSLog(@"%@ was poped.", key);
        NSLog(@"Queue List: %@", self.queue);
#endif
        return [object value];
    }
    
    return nil;
}

@end
