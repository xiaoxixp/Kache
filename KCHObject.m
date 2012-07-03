//
//  KCHObject.m
//  Koubei
//
//  Created by jiajun on 1/16/11.
//  Copyright 2011 jiajun.org. All rights reserved.
//

#import "KCHObject.h"

@implementation KCHObject

+ (NSMutableDictionary *)data:(id)data withAvailableSeconds:(NSInteger)aSeconds {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            data, DATAOBJ,
            [NSString stringWithFormat:@"%d", ([[NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]] intValue] + aSeconds)], EXPIRE,
            nil];
}

@end
