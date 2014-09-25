//
//  TTSymbolView.m
//  TavantTrade
//
//  Created by Bandhavi on 5/20/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//


#import "TTScatterMapSymbolView.h"
#import "TTHeatMapColorSelector.h"

//specifying an offset to draw the circle within the given rect ...
#define CIRCLE_CONSTANT_1 5
#define CIRCLE_CONSTANT_2 10

@implementation TTScatterMapSymbolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)layoutSubviews{
    
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CIRCLE_CONSTANT_1/2, CIRCLE_CONSTANT_1/2 , self.frame.size.width - CIRCLE_CONSTANT_1, self.frame.size.height - CIRCLE_CONSTANT_1)];
    imageView.image = [UIImage imageNamed:@"glossy1.png"];
    imageView.alpha = 0.7;
    [self addSubview:imageView];
    
    UILabel *symbolLabel = [[UILabel alloc] initWithFrame:CGRectMake(CIRCLE_CONSTANT_2/2, CIRCLE_CONSTANT_2/2 , self.frame.size.width - CIRCLE_CONSTANT_2, self.frame.size.height - CIRCLE_CONSTANT_2)];
    symbolLabel.textAlignment = NSTextAlignmentCenter;
    symbolLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    symbolLabel.textColor = [UIColor whiteColor];
    symbolLabel.font = [UIFont boldSystemFontOfSize:11.0];
    symbolLabel.text = self.mapData.symbolName;
    [self addSubview:symbolLabel];
    
    //give a border to the symbol view ...

}

-(UIColor *)returnMapViewColor{
    //setting background color logic ...
    
    float percentageChange = [self.mapData.percentageChange floatValue];
    float OIChange = [self.mapData.OIChange floatValue];
    
    if(percentageChange >= 0 &&  OIChange >= 0)
        return [UIColor greenColor];
    else if(percentageChange >= 0 && OIChange < 0)
        return [UIColor blueColor];
    else if(percentageChange < 0 &&  OIChange >= 0)
        return [UIColor redColor];
    else if(percentageChange < 0 && OIChange < 0)
        return [UIColor orangeColor];
    else
        return [UIColor whiteColor];
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    rect = CGRectInset(rect, CIRCLE_CONSTANT_1, CIRCLE_CONSTANT_1);
    CGContextAddEllipseInRect(ctx, rect);
    
    UIColor *currentScatterMapItemColor = [TTHeatMapColorSelector returnColorForPercentageChange:[self.mapData.percentageChange floatValue]];
    
    CGContextSetFillColor(ctx, CGColorGetComponents([currentScatterMapItemColor CGColor]));
    //    CGContextSetShadow(ctx, CGSizeMake(-3.0f, -3.0f), 2.0f);
    if(_isSelected){
        CGContextSetLineWidth(ctx, 3.0);
        CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    }
    else{
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetStrokeColor(ctx, CGColorGetComponents([currentScatterMapItemColor CGColor]));
    }
    
        
//        CGContextSetShadowWithColor(ctx, CGSizeMake(-3.0f, -3.0f),
//                                    2.0, [[UIColor whiteColor] CGColor]);
    
    
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextStrokeEllipseInRect(ctx, rect);
    //     UIGraphicsPopContext();
    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSaveGState(ctx);
    //    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 5), 10,
    //                                [UIColor whiteColor].CGColor);
    //    [super drawRect:rect];
    //    CGContextRestoreGState(ctx);
    
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
    [self.symbolViewDelegate didClickSymbolView:self];
}


@end
