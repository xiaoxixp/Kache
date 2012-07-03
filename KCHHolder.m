//
//  KCHHolder.m
//  Koubei
//
//  Created by jiajun on 1/16/11.
//  Copyright 2011 jiajun.org. All rights reserved.
//

#import "KCHHolder.h"

@implementation KCHHolder

@synthesize objectPool;
@synthesize keyPool;
@synthesize keyList;

- (id)init {
	if (self = [super init]) {
		objectPool = [[NSMutableDictionary alloc] init];
		keyList = [[NSMutableArray alloc] init];
		keyPool = [[NSMutableArray alloc] init];

		return self;
	}
	return nil;
}

- (void)setValue:(NSMutableDictionary *)value forKey:(NSString *)key {
	[objectPool removeObjectForKey:key];
	[keyList removeObject:key];
    
    @synchronized(self) {
        NSInteger now = [[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] intValue];
        if ((0 < [keyList count])
            && (0 < [[[objectPool objectForKey:[keyList lastObject]] objectForKey:EXPIRETIME] intValue])
            && (now > [[[objectPool objectForKey:[keyList lastObject]]  objectForKey:EXPIRETIME] intValue])) {
            [keyList removeAllObjects];
            [keyPool removeAllObjects];
            [objectPool removeAllObjects];
        }
        else if ((0 < [keyList count]) && (now > [[[objectPool objectForKey:[keyList objectAtIndex:0]] objectForKey:EXPIRETIME] intValue])) {
            // dichotomizing search the expired Key
            NSInteger left = 1;
            NSInteger right = [keyList count];
            NSInteger expiredIndex = (0 == (right % 2)) ? right / 2 : (right / 2) + 1; 

            while ((0 < expiredIndex)
                   && ((now <= [[[objectPool objectForKey:[keyList objectAtIndex:(expiredIndex - 1)]] objectForKey:EXPIRETIME] intValue])
                       || (now > [[[objectPool objectForKey:[keyList objectAtIndex:(expiredIndex)]] objectForKey:EXPIRETIME] intValue]))) {
                       
                       if (now <= [[[objectPool objectForKey:[keyList objectAtIndex:(expiredIndex - 1)]] objectForKey:EXPIRETIME] intValue]) {
                           right = expiredIndex;
                       }
                       else if (now > [[[objectPool objectForKey:[keyList objectAtIndex:(expiredIndex)]] objectForKey:EXPIRETIME] intValue]) {
                           left = expiredIndex;
                       }
                       
                       expiredIndex = (0 == ((right - left + 1) % 2)) ? (right - left + 1) / 2 : ((right - left + 1) / 2) + 1;
                       expiredIndex += (left - 1);
            }
            // if expireIndex = 0, do NOT clean, else clean to expiredIndex (do NOT include expiredIndex)
            [self cleanToIndex:expiredIndex];
        }
        
        [objectPool setValue:value forKey:key];
        
        if (0 >= [keyList count]) {
            [keyList addObject:key];
        }
        else if ([[value objectForKey:EXPIRETIME] intValue] >= [[[objectPool objectForKey:[keyList lastObject]] objectForKey:EXPIRETIME] intValue]) {
            [keyList addObject:key];
        }
        else if ([[value objectForKey:EXPIRETIME] intValue] < [[[objectPool objectForKey:[keyList objectAtIndex:0]] objectForKey:EXPIRETIME] intValue]) {
            NSInteger insertIndex = 0;
            // move the keys backward
            [keyList addObject:[keyList objectAtIndex:([keyList count] - 1)]];
            for (int j = ([keyList count] - 2) ; j > insertIndex; j --) {
                [keyList replaceObjectAtIndex:j withObject:[keyList objectAtIndex:(j - 1)]];
            }
            // insert the key here.
            [keyList replaceObjectAtIndex:insertIndex withObject:key];
        }
        else {
            // dichotomy, find the index to insert new object
            NSInteger left = 1;
            NSInteger right = [keyList count];
            NSInteger insertIndex = (0 == ((right - left + 1) % 2)) ? (right - left + 1) / 2 : ((right - left + 1) / 2) + 1; 
            
            while ((0 < insertIndex) && (([[value objectForKey:EXPIRETIME] intValue] < [[[objectPool objectForKey:[keyList objectAtIndex:(insertIndex - 1)]] objectForKey:EXPIRETIME] intValue]) || ([[value objectForKey:EXPIRETIME] intValue] >= [[[objectPool objectForKey:[keyList objectAtIndex:(insertIndex)]] objectForKey:EXPIRETIME] intValue]))) {
                if ([[value objectForKey:EXPIRETIME] intValue]
                    < [[[objectPool objectForKey:[keyList objectAtIndex:(insertIndex - 1)]] objectForKey:EXPIRETIME] intValue]) {
                   right = insertIndex;
                }
                else if ([[value objectForKey:EXPIRETIME] intValue]
                         >= [[[objectPool objectForKey:[keyList objectAtIndex:(insertIndex)]] objectForKey:EXPIRETIME] intValue]) {
                   left = insertIndex;
                }

                insertIndex = (0 == ((right - left + 1) % 2)) ? (right - left + 1) / 2 : ((right - left + 1) / 2) + 1;
                insertIndex += (left - 1);
            }

            // move the keys backward
            [keyList addObject:[keyList objectAtIndex:([keyList count] - 1)]];
            for (int j = ([keyList count] - 2) ; j > insertIndex; j --) {
                [keyList replaceObjectAtIndex:j withObject:[keyList objectAtIndex:(j - 1)]];
            }
            // insert the key here.
            [keyList replaceObjectAtIndex:insertIndex withObject:key];
        }
    }
}

- (id)objectForKey:(NSString *)key {
	NSMutableDictionary* vo = [objectPool objectForKey:key];
	if ([[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] intValue] > [[vo objectForKey:EXPIRETIME] intValue]) {
		[self removeForKey:key];
		return nil;
	}
	else {
		return vo;
	}
}

- (void)cleanToIndex:(NSInteger)index {
	for (int i = 0; i < index; i ++) {
		[objectPool removeObjectForKey:[keyList objectAtIndex:0]];
		[keyPool removeObject:[keyList objectAtIndex:0]];
		[keyList removeObjectAtIndex:0];
	}
}

- (void)removeForKey:(NSString *)key {
    if (key == nil) {
        return;
    }
	[objectPool removeObjectForKey:key];
	[keyPool removeObject:key];
	[keyList removeObject:key];
}

- (id)serialize {
	return self;
}

- (id)unserialize {
	return self;
}

- (void)dealloc {
	[keyList removeAllObjects];
	[objectPool removeAllObjects];
	[keyPool removeAllObjects];
}

@end
