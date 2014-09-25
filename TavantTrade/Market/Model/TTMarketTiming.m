//
//  TTMarketTiming.m
//  TavantTrade
//
//  Created by TAVANT on 2/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTMarketTiming.h"

@implementation TTMarketTiming

@synthesize topic,subKey,marketStatus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)updateMarketTiming:(NSArray *)streamingData{
    self.subKey=EMPTY_IF_NIL([streamingData objectAtIndex:6]);
    self.marketStatus=EMPTY_IF_NIL([streamingData objectAtIndex:7]);
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
