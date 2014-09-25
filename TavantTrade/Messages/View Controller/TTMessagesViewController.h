//
//  TTMessagesViewController.h
//  TavantTrade
//
//  Created by TAVANT on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTMessagesViewController;

@protocol TTMessagesDelegate
-(void)MessagesViewControllerShouldPresentinEnlargedView:(UIViewController *)inController;
@end

@interface TTMessagesViewController : UIViewController

@property(nonatomic,weak)IBOutlet UIView *widgetView;
@property(nonatomic,assign) id<TTMessagesDelegate> messagesViewDelagate;
@property (weak, nonatomic) IBOutlet UIButton *enlargedViewButton;
- (IBAction)showEnlargedView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *messageWidgetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)dimsissEnlargedView:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;
@property(nonatomic,assign)BOOL isEnlargedView;
@property (weak, nonatomic) IBOutlet UITableView *widgetTableView;

//-(IBAction)showEnlargedView:(id)sender;
//@property (weak, nonatomic) IBOutlet UILabel *sectionHederLabel;
//@property (weak, nonatomic) IBOutlet UILabel *widgetSectionHeaderLabel;
//@property (weak, nonatomic) IBOutlet UIView *WidgetSectionHeader;
//@property (weak, nonatomic) IBOutlet UIView *sectionHeader;
@property (strong, nonatomic)  UILabel *sectionHederLabel;
@property (strong, nonatomic)  UILabel *widgetSectionHeaderLabel;
@property (strong, nonatomic)  UIView *WidgetSectionHeader;
@property (strong, nonatomic)  UIView *sectionHeader;
@end
