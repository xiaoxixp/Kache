//
//  Kache.h
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KQueue;
@class KPool;
@class KHolder;

@interface Kache : NSObject
{
    NSMutableDictionary         *queues;
    NSMutableDictionary         *pools;
    
    KHolder                     *holder;
}

- (void)newQueueWithName:(NSString *)name size:(NSInteger)size;
- (void)newPoolWithName:(NSString *)name size:(NSInteger)size;

- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration;
- (void)setValue:(id)value forKey:(NSString *)key expiredAfter:(NSInteger)duration inPool:(NSString *)name;
- (void)pushValue:(id)value toQueue:(NSString *)name;
- (id)popFromQueue:(NSString *)name;
- (id)valueForKey:(NSString *)key;

@end
