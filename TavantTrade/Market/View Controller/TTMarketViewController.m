//
//  TTMarketViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 1/15/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTMarketViewController.h"
#import "TTMarketTableViewCell.h"
#import "TTConstants.h"
#import "SBITradingUtility.h"
#import "TTUrl.h"
#import "SBITradingNetworkManager.h"
#import "TTCompanyData.h"
#import "TTSymbolDetails.h"
#import "TTDismissingView.h"
#import "TTDataSource.h"
#import "TTMarketDetailViewController.h"
#import "TTMarketTiming.h"

@interface TTMarketViewController ()

@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property(nonatomic,strong)IBOutlet UITableView *detailsTableView;
@property(nonatomic,strong)IBOutlet UITableView *widgetdDetailsTableView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet UIButton *largeViewButton;

@property(nonatomic,assign)EExchangeType exchangeType;
@property(nonatomic,weak)IBOutlet UISegmentedControl *segmentControl;
@property(nonatomic,weak)IBOutlet UISegmentedControl *widgetSegmentControl;
@property(nonatomic,strong)NSString *group;
@property(nonatomic,strong)NSString *currentSymbol;

@property(nonatomic,strong)TTMarketDetailViewController *marketDetailViewController;
@property(nonatomic,assign)BOOL isEnlargedView;
@property(nonatomic,strong)NSString *subKeyNSE;
@property(nonatomic,strong)NSString *subKeyBSE;
@property(nonatomic,strong)NSString *subKEyUSDINR;
@property (weak, nonatomic) IBOutlet UIImageView *bseNetChangeIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *curNetChangeIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *nseNetChangeIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *nseTimingImage;
@property (weak, nonatomic) IBOutlet UIImageView *bseTimingImage;
@property (weak, nonatomic) IBOutlet UIImageView *curTimingImage;
@property (weak, nonatomic) IBOutlet UILabel *nseChangeRatio;
@property (weak, nonatomic) IBOutlet UILabel *bseChangeRatio;
@property (weak, nonatomic) IBOutlet UILabel *curChangeRatio;
@property (weak, nonatomic) IBOutlet UILabel *nseChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bseChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *curChangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nseLtpLabel;
@property (weak, nonatomic) IBOutlet UILabel *bseLtpLabel;
@property (weak, nonatomic) IBOutlet UILabel *curLtpLabel;
@property (weak, nonatomic) IBOutlet UILabel *nseVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bseVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *curVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *usd_inrTitle;
@property (weak, nonatomic) IBOutlet UILabel *sensexTitle;
@property (weak, nonatomic) IBOutlet UILabel *niftyTitle;

@property (weak, nonatomic) IBOutlet UIImageView *widgetNseChangeIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *widgetBseChangeIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *widgetCurChangeIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *widgetCurStatus;
@property (weak, nonatomic) IBOutlet UIImageView *widgetBseStatus;
@property (weak, nonatomic) IBOutlet UIImageView *widgetNseStatus;
@property (weak, nonatomic) IBOutlet UILabel *widgetCurRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetBseratioLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetNseRatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetNseLtpLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetNseVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetBseLtpLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetBseVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetCurLtpLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetCurVolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetUsd_inrTitle;
@property (weak, nonatomic) IBOutlet UILabel *widgetSensexTitle;
@property (weak, nonatomic) IBOutlet UILabel *widgetNiftyTitle;


@property(nonatomic,weak)IBOutlet UIButton *cancelButton;

-(IBAction)showEnlargedView:(id)sender;
@end


@implementation TTMarketViewController

@synthesize isEnlargedView;

@synthesize detailsTableView,dataSourceArray,widgetdDetailsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isEnlargedView = NO;
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
//    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGlobalSymbolData) name:@"UpdateGlobalSymbol" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateExchangeType:) name:@"UpdateExchangeType" object:nil];
    
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    
    _marketTitle.text = _widgetMarketTitle.text = NSLocalizedStringFromTable(@"Market_Order_Title", @"Localizable", @"Market");
    [_segmentControl setTitle:NSLocalizedStringFromTable(@"Nifty_Title", @"Localizable", @"NIFTY") forSegmentAtIndex:0];
    [_segmentControl setTitle:NSLocalizedStringFromTable(@"Sensex_Title", @"Localizable", @"SENSEX") forSegmentAtIndex:1];
    [_widgetSegmentControl setTitle:NSLocalizedStringFromTable(@"Nifty_Title", @"Localizable", @"NIFTY") forSegmentAtIndex:0];
    [_widgetSegmentControl setTitle:NSLocalizedStringFromTable(@"Sensex_Title", @"Localizable", @"SENSEX") forSegmentAtIndex:1];
    _segmentControl.tintColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    _widgetSegmentControl.tintColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    
    self.currentSymbol = symbolDetails.symbolData.symbolName;
    
    //set the heading and other labels of the screen ...
    _niftyTitle.text = _widgetNiftyTitle.text = NSLocalizedStringFromTable(@"Nifty_Title", @"Localizable", @"NIFTY");
    _sensexTitle.text = _widgetSensexTitle.text = NSLocalizedStringFromTable(@"Sensex_Title", @"Localizable", @"SENSEX");
    _usd_inrTitle.text = _widgetUsd_inrTitle.text = NSLocalizedStringFromTable(@"USD_INR_Title", @"Localizable", @"USD/INR");
    
    _niftyTitle.font = _sensexTitle.font = _usd_inrTitle.font = _widgetNiftyTitle.font = _widgetSensexTitle.font = _widgetUsd_inrTitle.font = REGULAR_FONT_SIZE(15.0);
    
    _bseChangeRatio.font = _nseChangeRatio.font = _curChangeRatio.font = _bseChangeLabel.font = _nseChangeLabel.font = _curChangeLabel.font = _widgetNseRatioLabel.font = _widgetCurRatioLabel.font = _widgetBseratioLabel.font = REGULAR_FONT_SIZE(13.0);
    
    _widgetNseLtpLabel.font = _widgetBseLtpLabel.font = _widgetCurLtpLabel.font = _nseLtpLabel.font = _bseLtpLabel.font = _curLtpLabel.font = SEMI_BOLD_FONT_SIZE(16.0);
    
    _nseVolumeLabel.font = _bseVolumeLabel.font = _curVolumeLabel.font = _widgetBseVolumeLabel.font = _widgetNseVolumeLabel.font = _widgetCurVolumeLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    
    //set the font ...
    _widgetMarketTitle.font = SEMI_BOLD_FONT_SIZE(19.0);
    _marketTitle.font = SEMI_BOLD_FONT_SIZE(22.0);
    
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"MarketTitleBar"];
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"MarketTitleBar"];
    
  
//
//    if(self.currentSymbol){
//        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
//        [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
//    }
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:175.0f/255.0f blue:138.0f/255.0f alpha:1]];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [SBITradingUtility navBarHeadingFont]};
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationItem.title = NSLocalizedStringFromTable(@"Market_Order_Title", @"Localizable", @"Market");
    
//    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] init];
//    [cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel")];
//    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[SBITradingUtility cancelButtonFont],NSFontAttributeName,nil] forState:UIControlStateNormal];
//    [cancelButton setTarget:self];
//    [cancelButton setAction:@selector(dismissTheController:)];
//    
//    self.navigationItem.leftBarButtonItem = cancelButton;
    
//    self.navigationController.navigationBarHidden = YES;
    
    [_cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
//    self.group = NSLocalizedStringFromTable(@"Nifty_Title", @"Localizable", @"NIFTY");
    self.group = NSLocalizedStringFromTable(@"NSE_KEY", @"Localizable", @"NSE/NIFTY");
    
    [self reloadMarketData];

    [self.segmentControl addTarget:self action:@selector(segmentControlDidChangeIndex:) forControlEvents:UIControlEventValueChanged];
    
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:REGULAR_FONT_SIZE(16.0)
                                                           forKey:NSFontAttributeName];
    
    NSDictionary *widgetAttributes = [NSDictionary dictionaryWithObject:SEMI_BOLD_FONT_SIZE(14.0)
                                                           forKey:NSFontAttributeName];
    
    [_segmentControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    [_widgetSegmentControl setTitleTextAttributes:widgetAttributes
                                       forState:UIControlStateNormal];
    
    // Implementation of market timing from diffusion
     TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
     [diffusionHandler subscribe:NSLocalizedStringFromTable(@"NSE_Subscription_Key", @"Localizable",@"MARKET/NSE/STATUS") withContext:self];
     [diffusionHandler subscribe:NSLocalizedStringFromTable(@"BSE_Subscription_Key", @"Localizable",@"MARKET/BSE/STATUS") withContext:self];
     [diffusionHandler subscribe:NSLocalizedStringFromTable(@"CD_Subscription_Key", @"Localizable",@"MARKET/CD/STATUS") withContext:self];


    // Do any additional setup after loading the view from its nib.
}

-(void)reloadMarketData{
    
    dataSourceArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < 8; i++){
        
        switch ((MarketDataType)i) {
            case TOP_GAINER:{
                TTDataSource *dataSource = [[TTDataSource alloc] init];
                dataSource.imageFile = (isEnlargedView == YES)?@"top_g_enlarged":@"top_gainer.png";
                dataSource.marketType = TOP_GAINER;
                [self prepareDataSourceDictionaryFor:TOP_GAINER andPopulate:dataSource];
                [dataSourceArray addObject:dataSource];
            }
                break;
            case TOP_LOSER:{
                TTDataSource *dataSource = [[TTDataSource alloc] init];
                dataSource.imageFile = (isEnlargedView == YES)?@"top_l_enlarged":@"top_losser.png";
                dataSource.marketType = TOP_LOSER;
                [self prepareDataSourceDictionaryFor:TOP_LOSER andPopulate:dataSource];
                [dataSourceArray addObject:dataSource];
            }
                break;
            case HOURLY_GAINER:{
                TTDataSource *dataSource = [[TTDataSource alloc] init];
                dataSource.imageFile = (isEnlargedView == YES)?@"hourly_g_enlarged":@"hourly_gainer.png";
                dataSource.marketType = HOURLY_GAINER;
                [self prepareDataSourceDictionaryFor:HOURLY_GAINER andPopulate:dataSource];
                [dataSourceArray addObject:dataSource];
            }
                break;
            case HOURLY_LOSER:{
                TTDataSource *dataSource = [[TTDataSource alloc] init];
                dataSource.imageFile = (isEnlargedView == YES)?@"hourly_l_enlarged":@"hourly_losser.png";
                dataSource.marketType = HOURLY_LOSER;
                [self prepareDataSourceDictionaryFor:HOURLY_LOSER andPopulate:dataSource];
                [dataSourceArray addObject:dataSource];
            }
                break;
            case VOL_SHOCKER:{
                TTDataSource *dataSource = [[TTDataSource alloc] init];
                dataSource.imageFile = (isEnlargedView == YES)?@"volume_shockers_enlarged":@"volume_shockers.png";
                dataSource.marketType = VOL_SHOCKER;
                [self prepareDataSourceDictionaryFor:VOL_SHOCKER andPopulate:dataSource];
                [dataSourceArray addObject:dataSource];
            }
                break;
            case VOL_TOPPER:{
                TTDataSource *dataSource = [[TTDataSource alloc] init];
                dataSource.imageFile = (isEnlargedView == YES)?@"volume_topers_enlarged":@"volume_topers.png";
                dataSource.marketType = VOL_TOPPER;
                [self prepareDataSourceDictionaryFor:VOL_TOPPER andPopulate:dataSource];
                [dataSourceArray addObject:dataSource];
            }
                break;
            case PRICE_SHOCKER:{
                TTDataSource *dataSource = [[TTDataSource alloc] init];
                dataSource.imageFile = (isEnlargedView == YES)?@"price_shockers_enlarged":@"price_shockers.png";
                dataSource.marketType = PRICE_SHOCKER;
                [self prepareDataSourceDictionaryFor:PRICE_SHOCKER andPopulate:dataSource];
                [dataSourceArray addObject:dataSource];
            }
                break;
            case MOST_ACTIVE:{
                TTDataSource *dataSource = [[TTDataSource alloc] init];
                dataSource.imageFile = (isEnlargedView == YES)?@"most_actives_enlarged":@"most_actives.png";
                dataSource.marketType = MOST_ACTIVE;
                [self prepareDataSourceDictionaryFor:MOST_ACTIVE andPopulate:dataSource];
                [dataSourceArray addObject:dataSource];
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateExchangeType" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.view.superview.backgroundColor = [UIColor clearColor];
}

-(void)prepareDataSourceDictionaryFor:(MarketDataType)inMarketType andPopulate:(TTDataSource *)inDataSource{
    
        NSString *urlString = @"marketdata";
        
        urlString = [self prepareURL:urlString for:inMarketType];
    
        //fetch the respective data using Market APIs...
        
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        [networkManager makeGETRequestWithRelativePath:urlString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            if(data)
            {
                NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
                NSLog(@"************** %@ and status code is %@ for URL %@",jsonString,response,urlString);
                
                NSMutableArray *currentCompanyArray = [[NSMutableArray alloc] init];
                
                NSError *jsonParsingError = nil;
                NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
                
                for(id object in responseArray){
                    TTCompanyData *companyData = [[TTCompanyData alloc] initWithDictionary:object];
                    [currentCompanyArray addObject:companyData];
                }
                inDataSource.currentCompanyArray = currentCompanyArray;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [detailsTableView reloadData];
                    [widgetdDetailsTableView reloadData];
                });
            }
            
        }];
    
}


-(NSString *)prepareURL:(NSString *)urlString for:(MarketDataType)marketType{
    
    urlString = [urlString stringByAppendingFormat:@"/%@",[SBITradingUtility getMarketDataTypeURLKey:marketType]];
    
    NSString *exchangeType = [SBITradingUtility getTitleForEchangeType:self.exchangeType];
    NSString *group = self.group; //[NSString stringWithFormat:@"%@_%@",exchangeType,self.group];
    NSString *period = @"DAY"; // TODO:
    NSString *numOfRecords = @"10";
    NSString *averagePeriod = @"5"; //TODO:
    NSString *option = @"P"; //TODO:
    
    
//    switch (marketType) {
//        case TOP_GAINER:
//            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@/%@",exchangeType,group,period,@"G",numOfRecords];
//            break;
//        case TOP_LOSER:
//            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@/%@",exchangeType,group,period,@"L",numOfRecords];
//            break;
//        case HOURLY_GAINER:
//            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",exchangeType,group,@"G",numOfRecords];
//            break;
//        case HOURLY_LOSER:
//            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",exchangeType,group,@"L",numOfRecords];
//            break;
//        case VOL_SHOCKER:
//            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",exchangeType,averagePeriod,option,numOfRecords];
//            break;
//        case VOL_TOPPER:
//            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",exchangeType,group,period,numOfRecords];
//            break;
//        case MOST_ACTIVE:
//            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",exchangeType,group,option,numOfRecords];
//            break;
//        case PRICE_SHOCKER:
//            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",exchangeType,averagePeriod,option,numOfRecords];
//            break;
//            
//        default:
//            break;
//    }

    switch (marketType) {
        case TOP_GAINER:
            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",group,period,@"G",numOfRecords];
            break;
        case TOP_LOSER:
            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",group,period,@"L",numOfRecords];
            break;
        case HOURLY_GAINER:
            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@",group,@"G",numOfRecords];
            break;
        case HOURLY_LOSER:
            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@",group,@"L",numOfRecords];
            break;
        case VOL_SHOCKER:
            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",exchangeType,averagePeriod,option,numOfRecords];
            break;
        case VOL_TOPPER:
            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@",group,period,numOfRecords];
            break;
        case MOST_ACTIVE:
            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@",group,option,numOfRecords];
            break;
        case PRICE_SHOCKER:
            urlString = [urlString stringByAppendingFormat:@"/%@/%@/%@/%@",exchangeType,averagePeriod,option,numOfRecords];
            break;
            
        default:
            break;
    }

    
    return urlString;
}

-(void)configureCell:(TTMarketTableViewCell *)cell withIndex:(NSIndexPath *)indexPath{
    TTDataSource *currentDataSource = [dataSourceArray objectAtIndex:indexPath.row];
    cell.cellTitleLabel.text = [SBITradingUtility getTitleForMarketDataType:currentDataSource.marketType];
    NSString * imageName = currentDataSource.imageFile;
    cell.cellImageView.image = [UIImage imageNamed:imageName];
    cell.cellTitleLabel.font=REGULAR_FONT_SIZE(14.0);
    cell.cellCompanyLabel1.font=SEMI_BOLD_FONT_SIZE(12.0);
    cell.cellCompanyLabel2.font=SEMI_BOLD_FONT_SIZE(12.0);
    cell.cellCompanyValueLabel1.font=REGULAR_FONT_SIZE(12.0);
    cell.cellCompanyValueLabel2.font=REGULAR_FONT_SIZE(12.0);
    if([dataSourceArray count] > indexPath.row){
        
        if(currentDataSource.currentCompanyArray != NULL){
            
//            if([cell.cellTitleLabel.text rangeOfString:@"Loser"].location != NSNotFound){
//                cell.cellCompanyValueLabel1.textColor = [UIColor redColor];
//                cell.cellCompanyValueLabel2.textColor = [UIColor redColor];
//            }
//            else{
                cell.cellCompanyValueLabel1.textColor = SYMBOL_PROFIT_LABEL_COLOR;
                cell.cellCompanyValueLabel2.textColor = SYMBOL_PROFIT_LABEL_COLOR;
//            }
            
            NSLog(@"currentDataSource %@",currentDataSource);
            
            if([currentDataSource.currentCompanyArray count] >= 2){
                TTCompanyData *companyData1 = (TTCompanyData *)[currentDataSource.currentCompanyArray objectAtIndex:0];
                cell.cellCompanyLabel1.text = companyData1.companyName;
                
                TTCompanyData *companyData2 = (TTCompanyData *)[currentDataSource.currentCompanyArray objectAtIndex:1];
                cell.cellCompanyLabel2.text = companyData2.companyName;
                
                
                if([cell.cellTitleLabel.text rangeOfString:@"Volume"].location != NSNotFound){
                    cell.cellCompanyValueLabel1.text = companyData1.volume;
                    cell.cellCompanyValueLabel2.text = companyData2.volume;
                }
                else{
                    cell.cellCompanyValueLabel1.text = companyData1.percentageChange;
                    cell.cellCompanyValueLabel2.text = companyData2.percentageChange;
                }
                
                if([cell.cellCompanyValueLabel1.text floatValue] < 0)
                    cell.cellCompanyValueLabel1.textColor = SYMBOL_LOSS_LABEL_COLOR;
                if([cell.cellCompanyValueLabel2.text floatValue] < 0)
                    cell.cellCompanyValueLabel2.textColor = SYMBOL_LOSS_LABEL_COLOR;
                
            }
        
            
        }
    }
    
}


#pragma UITableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSourceArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    TTMarketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {

        NSArray *nib;
        
        if(isEnlargedView == YES && [tableView.superview isEqual:self.view])
            nib = [[NSBundle mainBundle] loadNibNamed:@"TTMarketEnlargedTableViewCell" owner:self options:nil];
        else
            nib = [[NSBundle mainBundle] loadNibNamed:@"TTMarketTableViewCell" owner:self options:nil];
        
        for(id oneObject in nib) {
            
            if([oneObject isKindOfClass:[TTMarketTableViewCell class]]) {
                cell = (TTMarketTableViewCell *)oneObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        }
        
    }
    
    if(isEnlargedView == YES && [tableView.superview isEqual:self.view]){
        cell.cellCompanyLabel1.font = cell.cellCompanyLabel2.font = cell.cellCompanyValueLabel1.font = cell.cellCompanyValueLabel2.font = SEMI_BOLD_FONT_SIZE(13.0);
        cell.cellTitleLabel.font = SEMI_BOLD_FONT_SIZE(15.0);
    }
    else{
        cell.cellCompanyLabel1.font = cell.cellCompanyLabel2.font = cell.cellCompanyValueLabel1.font = cell.cellCompanyValueLabel2.font = SEMI_BOLD_FONT_SIZE(10.0);
        cell.cellTitleLabel.font = SEMI_BOLD_FONT_SIZE(14.0);
    }
        
    
    [self configureCell:cell withIndex:indexPath];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TTDataSource *currentSelectedObject = [dataSourceArray objectAtIndex:indexPath.row];
    self.marketDetailViewController = [[TTMarketDetailViewController alloc] initWithNibName:@"TTMarketDetailViewController" bundle:nil];
    [self.marketDetailViewController populateCompanyArray:currentSelectedObject.currentCompanyArray];
    self.marketDetailViewController.titleLabel=[SBITradingUtility getTitleForMarketDataType:currentSelectedObject.marketType];
    TTMarketTableViewCell *currentCell = (TTMarketTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if([currentCell.cellTitleLabel.text rangeOfString:@"Volume"].location != NSNotFound){
        self.marketDetailViewController.isVolumeData = YES;
    }
    else{
        self.marketDetailViewController.isVolumeData = NO;
    }
    self.marketDetailViewController.selectedIndex = indexPath.row;
    [self.navigationController pushViewController:self.marketDetailViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateExchangeType" object:nil];
    // Dispose of any resources that can be recreated.
}

#pragma UISegmentControlDelegate

-(void)segmentControlDidChangeIndex:(id)sender{
    if(self.segmentControl.selectedSegmentIndex == 0){
        //NIFTY...
//        self.group = NSLocalizedStringFromTable(@"Nifty_Title", @"Localizable", @"NIFTY");
        self.group = NSLocalizedStringFromTable(@"NSE_KEY", @"Localizable", @"NSE/NIFTY");
    }
    else{
        //SENSEX...
//        self.group = NSLocalizedStringFromTable(@"Sensex_Title", @"Localizable",@"SENSEX");
        self.group = NSLocalizedStringFromTable(@"BSE_KEY", @"Localizable", @"BSE/BSE_SENSEX");
    }
    self.widgetSegmentControl.selectedSegmentIndex = self.segmentControl.selectedSegmentIndex;
    isEnlargedView = YES;
    [self reloadMarketData];
    
}

#pragma IBActions

-(IBAction)showEnlargedView:(id)sender{
    isEnlargedView = YES;
    NSLog(@"%@",self.navigationController);
    [self reloadMarketData];
    self.view.bounds = CGRectMake(0, 0, 428, 506);
    [self.presentEnlargedViewDelegate marketViewControllerShouldPresentinEnlargedView:self.navigationController];
}

-(IBAction)dismissTheController:(id)sender{
    isEnlargedView = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma NSNotification handler

//-(void)updateExchangeType:(NSNotification *)inNotification{
//    SBITradingUtility *utility = [SBITradingUtility sharedUtility];
//    NSLog(@"************ %@",inNotification.object);
//    int exchangeType = [[inNotification object] intValue];
//    [utility updateExchangeTypeWith:(EExchangeType)exchangeType];
//    self.exchangeType = [utility returnCurrentExchangeType];
//    [self reloadMarketData];
//}

#pragma Diffusion Delegates


-(void)onDelta:(DFTopicMessage *)message{
    
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    
    //handle the market timing data source ...
    
    TTMarketTiming *marketTimingData = [[TTMarketTiming alloc] init];
    marketTimingData = [marketTimingData updateMarketTiming:parsedArray];
    marketTimingData.topic = message.topic;
    
    
    //find the row to be updated...

    TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
       TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
    
    
    if([marketTimingData.topic isEqualToString:NSLocalizedStringFromTable(@"NSE_Subscription_Key", @"Localizable",@"MARKET/NSE/STATUS")]){
        //self.subKeyNSE=marketTimingData.subKey;
         self.subKeyNSE=@"NSE";
        if([marketTimingData.marketStatus isEqualToString:@"open"]){
            self.widgetNseStatus.image=[UIImage imageNamed:@"Greenlight_on"];
            self.nseTimingImage.image=[UIImage imageNamed:@"Greenlight_on"];
        }
        else{
            self.widgetNseStatus.image=[UIImage imageNamed:@"Greenlight_off"];
            self.nseTimingImage.image=[UIImage imageNamed:@"Greenlight_off"];
  
        }
        // subscribe the key got from response
        [diffusionHandler subscribe:[NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",self.subKeyNSE] withContext:self];
    }
    else if([marketTimingData.topic isEqualToString:NSLocalizedStringFromTable(@"BSE_Subscription_Key", @"Localizable",@"MARKET/BSE/STATUS")]){
        //self.subKeyBSE=marketTimingData.subKey;
        self.subKeyBSE=@"BSE";
        if([marketTimingData.marketStatus isEqualToString:@"open"]){
            self.widgetNseStatus.image=[UIImage imageNamed:@"Greenlight_on"];
            self.nseTimingImage.image=[UIImage imageNamed:@"Greenlight_on"];
        }
        else{
            self.widgetNseStatus.image=[UIImage imageNamed:@"Greenlight_off"];
            self.nseTimingImage.image=[UIImage imageNamed:@"Greenlight_off"];
            
        }
        // subscribe the key got from response
        [diffusionHandler subscribe:[NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",self.subKeyBSE] withContext:self];
    }
    else if([marketTimingData.topic isEqualToString:NSLocalizedStringFromTable(@"CD_Subscription_Key", @"Localizable",@"MARKET/CD/STATUS")]){
        //self.subKEyUSDINR=marketTimingData.subKey;
        self.subKEyUSDINR=@"CD";
        if([marketTimingData.marketStatus isEqualToString:@"open"]){
            self.widgetBseStatus.image=[UIImage imageNamed:@"Greenlight_on"];
            self.bseTimingImage.image=[UIImage imageNamed:@"Greenlight_on"];
        }
        else{
            self.widgetCurStatus.image=[UIImage imageNamed:@"Greenlight_off"];
            self.curTimingImage.image=[UIImage imageNamed:@"Greenlight_off"];
            
        }
        // subscribe the key got from response
        [diffusionHandler subscribe:[NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",self.subKEyUSDINR] withContext:self];
        
    }
    else if([marketTimingData.topic isEqualToString:[NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",self.subKeyNSE]]){
        diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
        
        [self updateNSEData:diffusionData];
        
    }
    else if([marketTimingData.topic isEqualToString:[NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",self.subKeyBSE]]){
        [self updateBSEData:diffusionData];
    }
    else if([marketTimingData.topic isEqualToString:[NSString stringWithFormat:@"SYMBOLS/QUOTES/%@",self.subKEyUSDINR]]){
        [self updateUSDINRData:diffusionData];
    }

    
}
// method to update NSE related market data
-(void)updateNSEData:(TTDiffusionData *)diffusionData {
    if(diffusionData!=NULL){
        float priceChange = diffusionData.lastSalePrice-diffusionData.closingPrice;
        if([diffusionData.netPriceChangeIndicator isEqualToString:@""])
            diffusionData.netPriceChangeIndicator = GET_SIGN_INDICATOR(priceChange);
        float percentage = 0.00;
        if(diffusionData.closingPrice != 0)
            percentage = (fabsf(priceChange)/diffusionData.closingPrice)*100;
        if(isnan(percentage)){
            percentage = 0.00;
        }

        self.nseChangeRatio.text=[NSString stringWithFormat:@"%@%.02f%%",diffusionData.netPriceChangeIndicator,fabsf(priceChange)];
        self.nseChangeLabel.text = [NSString stringWithFormat:@"%.02f",priceChange];
         NSLog(@"Sample %@",self.nseChangeRatio.text);
        self.widgetNseRatioLabel.text=self.nseChangeRatio.text;
        self.nseLtpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
        self.widgetNseLtpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
        self.nseVolumeLabel.text=[NSString stringWithFormat:@"%.02f M",diffusionData.volume];
        self.widgetNseVolumeLabel.text=[NSString stringWithFormat:@"%.02f M",diffusionData.volume];
         if([diffusionData.netPriceChangeIndicator isEqualToString:@"+"]){
            self.nseNetChangeIndicator.image=[UIImage imageNamed:@"up_green_arrow_small"];
            self.widgetNseChangeIndicator.image=[UIImage imageNamed:@"up_green_arrow_small"];
        }
        else{
             self.nseNetChangeIndicator.image=[UIImage imageNamed:@"down_red_arrow_small"];
            self.widgetNseChangeIndicator.image=[UIImage imageNamed:@"down_red_arrow_small"];
        }
    }
}

// method to update BSE related market data
-(void)updateBSEData:(TTDiffusionData *)diffusionData {
    if(diffusionData!=NULL){
        float priceChange = diffusionData.lastSalePrice-diffusionData.closingPrice;
        if([diffusionData.netPriceChangeIndicator isEqualToString:@""])
            diffusionData.netPriceChangeIndicator = GET_SIGN_INDICATOR(priceChange);
        
        float percentage = (fabsf(priceChange)/diffusionData.closingPrice)*100;
        if(isnan(percentage)){
            percentage = 0.00;
        }

        self.bseChangeRatio.text=[NSString stringWithFormat:@"%@%.02f",diffusionData.netPriceChangeIndicator,fabsf(priceChange)];
        self.bseChangeLabel.text = [NSString stringWithFormat:@"%.02f",priceChange];
        self.widgetBseratioLabel.text=self.bseChangeRatio.text;
        self.bseLtpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
        self.widgetBseLtpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
        self.bseVolumeLabel.text=[NSString stringWithFormat:@"%.02f M",diffusionData.volume];
        self.widgetBseVolumeLabel.text=[NSString stringWithFormat:@"%.02f M",diffusionData.volume];
         if([diffusionData.netPriceChangeIndicator isEqualToString:@"+"]){
            self.bseNetChangeIndicator.image=[UIImage imageNamed:@"up_green_arrow_small"];
            self.widgetBseChangeIndicator.image=[UIImage imageNamed:@"up_green_arrow_small"];
        }
        else{
            self.bseNetChangeIndicator.image=[UIImage imageNamed:@"down_red_arrow_small"];
            self.widgetBseChangeIndicator.image=[UIImage imageNamed:@"down_red_arrow_small"];
        }
    }

}
//// method to update USDINR related market data
-(void)updateUSDINRData:(TTDiffusionData *)diffusionData{
    if(diffusionData!=NULL){
        float priceChange = diffusionData.lastSalePrice-diffusionData.closingPrice;
        if([diffusionData.netPriceChangeIndicator isEqualToString:@""])
            diffusionData.netPriceChangeIndicator = GET_SIGN_INDICATOR(priceChange);
        float percentage = 0.00;
        if(diffusionData.closingPrice != 0)
            percentage = (fabsf(priceChange)/diffusionData.closingPrice)*100;
        if(isnan(percentage)){
            percentage = 0.00;
        }

        self.curChangeRatio.text=[NSString stringWithFormat:@"%@%.02f%%",diffusionData.netPriceChangeIndicator,fabsf(priceChange)];
       self.curChangeLabel.text = [NSString stringWithFormat:@"%.02f",priceChange];
        self.widgetCurRatioLabel.text=self.curChangeRatio.text;
        self.curLtpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
        self.widgetCurLtpLabel.text=[NSString stringWithFormat:@"%.02f",diffusionData.lastSalePrice];
        self.curVolumeLabel.text=[NSString stringWithFormat:@"%.02f M",diffusionData.volume];
        self.widgetCurVolumeLabel.text=[NSString stringWithFormat:@"%.02f M",diffusionData.volume];
        if([diffusionData.netPriceChangeIndicator isEqualToString:@"+"]){
            self.curNetChangeIndicator.image=[UIImage imageNamed:@"up_green_arrow_small"];
            self.widgetCurChangeIndicator.image=[UIImage imageNamed:@"up_green_arrow_small"];
        }
        else{
            self.curNetChangeIndicator.image=[UIImage imageNamed:@"down_red_arrow_small"];
            self.widgetCurChangeIndicator.image=[UIImage imageNamed:@"down_red_arrow_small"];
        }
    }

}

#pragma NSNotification handler

-(void)updateGlobalSymbolData{
    TTSymbolDetails *symbolDetails = [TTSymbolDetails sharedSymbolDetailsManager];
    
    self.currentSymbol = symbolDetails.symbolData.symbolName;
    
    if(self.currentSymbol){
        TTDiffusionHandler *diffusionHandler = [TTDiffusionHandler sharedDiffusionManager];
        [diffusionHandler subscribe:symbolDetails.symbolData.subscriptionKey withContext:self];
    }
}

-(void)dealloc
{
    NSLog(@"Dealloc Called");
  //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UpdateExchangeType" object:nil];
}
@end
