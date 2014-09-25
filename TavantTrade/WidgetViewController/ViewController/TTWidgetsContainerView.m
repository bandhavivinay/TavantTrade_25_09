//
//  TTWidgetsContainerView.m
//  ContainerView
//
//  Created by Gautham S Shetty on 06/01/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTWidgetsContainerView.h"

#define kButtonBaseTag 10000
#define kItemPaddingHorz 10
#define kItemPaddingVert 10
#define kMaxWidth 200
#define kSpacer 100

@implementation TTWidgetsContainerView
@synthesize datasource = _datasource;
@synthesize pageControl = _pageControl;
@synthesize containerScrollView = _containerScrollView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialize];
    }
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

-(void)initialize
{
    _containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height - kItemPaddingHorz)];
    _containerScrollView.delegate = self;
    _containerScrollView.bounces = YES;
    _containerScrollView.scrollEnabled = YES;
    _containerScrollView.alwaysBounceHorizontal = YES;
    _containerScrollView.alwaysBounceVertical = NO;
    _containerScrollView.showsHorizontalScrollIndicator = NO;
    _containerScrollView.showsVerticalScrollIndicator = NO;
    _containerScrollView.pagingEnabled = YES;
    [self addSubview:_containerScrollView];
    _pageControl = [[UIPageControl alloc] init];
    [_pageControl addTarget:self action:@selector(changePageAction:) forControlEvents:UIControlEventTouchUpInside];
    _pageControl.frame = CGRectMake(kItemPaddingVert, self.bounds.size.height - kItemPaddingHorz, self.bounds.size.width - 2* kItemPaddingVert, kItemPaddingHorz);
    [self addSubview:_pageControl];
    
}

- (void) changePageAction : (id) sender
{
    NSUInteger currentPage = _pageControl.currentPage;
    CGFloat width = self.bounds.size.width;
    CGRect currentVisibleRect = CGRectMake(width * currentPage, 0.0, width, self.bounds.size.height);
    [_containerScrollView scrollRectToVisible:currentVisibleRect animated:YES];
}

-(void)removeAllSubviews
{
    for (UIView *view  in _containerScrollView.subviews)
    {
        [view removeFromSuperview];
    }
}

-(void) reloadData
{
    int itemCount = [_datasource numberOfItemsInWidgetContainer:self];
    
    _pageControl.numberOfPages = (itemCount % 3) ? itemCount/3 + 1 : itemCount/3;
    
    [self removeAllSubviews];
    
    int widgetWidth = (self.frame.size.width - 4*kItemPaddingVert)/3;
    
    for (int i = 0; i < itemCount; i++)
    {
        UIView *itemView = [_datasource widgetsContainer:self viewForWidgetsAtIndex:i];
        
        itemView.frame = CGRectMake(i * (widgetWidth + kItemPaddingVert) + (i/3 + 1) * kItemPaddingVert, kItemPaddingHorz/2, widgetWidth , self.frame.size.height -   2* kItemPaddingHorz);
        [_containerScrollView addSubview:itemView];
    }
    
    int multiplier = (itemCount % 3 ) == 0? itemCount : (itemCount+ (3 -itemCount%3));
    
    _containerScrollView.contentSize = CGSizeMake((widgetWidth + kItemPaddingVert) * multiplier + (multiplier/3 + 1) * kItemPaddingVert , self.frame.size.height - kItemPaddingHorz);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
{
    //if(!decelerate)
    {
        NSUInteger page =  round(_containerScrollView.contentOffset.x / _containerScrollView.frame.size.width);
        [_pageControl setCurrentPage:page];
    }
}

@end
