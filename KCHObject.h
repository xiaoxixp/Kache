//
//  KCHObject.h
//  Koubei
//
//  Created by jiajun on 1/16/11.
//  Copyright 2011 jiajun.org. All rights reserved.
//

#define DATAFIELD		@"data"
#define EXPIRETIME		@"expire_time"
#define DATAOBJ         @"data_object"
#define EXPIRE          @"expire_time"

@interface KCHObject : NSObject

+ (id)data:(id)data withAvailableSeconds:(NSInteger)aSeconds;

@end
