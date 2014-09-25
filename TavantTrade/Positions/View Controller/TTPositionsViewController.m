//
//  TTPositionsViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 2/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTPositionsViewController.h"
#import "TTPositionTableViewCell.h"
#import "TTUrl.h"
#import "SBITradingNetworkManager.h"
#import "SBITradingUtility.h"
#import "TTPosition.h"
#import "TTConstants.h"

@interface TTPositionsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UITextField *totalTextField;
@property (weak, nonatomic) IBOutlet UITextField *widgetTotalTextField;
@property (weak, nonatomic) IBOutlet UILabel *widgetTotalLabel;
@property(nonatomic,weak)IBOutlet UITableView *positionTableView;
@property(nonatomic,weak)IBOutlet UITableView *widgetPositionTableView;
@property (weak, nonatomic) IBOutlet UILabel *positionHeadingTitle;
@property (weak, nonatomic) IBOutlet UILabel *widgetPositionTitle;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property(nonatomic,strong)NSMutableArray *positionArray;
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property(nonatomic,strong) NSMutableDictionary * positionCellMapping;
@end

BOOL showDummyData = YES;

@implementation TTPositionsViewController

@synthesize isEnlargedView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil

{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadPositionView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _widgetTotalTextField.layer.cornerRadius = 10.0;
    _widgetTotalTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _widgetTotalTextField.layer.borderWidth = 0.5;
    
    _totalTextField.layer.cornerRadius = 10.0;
    _totalTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _totalTextField.layer.borderWidth = 0.5;
    
    //set the heading and labels of the screen ...
    [self.cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    _positionHeadingTitle.text = _widgetPositionTitle.text = NSLocalizedStringFromTable(@"Position_Heading", @"Localizable", @"Positions");
    _totalLabel.text = _widgetTotalLabel.text = NSLocalizedStringFromTable(@"Position_Total", @"Localizable", @"Total Profit/Loss");
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"PositionsTitleBar"];
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"PositionsTitleBar"];

    //set up the font ...
    _positionHeadingTitle.font = SEMI_BOLD_FONT_SIZE(22.0);
    _widgetPositionTitle.font = SEMI_BOLD_FONT_SIZE(19.0);
     _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    _widgetTotalLabel.font = _totalLabel.font = LIGHT_FONT_SIZE(25.0);
    [self reloadPositionView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)subscribeAllKeys{
    TTDiffusionHandler *diffHandler = [TTDiffusionHandler sharedDiffusionManager];
    for(TTPosition *position in _positionArray){
        [diffHandler subscribe:position.subKey withContext:self];
    }
}


-(void)reloadPositionView{
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    NSString *relativePath = [TTUrl positionURL];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[SBITradingUtility plistFilePath]];
    
    NSDictionary *postBodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[dictionary objectForKey:@"requestId"],@"requestId",[dictionary objectForKey:@"clientID"],@"clientID",@"true",@"syncResponse",@"",@"exchange",@"",@"symbol",@"",@"productType",[NSNull null],@"instrumentType", nil];
    
    NSLog(@"Dictionary is %@",postBodyDictionary);
    
    //**************
    _positionArray = [[NSMutableArray alloc] init];
//    showDummyData = NO;
//     NSString *path = [[NSBundle mainBundle] pathForResource:@"PositionJson" ofType:@"txt"];
//     NSString* jsonString = [NSString stringWithContentsOfFile:path
//     encoding:NSUTF8StringEncoding
//     error:NULL];
//     NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
//     options:0 error:NULL];
//     
//     NSLog(@"Position Response is %@",jsonString);
//     NSLog(@"Position Response Json Object is %@",responseArray);
//     
//     for(NSDictionary *order in responseArray){
//     //Create the TTOrder Object for each Order recieved ...
//     TTPosition *recievedPosition = [[TTPosition alloc] initWithDictionary:order];
//     [self.positionArray addObject:recievedPosition];
//     }
//     NSLog(@"Position array ids %@",self.positionArray);
    

    
    [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyDictionary responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        
        NSError *jsonParsingError = nil;
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
//        NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
//        NSLog(@"%@ and status code is %@",jsonString,response);
//        NSLog(@"Position Response is %@",responseArray);
        
        if([data length] > 0){
            
            showDummyData = NO;
//            self.positionArray = [[NSMutableArray alloc] init];
            
            for(NSDictionary *position in responseArray){
                //Create the TTOrder Object for each Order recieved ...
                TTPosition *recievedPosition = [[TTPosition alloc] initWithDictionary:position];
                [_positionArray addObject:recievedPosition];
            }
            NSLog(@"Network call %@",_positionArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self prepareSymbolCellMappingDictionary];
                if(isEnlargedView == YES){
                    [self.positionTableView reloadData];
                    [self.widgetPositionTableView reloadData];
                }
                else
                    [self.widgetPositionTableView reloadData];
                
                [self subscribeAllKeys];
            });
            
            [self calculateTotalProfitLoss];
        }
        else
            showDummyData = YES;
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareSymbolCellMappingDictionary{
    self.positionCellMapping = [[NSMutableDictionary alloc] init];
    int i = 0;
    for(TTPosition *position in _positionArray){
        if(![[self.positionCellMapping allKeys] containsObject:position.subKey]){
            [self.positionCellMapping setValue:[NSIndexPath indexPathForRow:i inSection:0] forKey:position.subKey];
            i++;
        }
    }
}

-(void)configureCell:(TTPositionTableViewCell *)inCell withIndex:(NSIndexPath *)inIndexPath ForTableView:(UITableView *)inTableView{
    
    NSLog(@"Index is %d",inIndexPath.row);
    
    TTPosition *currentPosition = [_positionArray objectAtIndex:inIndexPath.row];
    [self calculateProfitAndPercentage:currentPosition];
    inCell.symbolNameLabel.text = currentPosition.symbol;
    inCell.profitLabel.text = [NSString stringWithFormat:@"%.02f",currentPosition.profit];
    
    UIColor *labelColor;
    
    if(currentPosition.profit > 0)
        labelColor = SYMBOL_PROFIT_LABEL_COLOR;
    else
        labelColor = SYMBOL_LOSS_LABEL_COLOR;
    
    inCell.profitLabel.textColor = inCell.profitPercentageLabel.textColor = labelColor;
    
    if(inTableView == _positionTableView){
        inCell.averageCostLabel.text = [NSString stringWithFormat:@"%.02f",[currentPosition.averagePrice floatValue]];
        inCell.profitPercentageLabel.text = [NSString stringWithFormat:@"%.02f%%",currentPosition.profitPercentage];
        inCell.ltpLabel.text = [NSString stringWithFormat:@"%.02f",currentPosition.lastTradedPrice];
        inCell.quantityLabel.text = [NSString stringWithFormat:@"%d",[currentPosition.totalNetQuantity intValue]];// currentPosition.totalNetQuantity;
        
        
        inCell.typeLabel.text = currentPosition.productType;
    }
    
    //apply the color scheme for profit and loss accordingly ...
    
    
    
    
}


#pragma UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(showDummyData)
//        return 5;
//    else
        return [_positionArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TTPositionTableViewCell *cell;
    
    if(tableView == _widgetPositionTableView){
        static NSString *cellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTPositionTableViewCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTPositionTableViewCell class]]) {
                    cell = (TTPositionTableViewCell *)oneObject;
                    cell.profitLabel.font = cell.symbolNameLabel.font = REGULAR_FONT_SIZE(12.5);
                }
                
            }
            [self configureCell:cell withIndex:indexPath ForTableView:_widgetPositionTableView];
        }
    }
    else if(tableView == _positionTableView){
        static NSString *cellIdentifier = @"EnlargedCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTPositionEnlargedTableViewCell" owner:self options:nil];
            
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTPositionTableViewCell class]]) {
                    cell = (TTPositionTableViewCell *)oneObject;
                    cell.profitLabel.font = cell.profitPercentageLabel.font = cell.ltpLabel.font = cell.averageCostLabel.font = cell.quantityLabel.font = cell.typeLabel.font = REGULAR_FONT_SIZE(12.0);
                    cell.symbolNameLabel.font = REGULAR_FONT_SIZE(14.5);
                }
                
            }
            [self configureCell:cell withIndex:indexPath ForTableView:_positionTableView];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Go to Trade screen ...
//    TTOrder *dataSource = [[TTOrder alloc] init];
//    dataSource.symbolName = _currentSymbol.symbolName;
//    dataSource.subscriptionKey = _currentSymbol.subscriptionKey;
//    dataSource.companyName = _currentSymbol.companyName;
//    TTTradePopoverController *tradeViewController = [[TTTradePopoverController alloc] initWithNibName:@"TTTradePopoverController" bundle:nil];
//    tradeViewController.tradeDataSource = dataSource;
//    tradeViewController.isModifyMode = YES;
//    tradeViewController.previousScreenTitle = @"OC";
//    tradeViewController.previousScreenFrame = self.view.frame;
//    tradeViewController.shouldShowBackButton = YES;
//    [self.navigationController pushViewController:tradeViewController animated:YES];

    
}

#pragma IBAction...

-(IBAction)showEnlargedView:(id)sender{
    isEnlargedView = YES;
    [self.positionViewDelegate positionViewControllerShouldPresentinEnlargedView:self];
}

-(IBAction)dismissTheView:(id)sender{
    isEnlargedView = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma NSNotification handler

-(void)onDelta:(DFTopicMessage *)message{
    
    //find the row to be updated...
    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
    
    NSLog(@"Position Array has %d",[_positionArray count]);
    for(TTPosition *position in _positionArray){
        if([position.subKey isEqualToString:message.topic] && [self.positionCellMapping objectForKey:message.topic]!=NULL){
            //access the index path...
            TTDiffusionData *diffusionData = [[TTDiffusionData alloc] init];
            diffusionData = [diffusionData updateDiffusionDataWith:parsedArray];
            position.lastTradedPrice = diffusionData.lastSalePrice;
            [self.positionTableView beginUpdates];
            [self.positionTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.positionCellMapping valueForKey:message.topic]] withRowAnimation:UITableViewRowAnimationAutomatic];
            NSLog(@"dict is %d",self.positionCellMapping.count);
            NSLog(@"Symbol is %@",[self.positionCellMapping valueForKey:message.topic]);
            
            [self.positionTableView endUpdates];
            
            [self.widgetPositionTableView beginUpdates];
            [self.widgetPositionTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.positionCellMapping valueForKey:message.topic]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.widgetPositionTableView endUpdates];
            break;
        }
    }
    
    if(isEnlargedView == YES){
        [self.widgetPositionTableView reloadData];
        [self.positionTableView reloadData];
    }
    else
        [self.widgetPositionTableView reloadData];
    
    [self calculateTotalProfitLoss];
}

-(void)calculateProfitAndPercentage:(TTPosition *)inPosition{
    
    float lastTradedPrice = inPosition.lastTradedPrice;
    float tempBuyValue = [inPosition.totalBuyAmount floatValue]/[inPosition.totalBuyQty floatValue];
    float tempSellValue = [inPosition.totalSellAmount floatValue]/[inPosition.totalSellQty floatValue];
    float buyDiff = [inPosition.totalBuyQty intValue] - [inPosition.totalSellQty intValue];
    float sellDiff = [inPosition.totalSellQty intValue] - [inPosition.totalBuyQty intValue];
    float investedAmount = 0;
    
    if([inPosition.totalBuyQty intValue] >= [inPosition.totalSellQty intValue]){
        inPosition.profit = (lastTradedPrice - tempBuyValue)*buyDiff;
        investedAmount = buyDiff*tempBuyValue;
    }
    else{
        inPosition.profit = (tempSellValue - lastTradedPrice)*sellDiff;
        investedAmount = sellDiff*tempSellValue;
    }
//    
    float tmpProfitPercent  =inPosition.profit/investedAmount;
    
    NSLog(@"tmpProfitPercent %f  %f  %f",inPosition.profit,investedAmount,tmpProfitPercent);
    if (tmpProfitPercent > 0) {
        inPosition.profitPercentage = tmpProfitPercent*100;
        
        
    }
    else {
        inPosition.profitPercentage = 0.0;
    }
    //inPosition.profitPercentage = (inPosition.profit/investedAmount)*100;
    
}

-(void)calculateTotalProfitLoss{
    float amount = 0;
    UIColor *labelColor;
    for(TTPosition *position in _positionArray){
        amount += position.profit;
    }
    _totalTextField.text = _widgetTotalTextField.text = [NSString stringWithFormat:@"%.02f",amount];
    
    if(amount > 0)
        labelColor = SYMBOL_PROFIT_LABEL_COLOR;
    else
        labelColor = SYMBOL_LOSS_LABEL_COLOR;
    
    _totalTextField.textColor = _widgetTotalTextField.textColor = labelColor;
    
}


@end
