//
//  MKTickerView.m
//  MKTickerViewDemo
//  Created by Mugunth on 09/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above
//  Read my blog post at http://mk.sg/8i on how to use this code

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website
//	2) or crediting me inside the app's credits page
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	While I'm ok with modifications to this source code,
//	if you are re-publishing after editing, please retain the above copyright notices

#import "MKTickerView.h"
#import "SBITradingUtility.h"
#define kButtonBaseTag 10000
#define kLabelPadding 10
#define kItemPadding 0
#define kMaxWidth 200
#define kSpacer 100
#define kPixelsPerSecond 100.0f

@implementation MKTickerItemView
@synthesize data = _data;

static UIFont *titleFont = nil;
static UIFont *valueFont = nil;

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        self.frame = CGRectMake(0, 0, 10, 26);
        self.opaque = YES;
        self.contentMode = UIViewContentModeCenter;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}
+(void) initialize
{
    titleFont = [UIFont boldSystemFontOfSize:15];
    valueFont = [UIFont systemFontOfSize:15];
}


+(void) dealloc
{
    [super dealloc];
}

-(CGFloat) titleWidth
{
    CGRect paragraphRect =
    [[self getAttributedTitle] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            context:nil];
    return  paragraphRect.size.width;
}
//
-(CGFloat) valueWidth
{
    CGRect paragraphRect =
    [[self getAttributedSubString] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height)
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            context:nil];
    return  paragraphRect.size.width;
}

-(CGFloat) width
{
    CGFloat titleWidth = [self titleWidth];
    CGFloat subTitleWidth = [self valueWidth];
    
    
    return  180.0; //(titleWidth >= subTitleWidth) ? titleWidth  + kLabelPadding : subTitleWidth +kLabelPadding;
}

- (void) setData:(TTDiffusionData *)data
{
    _data = data;
    [self.superview layoutSubviews];
}

-(NSAttributedString *) getAttributedTitle
{
    NSString *symbolName = _data.symbolData.tradeSymbolName;
    NSLog(@"Symbol Name Crash %@",symbolName);
    
    NSString *companyName = [NSString stringWithFormat:@" (%@)",_data.symbolData.companyName];
    
    NSMutableAttributedString *atrbtSymbolName=[[NSMutableAttributedString alloc] initWithString:symbolName];
    NSInteger _stringLength=[symbolName length];
    UIColor *color=[UIColor whiteColor];
    UIFont *font=SEMI_BOLD_FONT_SIZE(12.0);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSRange range = NSMakeRange(0, _stringLength);
    
    [atrbtSymbolName addAttribute:NSFontAttributeName value:font range:range];
    [atrbtSymbolName addAttribute:NSForegroundColorAttributeName value:color range:range];
    [atrbtSymbolName addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    
    NSMutableAttributedString *atrbtConmpanyName=[[NSMutableAttributedString alloc] initWithString:companyName];
    _stringLength=[companyName length];
    color=[UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1.0];
    font=SEMI_BOLD_FONT_SIZE(12.0);
    [atrbtConmpanyName addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [atrbtConmpanyName addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, _stringLength)];
    
   // [atrbtSymbolName appendAttributedString:atrbtConmpanyName];
    return atrbtSymbolName;
}


- (NSAttributedString *) getLTPValue
{
    float ltpValue = _data.lastSalePrice;
    NSLog(@"ltpValue Crash %f",ltpValue);
    NSString *ltpString = [NSString stringWithFormat:@"%.2f", ltpValue];
    NSInteger _stringLength = 0;
    UIColor *color=[UIColor whiteColor];
    UIFont *font=SEMI_BOLD_FONT_SIZE(12.0);

    NSMutableAttributedString *atrbtLTPString=[[NSMutableAttributedString alloc] initWithString:ltpString];
    _stringLength=[ltpString length];
    color=[UIColor whiteColor];
    font=SEMI_BOLD_FONT_SIZE(12.0);
    [atrbtLTPString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, _stringLength)];
    [atrbtLTPString  addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, _stringLength)];

    return atrbtLTPString;
}

- (NSAttributedString *) getAttributedSubString
{
    float change = _data.netPriceChange;
    UIColor *color=[UIColor whiteColor];
    UIFont *font=SEMI_BOLD_FONT_SIZE(12.0);
    NSInteger _stringLength = 0;
    float priceChange = _data.lastSalePrice - _data.closingPrice;
    float percentage = _data.closingPrice ? (fabsf(priceChange)/_data.closingPrice)*100 : 0.0;
    
    if([_data.netPriceChangeIndicator isEqualToString:@""])
        _data.netPriceChangeIndicator = GET_SIGN_INDICATOR(priceChange);
    
    NSString *changeString = [NSString stringWithFormat:@"%.02f(%@%.02f%%)",fabsf(priceChange),_data.netPriceChangeIndicator,percentage];
    
    
    [NSString stringWithFormat:@"%.2f", change];
    
    
    NSMutableAttributedString *atrbtChangeString=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",changeString]];
    NSLog(@"atrbtChangeString Crash %@",atrbtChangeString);
    _stringLength=[changeString length];
    
    if([_data.netPriceChangeIndicator isEqualToString:@"+"])
        color= SYMBOL_PROFIT_LABEL_COLOR;
    else
        color= SYMBOL_LOSS_LABEL_COLOR;
    
    font=SEMI_BOLD_FONT_SIZE(12.0);
    [atrbtChangeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(1, _stringLength)];
    [atrbtChangeString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(1, _stringLength)];
    

    return atrbtChangeString;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if(_data)
    {
        // Drawing the Title with Symbol Name and Company name.
        
        [[self getAttributedTitle] drawInRect:CGRectMake(8.0, 4.0, rect.size.width - 16.0, 15.0)];
       // Drawing LTP Value
        CGSize ltpStringSize = [[self getLTPValue] size];
        
        [[self getLTPValue] drawInRect:CGRectMake(8.0, 23.0, ltpStringSize.width , 14.0)];
        // Drawing Arrow to show Up or Down status
        
        float priceChange = _data.lastSalePrice - _data.closingPrice;
        
        if([_data.netPriceChangeIndicator isEqualToString:@""])
            _data.netPriceChangeIndicator = GET_SIGN_INDICATOR(priceChange);

        
        UIImage *image = nil;
        if([_data.netPriceChangeIndicator isEqualToString:@"+"])
        {
            image = [UIImage imageNamed:@"up_green_arrow_small"];
        }
        else
        {
            image = [UIImage imageNamed:@"down_red_arrow_small"];
        }
        [image drawInRect: CGRectMake(ltpStringSize.width + 16.0 , 28.0, image.size.width, image.size.height)];
        
        // Drawing the Title with Symbol Name and Company name.

        [[self getAttributedSubString] drawInRect:CGRectMake(ltpStringSize.width + image.size.width + 16 , 23.0, rect.size.width - ltpStringSize.width, 14.0)];
        
        [[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:92.0/255.0 alpha:1.0] set];
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(rect.size.width, 8.0)];
        [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height-8.0)];
        [path closePath];
        [path stroke];
    }
    
}



@end

@implementation MKTickerView

@synthesize dataSource;

-(void) awakeFromNib
{
    self.bounces = YES;
    self.scrollEnabled = YES;
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:53.0/255.0 blue:59.0/255.0 alpha:1.0];
}

-(void)removeAllSubviews
{
    for (UIView *view  in self.subviews)
    {
        [view removeFromSuperview];
    }
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGRect frame = self.frame;
    
    frame.origin.y = 0;
    frame.size.height = 1;
    
    [[UIColor colorWithRed:72.0/255.0 green:76.0/255.0 blue:85.0/255.0 alpha:1.0] set];
    UIRectFill(frame);
    
    
}
-(void) reloadData
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startAnimation) name:UIApplicationDidBecomeActiveNotification object:nil];

    
    [self removeAllSubviews];
    int itemCount = [dataSource numberOfItemsForTickerView:self];
    
    if(itemCount)
    {
        int xPos = 0;
        for(int i = 0 ; i < itemCount; i ++)
        {
            MKTickerItemView *tickerItemView = [[MKTickerItemView alloc] init];
            [tickerItemView setData:[dataSource tickerView:self dataForItemAtIndex:i]];
            tickerItemView.frame = CGRectMake(xPos, 0, [tickerItemView width], self.frame.size.height);
            xPos += ([tickerItemView width] + kItemPadding);
            tickerItemView.tag = i;
            [self addSubview:tickerItemView];
        }
        
        self.contentSize = CGSizeMake(xPos + self.frame.size.width + kSpacer, self.frame.size.height);
        self.contentOffset = CGPointMake(- self.frame.size.width/2, 0);

        xPos += kSpacer;
        
        CGFloat breakWidth = 0;
        for(int counter = 0 ; breakWidth < self.frame.size.width; counter ++)
        {
            int i = counter % itemCount;
            MKTickerItemView *tickerItemView = [[MKTickerItemView alloc] init];
            
            tickerItemView.data = [dataSource tickerView:self dataForItemAtIndex:i];
            
            
            tickerItemView.frame = CGRectMake(xPos, 0, [tickerItemView width], self.frame.size.height);
            xPos += ([tickerItemView width] + kItemPadding);
            breakWidth += ([tickerItemView width] + kItemPadding);
            [self addSubview:tickerItemView];
        }
        [self performSelectorOnMainThread:@selector(startAnimation) withObject:nil waitUntilDone:NO];
    }
}

-(MKTickerItemView *)tickerItemViewAtIndex:(NSUInteger )index
{
    MKTickerItemView *item = nil;
    for (item in self.subviews)
    {
        if (item.tag == index)
        {
            break;
        }
    }
    return item;
}

-(void) reloadItemAtIndex : (NSUInteger) index
{
    MKTickerItemView *tickerItemView = [self tickerItemViewAtIndex:index];
    tickerItemView.data = [dataSource tickerView:self dataForItemAtIndex:index];
    [tickerItemView setNeedsDisplay];
}

-(void) startAnimation
{
    NSTimeInterval animationDuration = self.contentSize.width/kPixelsPerSecond;
    [UIView animateWithDuration:animationDuration delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.contentOffset = CGPointMake(self.contentSize.width - self.frame.size.width, 0);
    }
                     completion:^(BOOL finished){
                         if(finished)
                         {
                             self.contentOffset = CGPointMake(0, 0);
                             [self performSelectorOnMainThread:@selector(startAnimation) withObject:nil waitUntilDone:NO];
                         }
                     }];
}

//-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
//{
//    if([animationID isEqualToString:@"Marquee-Animation"])
//    {
//        self.contentOffset = CGPointMake(0, 0);
//        [self performSelectorOnMainThread:@selector(startAnimation) withObject:nil waitUntilDone:NO];
//        
//    }
//}


@end
