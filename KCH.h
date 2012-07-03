//
//  KCH.h
//  Koubei
//
//  Created by jiajun on 1/16/11.
//  Copyright 2011 jiajun.org. All rights reserved.
//
// Basic Usage:
// 
//	#import "KCH.h"
// 
//	NSString *str = @"string to be cached";
// 
//	[Kache setValue:str forKey:@"cached_str"];
//	NSLog(@"%@", [Kache objectForKey:@"cached_str"]); // will output: string to be cached
// 
//	str = @"even i changed the value of variable";
//	NSLog(@"%@", [Kache objectForKey:@"cached_str"]); // still output: string to be cached
// 
//	[[Kache handler] setAvailableSeconds:5]; // default: 86400
//	[Kache setValue:str forKey:@"cached_str_for_5_seconds"];
//	/* or use */ [Kache setValue:str forKey:@"cached_str_for_5_seconds" withAvailableSeconds:5];
//	NSLog(@"%@", [Kache objectForKey:@"cached_str_for_5_seconds"]); // will output: string to be cached
// 
//	// 5 seconds later...
// 
//	NSLog(@"%@", [Kache objectForKey:@"cached_str_for_5_seconds"]); // will output: (null)
//
// Pool Useage:
//
//	[[Kache handler] setPoolSize:3]; // Default 100.
//
//	NSString *v1 = [[NSString alloc] initWithString:@"1"];
//	NSString *v2 = [[NSString alloc] initWithString:@"2"];
//	NSString *v3 = [[NSString alloc] initWithString:@"3"];
//	NSString *v4 = [[NSString alloc] initWithString:@"4"];
//	NSString *v5 = [[NSString alloc] initWithString:@"5"];
//
//	[Kache setPoolValue:v1 forKey:@"v1"];
//	[Kache setPoolValue:v2 forKey:@"v2"];
//	[Kache setPoolValue:v3 forKey:@"v3"];
//
//	NSLog(@"%@ - %@ - %@",
//		[Kache objectForKey:@"v1"],
//		[Kache objectForKey:@"v2"],
//		[Kache objectForKey:@"v3"]); // will output: 1 - 2 - 3
//
//	[Kache setPoolValue:v4 forKey:@"v4"];
//	[Kache setPoolValue:v5 forKey:@"v5"];
//
//	NSLog(@"%@ - %@ - %@ - %@ - %@",
//		[Kache objectForKey:@"v1"],
//		[Kache objectForKey:@"v2"],
//		[Kache objectForKey:@"v3"],
//		[Kache objectForKey:@"v4"],
//		[Kache objectForKey:@"v5"]); // will output: (null) - (null) - 3 - 4 - 5
//
//	[Kache reset];
//
//	[Kache setPoolValue:v1 forKey:@"v1"];
//	[Kache setPoolValue:v2 forKey:@"v2" withAvailableSeconds:5];
//	[Kache setPoolValue:v3 forKey:@"v3" withAvailableSeconds:5];
//
//	NSLog(@"%@ - %@ - %@",
//		[Kache objectForKey:@"v1"],
//		[Kache objectForKey:@"v2"],
//		[Kache objectForKey:@"v3"]); // will output: 1 - 2 - 3
//
//	// 5 seconds later...
//
//	[Kache setPoolValue:v4 forKey:@"v4"];
//	[Kache setPoolValue:v5 forKey:@"v5"];
//
//	NSLog(@"%@ - %@ - %@ - %@ - %@",
//		[Kache objectForKey:@"v1"],
//		[Kache objectForKey:@"v2"],
//		[Kache objectForKey:@"v3"],
//		[Kache objectForKey:@"v4"],
//		[Kache objectForKey:@"v5"]); // will output: 1 - (null) - (null) - 4 - 5
//

#import "Kache.h"
