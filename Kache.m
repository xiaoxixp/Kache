//
//  Kache.m
//  Koubei
//
//  Created by jiajun on 1/16/11.
//  Copyright 2011 jiajun.org. All rights reserved.
//

#import "Kache.h"

@implementation Kache

@synthesize poolSize;
@synthesize availableSeconds;
@synthesize holder;
@synthesize filetoken = _filetoken;

- (id)initWithDefaultAvailableSeconds:(NSInteger)aSeconds andPoolSize:(NSInteger)pool {
	if (self = [self init]) {
		self.availableSeconds = aSeconds;
		self.poolSize = pool;
	}
	
	return self;
}

- (id)init {
	if (self = [super init]) {
		holder = [[KCHHolder alloc] init];

		// if you set more than poolSize object to
		// pool, the oldest one will be removed.
		poolSize = 200;

		// a day by default.
		availableSeconds = 86400;

		return self;
	}
	return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key {
	[self setValue:value forKey:key withAvailableSeconds:availableSeconds];
}

- (void)setValue:(id)value forKey:(NSString *)key withAvailableSeconds:(NSInteger)aSeconds {
	[holder setValue:[KCHObject data:value withAvailableSeconds:aSeconds] forKey:key];
}

- (void)setPoolValue:(id)value forKey:(NSString *)key {
	[self setPoolValue:value forKey:key withAvailableSeconds:availableSeconds];
}

- (void)setPoolValue:(id)value forKey:(NSString *)key withAvailableSeconds:(NSInteger)aSeconds {
	[holder.keyPool removeObject:key];
	[holder.keyPool addObject:key];
	[self setValue:value forKey:key withAvailableSeconds:aSeconds];
	if (poolSize < [holder.keyPool count]) {
		[holder removeForKey:[holder.keyPool objectAtIndex:0]];
	}
}

- (void)cleanPool {

    NSArray *kp = [holder.keyPool copy];
	for (NSString *key in kp) {
		[holder removeForKey:key];
	}
	[holder.keyPool removeAllObjects];
}

- (id)objectForKey:(NSString *)key {
	return [[holder objectForKey:key] objectForKey:DATAOBJ];
}

- (void)removeForKey:(NSString *)key {
	[holder removeForKey:key];
}

- (void)reset {
	[[holder objectPool] removeAllObjects];
	[[holder keyPool] removeAllObjects];
	[[holder keyList] removeAllObjects];
}

- (void)save {
	NSDictionary *kacheDict = [[NSDictionary alloc] initWithObjectsAndKeys:
							   [[holder serialize] objectPool], @"object_pool",
							   [holder keyPool], @"key_pool",
							   [holder keyList], @"key_list",
							   nil];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *libDirectory = [paths objectAtIndex:0];
	NSString *path = @"Caches/KACHE_STORAGE_FILE_NEWVERSION";
	if (_filetoken) {
		path = [path stringByAppendingString:_filetoken];
	}
	NSString *filePath = [libDirectory stringByAppendingPathComponent:path];
	
	NSData *d = [NSKeyedArchiver archivedDataWithRootObject:kacheDict];
	[d writeToFile:filePath atomically:YES];
}

- (void)load {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *libDirectory = [paths objectAtIndex:0];
	
	NSString *path = @"Caches/KACHE_STORAGE_FILE_NEWVERSION";
	if (_filetoken) {
		path = [path stringByAppendingString:_filetoken];
	}
	NSString *filePath = [libDirectory stringByAppendingPathComponent:path];

	NSData *d = [NSData dataWithContentsOfFile:filePath];
	NSDictionary *kacheDict = [NSDictionary dictionaryWithDictionary:
							   [NSKeyedUnarchiver unarchiveObjectWithData:d]];

	[self reset];
	if (kacheDict && 0 < [kacheDict count]) {
		[holder setObjectPool:[[kacheDict objectForKey:@"object_pool"] mutableCopy]];
		[holder unserialize];
		[holder setKeyPool:[[kacheDict objectForKey:@"key_pool"] mutableCopy]];
		[holder setKeyList:[[kacheDict objectForKey:@"key_pool"] mutableCopy]];
	}
}

//------------------static method -------------------//

+ (Kache *)handler {
	static Kache *obj = nil;
	
	if (nil == obj) {
		obj = [[Kache alloc] init];
	}

	return obj;
}

+ (void)setValue:(id)value forKey:(NSString *)key {
	[[Kache handler] setValue:value forKey:key];
}

+ (void)setValue:(id)value forKey:(NSString *)key withAvailableSeconds:(NSInteger)aSeconds {
	[[Kache handler] setValue:value forKey:key withAvailableSeconds:aSeconds];
}

+ (void)setPoolValue:(id)value forKey:(NSString *)key {
	[[Kache handler] setPoolValue:value forKey:key];
}

+ (void)setPoolValue:(id)value forKey:(NSString *)key withAvailableSeconds:(NSInteger)aSeconds {
	[[Kache handler] setPoolValue:value forKey:key withAvailableSeconds:aSeconds];
}

+ (id)objectForKey:(NSString *)key {
	return [[Kache handler] objectForKey:key];
}

+ (void)removeForKey:(NSString *)key {
	[[Kache handler] removeForKey:key];
}

+ (void)cleanPool {
	[[Kache handler] cleanPool];
}

+ (void)reset {
	[[Kache handler] reset];
}

+ (void)saveToStorage {
	[[Kache handler] save];
}

+ (void)loadFromStorage {
	[[Kache handler] load];
}
				 
@end
