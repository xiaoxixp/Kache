//
//  KObject.m
//  KacheDemo
//
//  Created by jiajun on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define KCH_OBJ_DATA        @"data"
#define KCH_OBJ_LIFE        @"life"

#import "KObject.h"
#import "KUtil.h"
#import "KConfig.h"

@interface KObject ()

@end

@implementation KObject

@synthesize object              = _object;

#pragma mark - init

- (KObject *)initWithData:(id)aData andLifeDuration:(NSInteger)aDuration
{
    self = [super init];

    if (self) {
#if KACHE_DEBUG
        NSLog(@"KObject Created. Expired after %d second(s), at: %d",
              aDuration,
              [KUtil expiredTimestampForLife:aDuration]);
#endif
        aDuration = (0 >= aDuration) ? KACHE_DEFAULT_LIFE_DURATION : aDuration;

        self.object = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       aData, KCH_OBJ_DATA,
                       [NSString stringWithFormat:@"%d", [KUtil expiredTimestampForLife:aDuration]], KCH_OBJ_LIFE,
                       nil];

        return self;
    }
    
    return nil;
}

- (KObject *)initWithDictionary:(NSMutableDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.object = dict;
        return self;
    }
    
    return nil;
}

#pragma - public

- (id)value
{
#if KACHE_DEBUG
    NSLog(@"Data Object:%@", self.object);
#endif
    
    if ([[self.object allKeys] containsObject:KCH_OBJ_DATA]
        && [self.object objectForKey:KCH_OBJ_DATA]) {
        return [self.object objectForKey:KCH_OBJ_DATA];
    }

#if KACHE_DEBUG
    NSLog(@"Bad Object.");
#endif

    return nil;
}

- (NSInteger)expiredTimestamp
{
    return [[self.object objectForKey:KCH_OBJ_LIFE] intValue];
}

- (void)updateLifeDuration:(NSInteger)aDuration
{
    aDuration = (0 >= aDuration) ? KACHE_DEFAULT_LIFE_DURATION : aDuration;

    [self.object setValue:[NSString stringWithFormat:@"%d", [KUtil expiredTimestampForLife:aDuration]]
                                          forKey:KCH_OBJ_LIFE];
}

- (BOOL)expired
{
    if ([KUtil nowTimestamp] < [[self.object objectForKey:KCH_OBJ_LIFE] intValue]) {
        return NO;
    }

#if KACHE_DEBUG
    NSLog(@"Object has been expired %d second(s) ago, at: %@.",
          [KUtil nowTimestamp] - [[self.object objectForKey:KCH_OBJ_LIFE] intValue],
          [self.object objectForKey:KCH_OBJ_LIFE]);
#endif

    return YES;
}

@end
