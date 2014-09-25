//
//  TTMessages.h
//  TavantTrade
//
//  Created by TAVANT on 2/27/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMPTY_IF_NIL(__STRING) ((__STRING!=[NSNull null]) ? __STRING : @"")

@interface TTMessages : NSObject

@property(nonatomic,strong)NSString *messageLine;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *time;


-(id)initWithMessagesDictionary:(NSDictionary *)inDictionary;
-(void)dateTimeConverter:(NSDictionary *)inDictionary;
@end
