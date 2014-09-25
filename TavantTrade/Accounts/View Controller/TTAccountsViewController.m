   //
//  TTAccountsViewController.m
//  TavantTrade
//
//  Created by TAVANT on 1/31/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTAccountsViewController.h"
#import "TTAccountNormalCell.h"
#import "TTDiffusionHandler.h"
#import "TTDiffusionData.h"
#import "SBITradingUtility.h"
#import "TTAccountDataSource.h"
#import "TTAccountLienCell.h"
#import "TTAccountMarginCell.h"
#import "TTAccountMTMCell.h"
#import "SBITradingNetworkManager.h"
#import "TTLienWebViewController.h"
#import "TTAccountDataSource.h"
#import "TTUrl.h"

@interface TTAccountsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *openEnlargedViewButton;
-(IBAction)showEnlargedView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property(nonatomic,weak)IBOutlet UILabel *enlargedAccountIdValue;
@property(nonatomic,weak)IBOutlet UILabel *enlargedLimitValue;
@property(nonatomic,assign) int tabSelected;
@property(nonatomic,strong)NSMutableDictionary * tableData;
@property(nonatomic,strong)TTAccountDataSource * tableDataSource;
@property(nonatomic,strong)TTLienWebViewController *lienView;
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property (nonatomic, weak) IBOutlet UIView *headerView;

@end
bool syncResponse=YES;
@implementation TTAccountsViewController
@synthesize isEnlargedView,tableData,tableDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    isEnlargedView = NO;
        tableData=[[NSMutableDictionary alloc] init];
       // tableDataSource=[[NSMutableDictionary alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
    NSString *subKey=@"REPORTS/ESI206321/LRS";
    [diffusionHandler subscribe:subKey withContext:self];
     self.tabSelected=eClient;
   // all server calls in single method
    if(!syncResponse){
        NSString *subKey=@"REPORTS/ESI206321/LRS";
        [diffusionHandler subscribe:subKey withContext:self];
    }
//    self.navigationController.navigationBarHidden = YES;
    
    //set the font ...
    _widgetTitleLabel.font = SEMI_BOLD_FONT_SIZE(19.0);
    _enlargedAccountTitleLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"AccountTitleBar"];
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"AccountTitleBar"];

    _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
    _widgetAccountIdLabel.font = _widgetLimitLabel.font = _accountNumberLabel.font = _limitLabel.font = _enlargedLimitLabel.font = _enlargedLimitValue.font = _enlargedAccountIdValue.font = _enlargerAccountIdLabel.font = _enlargedLimitLabel.font = REGULAR_FONT_SIZE(15.0);
    
//    _clientButton.titleLabel.font = _cashButton.titleLabel.font = _foButton.titleLabel.font = _currencyButton.titleLabel.font = _enlargedClientButton.titleLabel.font = _enlargedCashButton.titleLabel.font = _enlargedFoButton.titleLabel.font = _enlargedCurButton.titleLabel.font= REGULAR_FONT_SIZE(15.0);
     [self setAccountSegmentCOntrollerAttributes];
     [self.segmentControl addTarget:self action:@selector(accountSegmentControlDidChangeIndex:) forControlEvents:UIControlEventValueChanged];
    
    ///[self getAccountData];
    
}

// method for setting attributes of segmeted controller
-(void)  setAccountSegmentCOntrollerAttributes{
    
    [_segmentControl setTitle:NSLocalizedStringFromTable(@"Client_Limit", @"Localizable", @"Client") forSegmentAtIndex:0];
    [_segmentControl setTitle:NSLocalizedStringFromTable(@"Cash_Limit", @"Localizable", @"Cash") forSegmentAtIndex:1];
    [_segmentControl setTitle:NSLocalizedStringFromTable(@"Fo_Limit", @"Localizable", @"Fo") forSegmentAtIndex:2];
    [_segmentControl setTitle:NSLocalizedStringFromTable(@"Cur_Limit", @"Localizable", @"Currency") forSegmentAtIndex:3];
    [_widgetSegmentControl setTitle:NSLocalizedStringFromTable(@"Client_Limit", @"Localizable", @"Client") forSegmentAtIndex:0];
    [_widgetSegmentControl setTitle:NSLocalizedStringFromTable(@"Cash_Limit", @"Localizable", @"Cash") forSegmentAtIndex:1];
    [_widgetSegmentControl setTitle:NSLocalizedStringFromTable(@"Fo_Limit", @"Localizable", @"Fo") forSegmentAtIndex:2];
    [_widgetSegmentControl setTitle:NSLocalizedStringFromTable(@"Cur_Limit", @"Localizable", @"Currency") forSegmentAtIndex:3];
   
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:REGULAR_FONT_SIZE(16.0)
                                                           forKey:NSFontAttributeName];
    
    NSDictionary *widgetAttributes = [NSDictionary dictionaryWithObject:SEMI_BOLD_FONT_SIZE(14.0)
                                                                 forKey:NSFontAttributeName];
    
    [_segmentControl setTitleTextAttributes:attributes
                                   forState:UIControlStateNormal];
    
    [_widgetSegmentControl setTitleTextAttributes:widgetAttributes
                                         forState:UIControlStateNormal];
    _segmentControl.tintColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    _widgetSegmentControl.tintColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.view.superview.backgroundColor = [UIColor clearColor];
    // get localized string for all labels in the screen
    _widgetTitleLabel.text=NSLocalizedStringFromTable(@"Account_Title", @"Localizable", @"Accounts");
    _enlargedAccountTitleLabel.text=NSLocalizedStringFromTable(@"Account_Title", @"Localizable", @"Accounts");
    _widgetAccountIdLabel.text=NSLocalizedStringFromTable(@"Account_Id", @"Localizable", @"Account ID");
    _widgetAccountIdLabel.text=NSLocalizedStringFromTable(@"Account_Id", @"Localizable", @"Account ID");
    _widgetLimitLabel.text=NSLocalizedStringFromTable(@"Account_Limit", @"Localizable", @"Limit");
    _enlargedLimitLabel.text=NSLocalizedStringFromTable(@"Account_Limit", @"Localizable", @"Limit");
   
    [_cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];

    [super viewWillAppear:animated];
    [self getAccountData];
    //[self.accountsEnlargedTableView reloadData];
    
 
}

 // After subscribing make post request for client,cash,fo and cur
-(void)getAccountData{
    NSMutableDictionary *clientBody=[self createAccountBody:eClient];
    NSMutableDictionary *cashBody=[self createAccountBody:eCash];
    NSMutableDictionary *foBody=[self createAccountBody:eFo];
    NSMutableDictionary *curBody=[self createAccountBody:eCur];
    [self fetchAccountValues:clientBody];
    [self fetchAccountValues:cashBody];
    [self fetchAccountValues:foBody];
    [self fetchAccountValues:curBody];
}

-(void)fetchAccountValues:(NSMutableDictionary *) postBody{

    NSString *relativePath = [TTUrl tradeLimitURL];
  
       SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    
    [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBody responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
        if(recievedResponse.statusCode != 200){
            NSLog(@"Error For Post Body : %@",postBody);
             NSLog(@"error %d ",recievedResponse.statusCode);
        }
        else{
            
            NSError *jsonParsingError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            NSLog(@"For Post Body : %@",postBody);
             NSLog(@"Response segment type is %@",responseDictionary);
            if([responseDictionary isKindOfClass:[NSDictionary class]])
            {
                NSLog(@"Response Data is %@",[responseDictionary objectForKey:@"msgType"] );
            }
            else
            {
                //responseDictionary = nil;

                NSArray *array = (NSArray *)responseDictionary;
                if(array && [array count])
                {
                    
                    responseDictionary = [array objectAtIndex:0];
                    NSLog(@"Response Data is %@",[responseDictionary objectForKey:@"segment"]);
                }
                else
                {
                    responseDictionary = nil;
                }
            }
            
            TTAccountDataSource *diffusionData = [[TTAccountDataSource alloc] initWithDictionary:responseDictionary];
              self.limitLabel.text = [NSString stringWithFormat:@"%.02f",diffusionData.limit];
            [self updateTableDataSource:diffusionData];
            // reload the table on response callback
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isEnlargedView == YES){
                    [self.accountsEnlargedTableView reloadData];
                }
                else
                    [self.accountsWidgetTableView reloadData];
            });

        }
        
    }];

    
}

-(NSMutableDictionary *)createAccountBody: (int) index{
    NSMutableDictionary * postBody;
          switch (index) {
        case eClient:postBody=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"ESI206321",@"clientID" ,@"ESI206321",@"userMessage",[NSNumber numberWithBool:syncResponse],@"syncResponse", nil];
            break;
            
        case eCash:postBody=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"ESI206321",@"clientID" ,@"ESI206321",@"userMessage",[NSNumber numberWithBool:syncResponse],@"syncResponse",@"CASH",@"segment", nil];
            break;
        case eFo:postBody=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"ESI206321",@"clientID" ,@"ESI206321",@"userMessage",[NSNumber numberWithBool:syncResponse],@"syncResponse",@"FO",@"segment", nil];
            break;
        case eCur:postBody=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"ESI206321",@"clientID" ,@"ESI206321",@"userMessage",[NSNumber numberWithBool:syncResponse],@"syncResponse",@"CUR",@"segment", nil];
            break;
    }
   
    return postBody;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//   self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
   
    TTAccountDataSource *diffusionData = [[TTAccountDataSource alloc] initWithAccountsData:message];
    
    //diffusionData = [diffusionData updateAccountsData:message];
    
    self.limitLabel.text = [NSString stringWithFormat:@"%.02f",diffusionData.limit];
    [self updateTableDataSource:diffusionData];
 
}

// update the table data sources according to the segment type like client,cash,fo and cur
-(void)updateTableDataSource:(TTAccountDataSource *)responseData{
   // NSMutableDictionary *tableData;
    
    if([responseData.type isEqualToString:@"NA"]){
        [ tableData setObject:responseData forKey:@"client"];
        tableDataSource=[tableData objectForKey:@"client"];
        NSLog(@"Response Data is### %@",tableDataSource);
        //[self.accountsEnlargedTableView reloadData];

    }
    else if([responseData.type isEqualToString:@"CASH"]){
        [ tableData setObject:responseData forKey:@"cash"];
    }
    else if([responseData.type isEqualToString:@"FO"]){
        [ tableData setObject:responseData forKey:@"fo"];
    }
    else if([responseData.type isEqualToString:@"CUR"]){
        [ tableData setObject:responseData forKey:@"cur"];
    }
     NSLog(@"tableData is %@",tableData);
}


 - (void)accountSegmentControlDidChangeIndex:(id)sender
{
    self.widgetSegmentControl.selectedSegmentIndex = self.segmentControl.selectedSegmentIndex;
    self.tabSelected = self.segmentControl.selectedSegmentIndex;
  
    _tabSelected = self.segmentControl.selectedSegmentIndex;
    
    
    
    
    switch (_tabSelected) {
        case eClient:
        {
            tableDataSource=[tableData objectForKey:@"client"];
                    }
            break;
        case eCash:
        {
            tableDataSource=[tableData objectForKey:@"cash"];
            
            
        }
            break;
        case eFo:
        {
            tableDataSource=[tableData objectForKey:@"fo"];
           
            
        }
            break;
        case eCur:
        {
            tableDataSource=[tableData objectForKey:@"cur"];
            
            
        }
            break;
            
        default:
            break;
    }

    [_accountsEnlargedTableView reloadData];
}




- (IBAction)dismissTheController:(id)sender {
    isEnlargedView = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)showEnlargedView:(id)sender{
    isEnlargedView = YES;
    NSLog(@"navigation %@",self.navigationController);
    [self.presentEnlargedViewDelegate AccountViewControllerShouldPresentinEnlargedView:self.navigationController];
}
#pragma tableview delegate methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height;
    if(self.tabSelected==0){
        switch(indexPath.row){
            case 1: height= 77.0; // when client tab selected 2nd row
                    break;
            case 7:height= 110.0; // when client tab selected 8th row
                    break;
            case 10:height= 160.0; // when client tab selected 10th row
                    break;
           default:height= 41.0; // rest of the rows are  normal cells
                    break;
        }
    }
    else{
        switch(indexPath.row){
            case 1: height= 77.0; // when cash,fo or cur is selected second row
                    break;
            case 5:height= 110.0;  // when cash,fo or cur is selected 6th(index 5) row
                    break;
            case 8:height= 160.0; // when cash,fo or cur is selected 9th row
                    break;

            default:height= 41.0;
                break;
        }
    }
    return height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     if(self.tabSelected==0)
         return 11;
    else
        return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier = @"TTAccountNormalCell";
    NSUInteger row = indexPath.row;
    
    UITableViewCell *cell = nil;
    
    if (cell == nil) {
        
        NSArray *nib;
           switch(self.tabSelected){// if client selected then populate following cells on table
             
               case eClient :{
               // hardcoding the row indexes based on server response and web app design
               switch(row){
                   case 0:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       NSLog(@"value is %f",tableDataSource.ledgerBalance);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Ledger_Balance", @"Localizable", @"Ledger Balance");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.ledgerBalance];

                   }
                       break;
                   case 1:// lien cell with 2 buttons in it
                   {
                       cellIdentifier =@"TTAccountLienCell";
                       cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountLienCell" owner:self options:nil];
                           TTAccountLienCell* accLienCell = [nib objectAtIndex:0];
                           accLienCell.delegate =self;
                           accLienCell.valueLabel.font = accLienCell.valueInRupee.font = accLienCell.fundLienButton.titleLabel.font = accLienCell.dpLienButton.titleLabel.font = REGULAR_FONT_SIZE(15.0);
                           cell = accLienCell;

                       }
                       TTAccountLienCell *lienCell=(TTAccountLienCell*) cell;
                       lienCell.dpLienButton.backgroundColor=[SBITradingUtility getColorForComponentKey:@"Default"];
                       lienCell.fundLienButton.backgroundColor=[SBITradingUtility getColorForComponentKey:@"Default"];
                       lienCell.valueLabel.text=NSLocalizedStringFromTable(@"Liened_Amount", @"Localizable", @"Leaned Amount Today");
                       lienCell.valueInRupee.text= [NSString stringWithFormat:@"Rs.%.2f",tableDataSource.ledgerBalance];
                      
                   }
                       break;
                       
                   case 7:// cell which shows additional adhoc margin
                   {
                       cellIdentifier =@"TTAccountMarginCell";
                       cell = (TTAccountMarginCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountMarginCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountMarginCell *marginCell=(TTAccountMarginCell *)cell;
                       marginCell.adhocMargin.font = marginCell.adhocMarginTitle.font = marginCell.nationalCash.font = marginCell.nationalCashTitle.font = marginCell.directCollatral.font = marginCell.directCollatralTitle.font = REGULAR_FONT_SIZE(13.0);
                       marginCell.valueLabel.font = marginCell.additinalAdhocMargin.font = REGULAR_FONT_SIZE(15.0);
                       marginCell.valueLabel.text=NSLocalizedStringFromTable(@"Addition_Margin", @"Localizable", @"Additional Adhoc Margin");
                       marginCell.additinalAdhocMargin.text=[NSString stringWithFormat:@"Rs.%.2f",tableDataSource.additionAdhocMargin];
                       marginCell.adhocMargin.text=[NSString stringWithFormat:@"%.2f",tableDataSource.adhocMargin];
                       marginCell.nationalCash.text=[NSString stringWithFormat:@"%.2f",tableDataSource.nationalCash];
                       marginCell.directCollatral.text=[NSString stringWithFormat:@"%.2f",tableDataSource.directCollateral];
                   }
                       break;
                   case 10:// cell that shows margin used for orders and trades
                   {
                       cellIdentifier =@"TTAccountMTMCell";
                       cell = (TTAccountMTMCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountMTMCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];

                       }
                       TTAccountMTMCell *mtmCell=(TTAccountMTMCell *)cell;
                       
                       mtmCell.marginUsed.font = mtmCell.marginUsedTitle.font = mtmCell.realizedmtmGain.font = mtmCell.realizedmtmGainTitle.font = mtmCell.cncSalesProceeds.font = mtmCell.cncSalesProceedsTitle.font = mtmCell.unrealizedmtmLoss.font = mtmCell.unrealizedmtmLossTitle.font = REGULAR_FONT_SIZE(13.0);
                       mtmCell.marginUsedForOrders.font = mtmCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       
                       mtmCell.valueLabel.text=NSLocalizedStringFromTable(@"Total_Margin_Used", @"Localizable", @"Margin used for orders and trades");
                       mtmCell.marginUsedForOrders.text=[NSString stringWithFormat:@"Rs.%.2f",tableDataSource.totalMarginUsed];
                       mtmCell.marginUsed.text=[NSString stringWithFormat:@"%.2f",tableDataSource.marginUsed];
                       mtmCell.unrealizedmtmLoss.text=[NSString stringWithFormat:@"%.2f",tableDataSource.unrealisedMTMLoss];
                       mtmCell.realizedmtmGain.text=[NSString stringWithFormat:@"%.2f",tableDataSource.realisedMTMGain];
                       mtmCell.cncSalesProceeds.text=[NSString stringWithFormat:@"%.2f",tableDataSource.cncSales];
                       
                   }
                       break;
                  
                   case 2:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Ipo_Amount", @"Localizable", @"IPO Amount");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.IPOAmount];
                   }
                       break;
                   case 3:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Mutual_Fund", @"Localizable", @"Mutual Fund Amount");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.mutualFundAmount];
                   }
                       break;
                   case 4:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Collateral", @"Localizable", @"Collateral");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.collateral];
                   }
                       break;
                   case 5:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Funds_From_Sales", @"Localizable", @"Funds from Sales Proceeds");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.fundsFormSales];
                   }
                       break;
                   case 6:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Realised_gain", @"Localizable", @"Realised Gains");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.realisedGain];
                   }
                       break;
                   case 8:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"MTM_Loss", @"Localizable", @"MTM Loss on Positions");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.mtmLossOnPositions];
                   }
                       break;
                   case 9:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Amount_Unleaned", @"Localizable", @"Amount Unleaned Today");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.amountUnlened];                   }
                       break;
                   default:break;
               }
               
               
            }
           
            break;
            default:{// if other that client any tab is selected then populate following cells on table
               switch(row){
                   case 0:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       NSLog(@"value is %f",tableDataSource.ledgerBalance);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Ledger_Balance", @"Localizable", @"Ledger Balance");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.ledgerBalance];
                       
                   }
                    break;
                   case 1:// lien cell with 2 buttons in it
                   {
                       cellIdentifier =@"TTAccountLienCell";
                       cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountLienCell" owner:self options:nil];
                           TTAccountLienCell* accLienCell = [nib objectAtIndex:0];
                           accLienCell.delegate =self;
                           accLienCell.valueLabel.font = accLienCell.valueInRupee.font = accLienCell.fundLienButton.titleLabel.font = accLienCell.dpLienButton.titleLabel.font = REGULAR_FONT_SIZE(15.0);
                           cell = accLienCell;
                       }
                       TTAccountLienCell *lienCell=(TTAccountLienCell*) cell;
                       lienCell.dpLienButton.backgroundColor=[SBITradingUtility getColorForComponentKey:@"Default"];
                       lienCell.fundLienButton.backgroundColor=[SBITradingUtility getColorForComponentKey:@"Default"];
                       lienCell.valueLabel.text=NSLocalizedStringFromTable(@"Liened_Amount", @"Localizable", @"Leaned Amount Today");
                       lienCell.valueInRupee.text= [NSString stringWithFormat:@"Rs.%.2f",tableDataSource.ledgerBalance];
                       
                   }
                       break;
                       
                   case 5:
                   {
                       cellIdentifier =@"TTAccountMarginCell";
                       cell = (TTAccountMarginCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountMarginCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountMarginCell *marginCell=(TTAccountMarginCell *)cell;
                       marginCell.adhocMargin.font = marginCell.adhocMarginTitle.font = marginCell.nationalCash.font = marginCell.nationalCashTitle.font = marginCell.directCollatral.font = marginCell.directCollatralTitle.font = REGULAR_FONT_SIZE(13.0);
                       marginCell.valueLabel.font = marginCell.additinalAdhocMargin.font = REGULAR_FONT_SIZE(15.0);

                       marginCell.valueLabel.text=NSLocalizedStringFromTable(@"Addition_Margin", @"Localizable", @"Additional Adhoc Margin");
                       marginCell.additinalAdhocMargin.text=[NSString stringWithFormat:@"Rs.%.2f",tableDataSource.additionAdhocMargin];
                       marginCell.adhocMargin.text=[NSString stringWithFormat:@"%.2f",tableDataSource.adhocMargin];
                       marginCell.nationalCash.text=[NSString stringWithFormat:@"%.2f",tableDataSource.nationalCash];
                       marginCell.directCollatral.text=[NSString stringWithFormat:@"%.2f",tableDataSource.directCollateral];
                   }
                       break;
                   case 8:
                   {
                       cellIdentifier =@"TTAccountMTMCell";
                       cell = (TTAccountMTMCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountMTMCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountMTMCell *mtmCell=(TTAccountMTMCell *)cell;
                       mtmCell.marginUsed.font = mtmCell.marginUsedTitle.font = mtmCell.realizedmtmGain.font = mtmCell.realizedmtmGainTitle.font = mtmCell.cncSalesProceeds.font = mtmCell.cncSalesProceedsTitle.font = mtmCell.unrealizedmtmLoss.font = mtmCell.unrealizedmtmLossTitle.font = REGULAR_FONT_SIZE(13.0);
                       mtmCell.marginUsedForOrders.font = mtmCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       mtmCell.valueLabel.text=NSLocalizedStringFromTable(@"Total_Margin_Used", @"Localizable", @"Margin used for orders and trades");
                       mtmCell.marginUsedForOrders.text=[NSString stringWithFormat:@"Rs.%.2f",tableDataSource.totalMarginUsed];
                       mtmCell.marginUsed.text=[NSString stringWithFormat:@"%.2f",tableDataSource.marginUsed];
                       mtmCell.unrealizedmtmLoss.text=[NSString stringWithFormat:@"%.2f",tableDataSource.unrealisedMTMLoss];
                       mtmCell.realizedmtmGain.text=[NSString stringWithFormat:@"%.2f",tableDataSource.realisedMTMGain];
                       mtmCell.cncSalesProceeds.text=[NSString stringWithFormat:@"%.2f",tableDataSource.cncSales];

                   }
                       break;
                       
                   case 2:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Collateral", @"Localizable", @"Collateral");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.collateral];
                   }
                       break;
                   case 3:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Funds_From_Sales", @"Localizable", @"Funds from Sales Proceeds");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.fundsFormSales];
                   }
                       break;
                   case 4:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Realised_gain", @"Localizable", @"Realised Gains");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.realisedGain];
                   }
                       break;
                   case 6:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"MTM_Loss", @"Localizable", @"MTM Loss on Positions");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.mtmLossOnPositions];
                   }
                       break;
                   case 7:// rest of all the cell with default cell design
                   {
                       cellIdentifier =@"TTAccountNormalCell";
                       cell = (TTAccountNormalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                       if(!cell)
                       {
                           nib = [[NSBundle mainBundle] loadNibNamed:@"TTAccountNormalCell" owner:self options:nil];
                           cell = [nib objectAtIndex:0];
                       }
                       TTAccountNormalCell *accountCell = (TTAccountNormalCell*)cell;
                       accountCell.valueInRupee.font = accountCell.valueLabel.font = REGULAR_FONT_SIZE(15.0);
                       accountCell.valueLabel.text=NSLocalizedStringFromTable(@"Amount_Unleaned", @"Localizable", @"Amount Unleaned Today");
                       accountCell.valueInRupee.text= [NSString stringWithFormat:@" Rs.%.2f",tableDataSource.amountUnlened];
                   }
                       break;
                   default:break;
               }

           }
        break;
      
    }
    }
   
    return cell;
}
    

-(void)tableview:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

// Delegate method to openwebView on Lein amount click
-(void)openWebViewFromUrl:(NSString *)url{
   _lienView=[[TTLienWebViewController alloc] initWithNibName:@"TTLienWebViewController" bundle:nil];
    _lienView.url = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.navigationController pushViewController:_lienView animated:YES];

}

@end
