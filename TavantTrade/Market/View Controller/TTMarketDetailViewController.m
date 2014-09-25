//
//  TTMarketDetailViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 1/24/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTMarketDetailViewController.h"
#import "TTMarketDetailTableViewCell.h"
#import "TTCompanyData.h"
#import "TTConstants.h"

@interface TTMarketDetailViewController ()
@property(nonatomic,strong)NSMutableArray *companyArray;
@property(nonatomic,weak)IBOutlet UITableView *marketDetailTableView;
@property(nonatomic,weak)IBOutlet UILabel *volumeLabel;
@property(nonatomic,weak)IBOutlet UIButton *backButton;
@property(nonatomic,weak)IBOutlet UILabel *marketDetailsLabel;
@property(nonatomic,weak)IBOutlet UILabel *topHeadingLabel;
@end

@implementation TTMarketDetailViewController

@synthesize companyArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)populateCompanyArray:(NSMutableArray *)inCompanyArray{

    if([inCompanyArray count] == 0){
        inCompanyArray = [[NSMutableArray alloc] init];
        //lets load the dummy data...
        TTCompanyData *companydata1 = [[TTCompanyData alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"Infosys",@"companyName",@19.86,@"percentageChange",@1234.98,@"volume", nil]];
        TTCompanyData *companydata2 = [[TTCompanyData alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"TCS",@"companyName",@25.437,@"percentageChange",@1234.98,@"volume", nil]];
        TTCompanyData *companydata3 = [[TTCompanyData alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"ACC Limited",@"companyName",@5.87,@"percentageChange",@1234.98,@"volume", nil]];
        TTCompanyData *companydata4 = [[TTCompanyData alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"INDUS Bank",@"companyName",@10.17,@"percentageChange",@1234.98,@"volume", nil]];
        TTCompanyData *companydata5 = [[TTCompanyData alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"BAJAJ-AUTO",@"companyName",@15.89,@"percentageChange",@1234.98,@"volume", nil]];
        
        [inCompanyArray addObject:companydata1];
        [inCompanyArray addObject:companydata2];
        [inCompanyArray addObject:companydata3];
        [inCompanyArray addObject:companydata4];
        [inCompanyArray addObject:companydata5];
        [inCompanyArray addObject:companydata1];
        [inCompanyArray addObject:companydata2];
        [inCompanyArray addObject:companydata3];
        [inCompanyArray addObject:companydata4];
        [inCompanyArray addObject:companydata5];
        
    }
    companyArray = [[NSMutableArray alloc] initWithArray:inCompanyArray];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.isVolumeData == YES){
        self.volumeLabel.text = NSLocalizedStringFromTable(@"Volume", @"Localizable", @"Volume");
    }
    else{
        self.volumeLabel.text = NSLocalizedStringFromTable(@"Percentage_Change", @"Localizable", @"% Change");
    }
    
    //set the label title ...
    _companyTitleLabel.text = NSLocalizedStringFromTable(@"Company_Title", @"Localizable", @"Company");
    _ltpTitleLabel.text = NSLocalizedStringFromTable(@"LTP_Title", @"Localizable", @"LTP");
    _percentageChangeTitleLabel.text = NSLocalizedStringFromTable(@"Percentage_Change", @"Localizable", @"% Change");
    
    _marketDetailsLabel.text = self.titleLabel;
    [_backButton setTitle:NSLocalizedStringFromTable(@"Market_Order_Title", @"Localizable", @"Market") forState:UIControlStateNormal];
    
    _marketDetailsLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    _backButton.titleLabel.font = SEMI_BOLD_FONT_SIZE(15.5);
    
    _companyTitleLabel.font = _ltpTitleLabel.font = _percentageChangeTitleLabel.font = SEMI_BOLD_FONT_SIZE(16.0);
    
//    if(self.selectedIndex == 5 || self.selectedIndex == 5){
//        //change the label to volume ...
//        _topHeadingLabel.text = @"Volume";
//    }
//    else{
//        _topHeadingLabel.text = @"%Change";
//    }
    
//    self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureCell:(TTMarketDetailTableViewCell *)inCell withIndex:(NSIndexPath *)inIndexPath{
    
    UIColor *labelColor;
    
    TTCompanyData *currentCompanyData = [self.companyArray objectAtIndex:inIndexPath.row];
    inCell.companyNameLabel.text = currentCompanyData.companyName;
    
    if(self.isVolumeData){
        inCell.changeLabel.text = currentCompanyData.volume;
    }
    else{
        inCell.changeLabel.text = currentCompanyData.percentageChange;
    }
    
    inCell.ltpLabel.text = currentCompanyData.previousClosePrice;
    
    
    if([inCell.changeLabel.text floatValue] < 0)
        labelColor = SYMBOL_LOSS_LABEL_COLOR;
    else
        labelColor = SYMBOL_PROFIT_LABEL_COLOR;
    
    inCell.changeLabel.textColor = inCell.ltpLabel.textColor = labelColor;
    
        
    
//    if(self.selectedIndex == 0 || self.selectedIndex == 2 || self.selectedIndex == 5 || self.selectedIndex == 7){
//        //green color to be applied...
//        inCell.changeLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:166.0/255.0 blue:2.0/255.0 alpha:1];
//        inCell.ltpLabel.textColor = [UIColor colorWithRed:18.0/255.0 green:166.0/255.0 blue:2.0/255.0 alpha:1];
//    }
//    else{
//        inCell.changeLabel.textColor = [UIColor redColor];
//        inCell.ltpLabel.textColor = [UIColor redColor];
//    }
//    inCell
    
}

#pragma UITableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.companyArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    TTMarketDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTMarketDetailTableViewCell" owner:self options:nil];
        
        for(id oneObject in nib) {
            
            if([oneObject isKindOfClass:[TTMarketDetailTableViewCell class]]) {
                cell = (TTMarketDetailTableViewCell *)oneObject;
            }
            
        }
        
    }
    
    [self configureCell:cell withIndex:indexPath];
    
    return cell;
    
}

-(IBAction)goBackToMarketScreen:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
