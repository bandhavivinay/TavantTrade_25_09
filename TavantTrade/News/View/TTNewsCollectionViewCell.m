//
//  TTNewsCollectionViewCell.m
//  TavantTrade
//
//  Created by Bandhavi on 2/28/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTNewsCollectionViewCell.h"
#import "TTConstants.h"
#import "SBITradingUtility.h"

@implementation TTNewsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

-(void)configureCell{
    self.headingLabel.text = _dataSource.heading;
//    self.descriptionLabel.attributedText = [[NSAttributedString alloc] initWithData:[_dataSource.description dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    self.descriptionLabel.text = [self convertHTML:_dataSource.description];
    self.dateTimeLabel.text = _dataSource.date;
    
    //perform date formatting ...
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSDate *date  = [dateFormatter dateFromString:_dataSource.date];
    
    NSDateFormatter *finalDateFormatter = [[NSDateFormatter alloc] init];
    [finalDateFormatter setDateFormat:@"dd MMM yyyy,HH:mm"];
    
    self.dateTimeLabel.text = [finalDateFormatter stringFromDate:date];
    
}

-(void)layoutSubviews{
    self.headingLabel.font = REGULAR_FONT_SIZE(16.0);
    self.dateTimeLabel.font = REGULAR_FONT_SIZE(11.0);
    self.descriptionLabel.font = REGULAR_FONT_SIZE(12.0);
    self.backgroundColor = [SBITradingUtility getColorForComponentKey:@"LightBackground"];
}

@end
