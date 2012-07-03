//
//  KCHHolder.h
//  Koubei
//
//  Created by jiajun on 1/16/11.
//  Copyright 2011 jiajun.org. All rights reserved.
//

#import "KCHObject.h"

@interface KCHHolder : NSObject {

	NSMutableDictionary *objectPool;
	
	// key list, sorted by expire time desc
	NSMutableArray *keyList;
	
	NSMutableArray *keyPool;
}

- (void)setValue:(NSMutableDictionary *)value forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

- (void)cleanToIndex:(NSInteger)index;
- (void)removeForKey:(NSString *)key;

- (id)serialize;
- (id)unserialize;

@property (nonatomic, strong) NSMutableDictionary *objectPool;
@property (nonatomic, strong) NSMutableArray *keyList;
@property (nonatomic, strong) NSMutableArray *keyPool;

@end
