//
//  NSNull_Json.m
//  TavantTrade
//
//  Created by Gautham Shetty on 4/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "NSNull_Json.h"

@implementation NSNull (JSON)

- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (CGFloat)floatValue { return 0; };

- (int)intValue { return 0; };

- (NSString *)description { return @"0(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }

- (BOOL) isEqualToString:(NSString *)inString { return NO;}

@end