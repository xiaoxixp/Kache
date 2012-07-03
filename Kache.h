//
//  Kache.h
//
//  Created by jiajun on 1/16/11.
//  Copyright 2011 jiajun.org. All rights reserved.
//

#define KCH_KEY		@"__KACHE_LOCAL_STORAGE_KEY__"

#import "KCHHolder.h"
#import "KCHObject.h"

@interface Kache : NSObject {

	// size of cache pool, avalible when use pool.
	NSInteger poolSize;
	
	// default expire seconds, never expire is NOT allowed.
	NSInteger availableSeconds;
	
	KCHHolder *holder;
}

@property (nonatomic, strong) KCHHolder *holder;
@property (nonatomic, strong) NSString *filetoken;

- (id)initWithDefaultAvailableSeconds:(NSInteger)expire andPoolSize:(NSInteger)pool;

- (void)setValue:(id)value forKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key withAvailableSeconds:(NSInteger)aSeconds;

- (void)setPoolValue:(id)value forKey:(NSString *)key;
- (void)setPoolValue:(id)value forKey:(NSString *)key withAvailableSeconds:(NSInteger)aSeconds;

- (id)objectForKey:(NSString *)key;

- (void)removeForKey:(NSString *)key;

- (void)cleanPool;

// reset the cache in memory. should be called when receiving
// memory warning.
- (void)reset;

// save the memory cache to local storage.
- (void)save;

// load the local storage to memory, if there is something in
// local storage.
- (void)load;

@property (nonatomic, assign) NSInteger poolSize;
@property (nonatomic, assign) NSInteger availableSeconds;

//------------------static method -------------------//

+ (Kache *)handler;

+ (void)setValue:(id)value forKey:(NSString *)key;
+ (void)setValue:(id)value forKey:(NSString *)key withAvailableSeconds:(NSInteger)aSeconds;

+ (void)setPoolValue:(id)value forKey:(NSString *)key;
+ (void)setPoolValue:(id)value forKey:(NSString *)key withAvailableSeconds:(NSInteger)aSeconds;

+ (id)objectForKey:(NSString *)key;

+ (void)removeForKey:(NSString *)key;

+ (void)cleanPool;

// reset the cache in memory. should be called when receiving
// memory warning.
+ (void)reset;

// save the memory cache to local storage.
+ (void)saveToStorage;

// load the local storage to memory, if there is something in
// local storage.
+ (void)loadFromStorage;

@end
