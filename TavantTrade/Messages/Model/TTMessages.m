//
//  TTMessages.m
//  TavantTrade
//
//  Created by TAVANT on 2/27/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTMessages.h"

@implementation TTMessages

-(id)initWithMessagesDictionary:(NSDictionary *)inDictionary{
    self = [super init];
    if(self){
        
        self.messageLine=EMPTY_IF_NIL([inDictionary objectForKey:@"message"]);
       // self.date=EMPTY_IF_NIL([inDictionary objectForKey:@"createdTime"]);
        [self dateTimeConverter:inDictionary];
        
        return self;
    }
    return nil;
}
-(void) dateTimeConverter:(NSDictionary *)inDictionary{
    double actDate =[[inDictionary objectForKey:@"createdTime"] floatValue];
    NSDate *date1= [NSDate dateWithTimeIntervalSince1970:actDate/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM/dd/yy";
    self.date = [dateFormatter stringFromDate: date1];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm";
    self.time= [timeFormatter stringFromDate: date1];

}

@end
