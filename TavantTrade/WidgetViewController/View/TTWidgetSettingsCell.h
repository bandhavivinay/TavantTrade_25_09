//
//  TTWidgetSettingsCell.h
//  TavantTrade
//
//  Created by Gautham S Shetty on 04/03/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTWidgetSettingsCellDelegate;

@interface TTWidgetSettingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *icon;

@property (nonatomic, assign) NSObject <TTWidgetSettingsCellDelegate> *delegate;
@end


@protocol TTWidgetSettingsCellDelegate <NSObject>

- (void) widgetSettingsCellDidSelect:(TTWidgetSettingsCell *)inCell;

@end