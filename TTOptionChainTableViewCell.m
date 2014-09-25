//
//  TTOptionChainTableViewCell.m
//  TavantTrade
//
//  Created by Bandhavi on 3/5/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTOptionChainTableViewCell.h"


@implementation TTOptionChainTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)layoutSubviews{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(callLongPress:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)updateCellWithCallOption:(TTCallOption *)inCallOption andPutOption:(TTPutOption *)inPutOption{
    
    //update the calls option ...
    _callAskLabel.text = [NSString stringWithFormat:@"%.2f",inCallOption.callsAskValue];
    _callBidLabel.text = [NSString stringWithFormat:@"%.2f",inCallOption.callsBidValue];
    _callLTPLabel.text = [NSString stringWithFormat:@"%.2f",inCallOption.callsLTP];
    _callOILabel.text = [NSString stringWithFormat:@"%.2f",inCallOption.callsOI];
    _callVolumeLabel.text = [NSString stringWithFormat:@"%.2f",inCallOption.callsVolume];
    
    //update the puts option ...
    _putAskLabel.text = [NSString stringWithFormat:@"%.2f",inPutOption.putsAskValue];
    _putBidLabel.text = [NSString stringWithFormat:@"%.2f",inPutOption.putsBidValue];
    _putLTPLabel.text = [NSString stringWithFormat:@"%.2f",inPutOption.putsLTP];
    _putOILabel.text = [NSString stringWithFormat:@"%.2f",inPutOption.putsOI];
    _putVolumeLabel.text = [NSString stringWithFormat:@"%.2f",inPutOption.putsVolume];
    
}

- (void)callLongPress:(UILongPressGestureRecognizer*)gesture {
    if(gesture.state == UIGestureRecognizerStateEnded){
        CGPoint touchPoint = [[gesture valueForKey:@"_startPointScreen"] CGPointValue];
        NSLog(@"Touch point is %f ..... %f",touchPoint.x,touchPoint.y);
        if(touchPoint.y >= 570)
            [_seriesSelectedDelegate setSelectedSeries:@"CE" forCell:self];
        else if (touchPoint.y <= 452)
            [_seriesSelectedDelegate setSelectedSeries:@"PE" forCell:self];
        else
            //strike price selected...
            NSLog(@"No action");
    }
}


@end
