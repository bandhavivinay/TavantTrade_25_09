//
//  TTAccountLienCell.h
//  TavantTrade
//
//  Created by TAVANT on 2/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TTAccountsViewController.h"

@class TTAccountLienCell;
// delegate method to open webview on account screen

@protocol TTAccountButtonDelegate
-(void)openWebViewFromUrl:(NSString *)url;
@end

@interface TTAccountLienCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueInRupee;
@property (weak, nonatomic) IBOutlet UILabel *rupeeLabel;
@property (weak, nonatomic) IBOutlet UIButton *fundLienButton;
@property (weak, nonatomic) IBOutlet UIButton *dpLienButton;
@property(nonatomic,weak) id <TTAccountButtonDelegate> delegate;
-(IBAction)showfundLien:(id)sender;
-(IBAction)showdpLien:(id)sender;
@end
