//
//  TTHeatMapSymbolView.m
//  TavantTrade
//
//  Created by Bandhavi on 5/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTHeatMapSymbolView.h"
#import "TTHeatMapColorSelector.h"

@implementation TTHeatMapSymbolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews{
    UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , self.frame.size.width , self.frame.size.height )];
    symbolLabel.textAlignment = NSTextAlignmentCenter;
    symbolLabel.textColor = [UIColor whiteColor];
    symbolLabel.font = [UIFont boldSystemFontOfSize:13.0];
    symbolLabel.text = self.currentMapData.symbolName;
    [self addSubview:symbolLabel];

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGRect rectangle = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    CGContextSetFillColor(context, CGColorGetComponents([[TTHeatMapColorSelector returnColorForPercentageChange:[self.currentMapData.percentageChange floatValue]] CGColor]));

    if(_isSelected){
        CGContextSetLineWidth(context, 3.0);
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    }
    else{
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
//        CGContextSetStrokeColor(context, CGColorGetComponents([[UIColor blackColor] CGColor]));
    }


    CGContextFillRect(context, rectangle);
    CGContextStrokeRect(context, rectangle);

}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"touchesCancelled");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.heatSymbolViewDelegate didClickHeatSymbolView:self];
}


@end
