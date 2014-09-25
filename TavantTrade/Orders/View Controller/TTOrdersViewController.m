//
//  TTOrdersViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 2/17/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTOrdersViewController.h"
#import "TTOrdersCollectionViewCell.h"
#import "SBITradingNetworkManager.h"
#import "TTOrder.h"
#import "TTSymbolDetails.h"
#import "SBITradingUtility.h"
#import "TTUrl.h"
#import "TTTradePopoverController.h"
#import "TTOrderTableViewCell.h"
#import "TTConstants.h"
#import "TTAlertView.h"

@interface TTOrdersViewController ()<UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property(nonatomic,strong)NSMutableArray *ordersArray;
@property(nonatomic,strong)NSMutableArray *executedOrderArray;
@property(nonatomic,strong)NSMutableArray *openOrderArray;
@property(nonatomic,strong)NSArray *currentOrderArray;
@property(nonatomic,strong)NSArray *actualOrderArray;
@property(nonatomic,weak)IBOutlet UISegmentedControl *statusSegmentControl;
@property(nonatomic,weak)IBOutlet UITableView *orderTableView;
@property(nonatomic,strong)UIPopoverController *orderOptionPopOverController;
@property(nonatomic,strong)UIViewController *orderOptionViewController;
@property(nonatomic,weak)IBOutlet UIView *orderOptionView;
@property(nonatomic,weak)TTOrder *currentSelectedOrder;
@property(nonatomic,strong)TTTradePopoverController *tradeViewController;
@property(nonatomic,strong)IBOutlet UISearchBar *orderSearchBar;
@property(nonatomic,strong)UIPopoverController *searchPopoverController;
@property(nonatomic,strong)IBOutlet UIView *popoverView;
@property(nonatomic,weak)IBOutlet UITableView *popoverTableView;
@property(nonatomic,strong)NSArray *orderSearchFilterArray;
@property(nonatomic,strong)NSArray *orderSearchFilterEnumArray;
@property(nonatomic,strong)TTOrderSearchTableCell *previousSelectedCell;
@property(nonatomic,assign)ESearchFilterItems searchFilterType;
@property(nonatomic,strong)NSString *currentPredicateString;
@property(nonatomic,weak)IBOutlet UIDatePicker *orderDatePicker;
@property(nonatomic,weak)IBOutlet UIView *datePickerView;
@property(nonatomic,weak)IBOutlet UIButton *fromDateButton;
@property(nonatomic,weak)IBOutlet UIButton *toDateButton;
@property(nonatomic,strong)UIButton *currentSelectedButton;


-(IBAction)didSelectSegment:(id)sender;
-(IBAction)showEnlargedView:(id)sender;
@end

@implementation TTOrdersViewController

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
    self.view.superview.bounds = CGRectMake(0, 0, 1008, 650);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderBook) name:@"RefreshOrderBook" object:nil];
    
    _orderDatePicker.backgroundColor = [UIColor whiteColor];
    _datePickerView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _datePickerView.layer.borderWidth = 2.0;
    
    //set the initial search parameter ...
    
    _searchFilterType = 0;
    _currentPredicateString = [self getThePredicateString:_searchFilterType];
    
//    _orderDatePicker.alpha = 0.7;
//    self.view.alpha = 0.7;
    //set up the filter parameter array ...
    _orderSearchFilterArray = [NSArray arrayWithObjects:@"Company Name",@"Exchange Type",@"Instrument Type",@"Date Range",@"Product Type",@"Side", nil];
    _orderSearchFilterEnumArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:eCompanyName],[NSNumber numberWithInt:eExchange],[NSNumber numberWithInt:eInstrumentType],[NSNumber numberWithInt:eDateRange],[NSNumber numberWithInt:eProductType],[NSNumber numberWithInt:eSide], nil];
    
    //set title for the segment control ...
    
    [self.statusSegmentControl setTitle:NSLocalizedStringFromTable(@"All_Order", @"Localizable", @"All") forSegmentAtIndex:0];
    [self.statusSegmentControl setTitle:NSLocalizedStringFromTable(@"Executed_Order", @"Localizable", @"Executed") forSegmentAtIndex:1];
   // [self.statusSegmentControl setTitle:NSLocalizedStringFromTable(@"Open_Order", @"Localizable", @"Open") forSegmentAtIndex:2];
    
     self.orderTitleLabel.text = self.orderWidgetTitleLabel.text = NSLocalizedStringFromTable(@"Order_Title", @"Localizable", @"Order");
    [self.cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"OrderTitleBar"];
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"OrderTitleBar"];

    //set the font
    
    _orderWidgetTitleLabel.font = SEMI_BOLD_FONT_SIZE(19.0);
    _orderTitleLabel.font = SEMI_BOLD_FONT_SIZE(22.0);
    _cancelButton.titleLabel.font = REGULAR_FONT_SIZE(16.5);
    
    [self.orderDatePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:SEMI_BOLD_FONT_SIZE(16.0)
                                                                 forKey:NSFontAttributeName];
    
    [self.statusSegmentControl setTitleTextAttributes:attributes
                                   forState:UIControlStateNormal];
    
    self.statusSegmentControl.tintColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    
    self.ordersCollectionView.backgroundColor = [UIColor clearColor];
    isEnlargedView = NO;
   
    self.orderStatus = eAll;
    
    self.orderOptionViewController = [[UIViewController alloc] init];
    self.orderOptionViewController.view = self.orderOptionView;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    [self.ordersCollectionView addGestureRecognizer:lpgr];
    
//    UILongPressGestureRecognizer *searchOrderLongPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleSearchBarLongPress:)];
//    searchOrderLongPressGesture.delegate = self;
//    [self.orderSearchBar addGestureRecognizer:searchOrderLongPressGesture];
    
    
    [self hideDatePicker];
    
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self
                                   selector:@selector(refreshOrderBook) userInfo:nil repeats:NO];
    
        // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    NSLog(@"%@",NSStringFromCGRect(self.navigationController.view.frame));
    [self refreshOrderBook];
    [self hideDatePicker];
}

-(void)refreshOrderBook{
    self.ordersArray = [[NSMutableArray alloc] init];
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    NSString *relativePath = [TTUrl orderBookURL];

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[SBITradingUtility plistFilePath]];
    
    NSDictionary *postBodyDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[dictionary objectForKey:@"requestId"],@"requestId",[dictionary objectForKey:@"clientID"],@"clientID",@"true",@"syncResponse", nil];
    
    NSLog(@"Dictionary is %@",postBodyDictionary);
    
     //Testing purpose ...
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"OrderJson" ofType:@"txt"];
//    NSString* jsonString = [NSString stringWithContentsOfFile:path
//                                                  encoding:NSUTF8StringEncoding
//                                                     error:NULL];
//    NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
//                                                          options:0 error:NULL];
//
//    NSLog(@"Order Response is %@",jsonString);
//    NSLog(@"Order Response Json Object is %@",responseArray);
//    
//    for(NSDictionary *order in responseArray){
//        //Create the TTOrder Object for each Order recieved ...
//        TTOrder *recievedOrder = [[TTOrder alloc] initWithOrderDictionary:order];
//        [self.ordersArray addObject:recievedOrder];
//    }
//    NSLog(@"Order array ids %@",self.ordersArray);
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if(isEnlargedView == YES){
//            [self populateCurrentOrderArray];
//            [self.ordersCollectionView reloadData];
//            [self.orderTableView reloadData];
//        }
//        else
//            [self.orderTableView reloadData];
//    });

    
    [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyDictionary responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {

        NSError *jsonParsingError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        
        if([data length] > 0){
            
            NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
            
            //Testing purpose ...

            
            NSLog(@"%@ and status code is %@",jsonString,response);
            NSLog(@"Order Response is %@",responseDictionary);

            NSError *jsonParsingError = nil;
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            for(NSDictionary *order in responseArray){
                //Create the TTOrder Object for each Order recieved ...
                TTOrder *recievedOrder = [[TTOrder alloc] initWithOrderDictionary:order];
                [self.ordersArray addObject:recievedOrder];
            }
            NSLog(@"Order array ids %@",self.ordersArray);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isEnlargedView == YES){
                    [self populateCurrentOrderArray];
                    [self.ordersCollectionView reloadData];
                    [self.orderTableView reloadData];
                }
                else
                    [self.orderTableView reloadData];
            });
            
        }
        
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
//    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
//    [_currentSelectedButton setTitle:strDate forState:UIControlStateNormal];
//    [self filterOrderArray];
}

-(void)prepareExecutedOrderArray{
    self.executedOrderArray = [[NSMutableArray alloc] init];
    for(TTOrder *order in self.ordersArray){
        if([order.status caseInsensitiveCompare:@"Complete"] == NSOrderedSame)
            [self.executedOrderArray addObject:order];
    }
}

-(void)prepareOpenOrderArray{
    self.openOrderArray = [[NSMutableArray alloc] init];
    for(TTOrder *order in self.ordersArray){
        if([order.status caseInsensitiveCompare:@"Open"] == NSOrderedSame)
            [self.openOrderArray addObject:order];
    }
}

-(void)dismissPopOver{
    
    if([self.searchPopoverController isPopoverVisible]){
        [self.searchPopoverController dismissPopoverAnimated:YES];
    }
    self.searchPopoverController = nil;
}

-(void)showPopover:(UIButton *)inButton{
    [self dismissPopOver];
    UIViewController* controller = [[UIViewController alloc] init];
    controller.view = self.popoverView;
    [_popoverTableView reloadData];
    self.searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self.searchPopoverController setPopoverContentSize:CGSizeMake(self.popoverView.frame.size.width, self.popoverView.frame.size.height)];
    [self.searchPopoverController presentPopoverFromRect:CGRectMake(inButton.frame.origin.x, inButton.frame.origin.y+55, inButton.frame.size.width, inButton.frame.size.height) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma UIGesture Method

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        CGPoint p = [gestureRecognizer locationInView:self.ordersCollectionView];
        
        NSIndexPath *indexPath = [self.ordersCollectionView indexPathForItemAtPoint:p];
        
        //check whether the order is in open state ...
        
        TTOrder *order = [self.currentOrderArray objectAtIndex:indexPath.row];
        if([order.status caseInsensitiveCompare:@"Complete"] != NSOrderedSame && [order.status caseInsensitiveCompare:@"Rejected"] != NSOrderedSame && [order.status caseInsensitiveCompare:@"Cancelled"] != NSOrderedSame){
            if (indexPath == nil){
                NSLog(@"couldn't find any cell at this point");
                self.currentSelectedOrder = nil;
            } else {
                
                //dismiss the popover if already presented ...
                self.currentSelectedOrder = order;
                if([self.orderOptionPopOverController isPopoverVisible])
                    [self.orderOptionPopOverController dismissPopoverAnimated:YES];
                
                //show the menu ...
                
                self.orderOptionPopOverController = [[UIPopoverController alloc] initWithContentViewController:self.orderOptionViewController];
                [self.orderOptionPopOverController setPopoverContentSize:CGSizeMake(self.orderOptionViewController.view.frame.size.width, self.orderOptionViewController.view.frame.size.height)];
                
                //            CGRect modifiedFrame = CGRectMake(selectedCell.frame.origin.x, selectedCell.frame.origin.y - 131, selectedCell.frame.size.width, selectedCell.frame.size.height);
                CGRect modifiedFrame = CGRectMake(p.x, p.y, 20,20);
                
                
                CGRect frame = [self.view convertRect:modifiedFrame fromView:self.ordersCollectionView];
                
                
                [self.orderOptionPopOverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight | UIPopoverArrowDirectionDown | UIPopoverArrowDirectionUp animated:YES];
                
            }
        }

    }
}



//-(void)handleSearchBarLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
//    [self showPopover];
//}


#pragma Diffusion Delegate Methods

-(void)onDelta:(DFTopicMessage *)message{
    NSLog(@"Orders ...... %@",message);
}

-(void)filterOrderArray{
    NSString *fromDateString = _fromDateButton.titleLabel.text;
    NSString *toDataString = _toDateButton.titleLabel.text;
    if(![fromDateString isEqualToString:@"From"] && ![toDataString isEqualToString:@"To"]){
        NSDate *fromDate = [SBITradingUtility returnDateWithoutTimeFrom:fromDateString];
        NSDate *toDate = [SBITradingUtility returnDateWithoutTimeFrom:toDataString];
        NSPredicate *dateRangePredicate = [NSPredicate predicateWithFormat:@"SELF.confirmDate >= %@ AND SELF.confirmDate < %@",fromDate,[toDate dateByAddingTimeInterval:60*60*24]];
        _currentOrderArray = [_actualOrderArray filteredArrayUsingPredicate:dateRangePredicate];
        [_ordersCollectionView reloadData];
    }
}



#pragma mark- Date Picker Methods

-(void)showDatePicker {
    
    
    NSLog(@"FRAMMMMMMM %@",NSStringFromCGRect(_datePickerView.frame));
    CGRect frame = _datePickerView.frame;
    if (frame.origin.y >= self.view.frame.size.height) {
        
        frame.origin.y  = self.view.frame.size.height - frame.size.height;
    }
    else {
        frame.origin.y = 338.0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _datePickerView.frame  =  frame;
    }];
}

-(void)hideDatePicker {
    
    CGRect frame = _datePickerView.frame;
    frame.origin.y  = 592.0;//self.view.frame.size.height;
    _datePickerView.frame  =  frame;
}




#pragma mark- IBAction methods

-(IBAction)doneButtonClicked:(id)sender{
    [self hideDatePicker];
    _datePickerView.hidden = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:_orderDatePicker.date];
    if([_currentSelectedButton isEqual:_fromDateButton])
        [_fromDateButton setTitle:strDate forState:UIControlStateNormal];
    else
        [_toDateButton setTitle:strDate forState:UIControlStateNormal];
    NSLog(@"%@",_fromDateButton.titleLabel.text);
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(filterOrderArray) userInfo:nil repeats:NO];
}

-(IBAction)selectFromDate:(id)sender{
    [self showDatePicker];
    _currentSelectedButton = (UIButton *)sender;
    _datePickerView.hidden = NO;
//    [self filterOrderArray];
}

-(IBAction)selectToDate:(id)sender{
    [self showDatePicker];
     _currentSelectedButton = (UIButton *)sender;
    _datePickerView.hidden = NO;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
//    NSString *strDate = [dateFormatter stringFromDate:_orderDatePicker.date];
//    [_currentSelectedButton setTitle:strDate forState:UIControlStateNormal];
//    [self filterOrderArray];
}

-(IBAction)didSelectSegment:(id)sender{
    [self hideDatePicker];
    if(self.statusSegmentControl.selectedSegmentIndex == 0){
        self.orderStatus = eAll;
    }
    else if(self.statusSegmentControl.selectedSegmentIndex == 1){
        [self prepareExecutedOrderArray];
        self.orderStatus = eExecuted;
    }
//    else{
//        [self prepareOpenOrderArray];
//        self.orderStatus = eOpen;
//    }
    [self populateCurrentOrderArray];
    [self.ordersCollectionView reloadData];
    
}

-(IBAction)showSearchFilters:(id)sender{
    [self hideDatePicker];
   // dispatch_async(dispatch_get_main_queue(), ^{
    
         [_orderSearchBar resignFirstResponder];
 //   });
    
   
    [self showPopover:(UIButton *)sender];
}

-(IBAction)modifySelectedOrder:(id)sender{
    
    [self hideDatePicker];
    //dismiss the popover if already presented ...
    if([self.orderOptionPopOverController isPopoverVisible])
        [self.orderOptionPopOverController dismissPopoverAnimated:YES];
    
    //open the trade screen ...
    
    self.tradeViewController = [[TTTradePopoverController alloc] initWithNibName:@"TTTradePopoverController" bundle:nil];
    self.tradeViewController.isModifyMode = YES;
    self.tradeViewController.tradeDataSource = self.currentSelectedOrder;
    
    
    
    [SBITradingUtility getSymbolDataForSymbolName:self.currentSelectedOrder.symbolData.symbolName withExchange:self.currentSelectedOrder.exchangeType andInstrumentType:self.currentSelectedOrder.instrumentType:^(TTSymbolData *recievedSymbolData, NSError *error) {
        
        self.currentSelectedOrder.symbolData = recievedSymbolData;

       // [self dismissTheController:nil];
       // [self performSelector:@selector(loadTradeView) withObject:nil afterDelay:1];
        [self dismissViewControllerAnimated:YES completion:^{
            isEnlargedView = NO;
            UINavigationController *tradeNavigationController = [[UINavigationController alloc] initWithRootViewController:self.tradeViewController];
            [self.ttOrderViewDelegate orderViewControllerShouldPresentinEnlargedView:tradeNavigationController];
        }];
    }];
    
}

- (void)loadTradeView
{
    UINavigationController *tradeNavigationController = [[UINavigationController alloc] initWithRootViewController:self.tradeViewController];
    [self.ttOrderViewDelegate orderViewControllerShouldPresentinEnlargedView:tradeNavigationController];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1000){
        switch(buttonIndex){
            case 0:{
                [self cancelOrder];
                break;
            }
            case 1 :{
                break;
            }
                
        }
    }
}


-(IBAction)deleteCurrentorder:(id)sender{
    
    [self hideDatePicker];
    //dismiss the popover if already presented ...
    if([self.orderOptionPopOverController isPopoverVisible])
        [self.orderOptionPopOverController dismissPopoverAnimated:YES];
    
    
    //show user a confirmation before cancelling the order ...
    
    UIAlertView *cancelAlert = [[UIAlertView alloc] initWithTitle:@"Cancel Order"
                                                     message:@"Do you want to cancel this order ?"
                                                    delegate:self
                                           cancelButtonTitle:@"Yes"
                                           otherButtonTitles:@"No",nil];
    cancelAlert.tag = 1000;
    [cancelAlert show];
    
    
    //server request ....
    
    // Get the symbol details ...
    
    
}

-(void)cancelOrder{
    [SBITradingUtility getSymbolDataForSymbolName:self.currentSelectedOrder.symbolData.symbolName withExchange:self.currentSelectedOrder.exchangeType andInstrumentType:self.currentSelectedOrder.instrumentType:^(TTSymbolData *recievedSymbolData, NSError *error) {
        
        self.currentSelectedOrder.symbolData = recievedSymbolData;
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        NSString *relativePath = [TTUrl cancelOrderURL];
        
        NSMutableDictionary *postBodyDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.currentSelectedOrder.orderID,@"nestOrdNumber",@"TEST",@"clientID",@"",@"exchAlgoId",@"",@"exchAlgoSeqNum",@"",@"origClOrdID",self.currentSelectedOrder.symbolData.symbolToken,@"securityID", nil];
        
        if([self.currentSelectedOrder.isAmo caseInsensitiveCompare:@"true"] == NSOrderedSame){
            [postBodyDictionary setValue:self.currentSelectedOrder.status forKey:@"status"];
        }
        [postBodyDictionary setValue:self.currentSelectedOrder.isAmo forKey:@"amo"];
        
        NSLog(@"Dictionary is %@",postBodyDictionary);
        
        [networkManager makePOSTRequestWithRelativePath:relativePath withPostBody:postBodyDictionary responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            
            NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
            __block TTAlertView *alertView = [TTAlertView sharedAlert];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([recievedResponse statusCode] == 200){
                    
                    [alertView showAlertWithMessage:@"Order Cancelled Successfully"];
                    [self refreshOrderBook];
                }
                else{
                    [alertView showAlertWithMessage:@"Your request couldn't be processed successfully"];
                }
            });
            
            
            
        }];
    }];

}

-(IBAction)showEnlargedView:(id)sender{
    [self hideDatePicker];
    isEnlargedView = YES;
    [self.ttOrderViewDelegate orderViewControllerShouldPresentinEnlargedView:self];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}

- (IBAction)dismissTheController:(id)sender {
    isEnlargedView = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _orderTableView)
        return [self.ordersArray count];
    else
        return [_orderSearchFilterArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _orderTableView){
        static NSString *cellIdentifier = @"Cell";
        TTOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTOrderTableViewCell" owner:self options:nil];
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTOrderTableViewCell class]]) {
                    cell = (TTOrderTableViewCell *)oneObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
            }
            
        }
        
        //configure the cell ...
        
        TTOrder *currentOrder = [self.ordersArray objectAtIndex:indexPath.row];
        cell.symbolNameLabel.text = currentOrder.symbolData.tradeSymbolName;
        cell.orderTypeLabel.text = currentOrder.transactionType;
        cell.statusLabel.text = currentOrder.status;
        if([currentOrder.status caseInsensitiveCompare:@"Complete"] == NSOrderedSame)
            cell.statusLabel.textColor = SYMBOL_PROFIT_LABEL_COLOR;
        else if([currentOrder.status caseInsensitiveCompare:@"Rejected"] == NSOrderedSame)
            cell.statusLabel.textColor = [UIColor redColor];
        else{
            cell.statusLabel.text = @"Open";
            cell.statusLabel.textColor = [UIColor orangeColor];
        }
        cell.orderPriceLabel.text = [NSString stringWithFormat:@"%.2f",currentOrder.priceToFill];
        
        return cell;
    }
    else {
        static NSString *cellIdentifier = @"SearchCell";
        TTOrderSearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTOrderSearchTableCell" owner:self options:nil];
            for(id oneObject in nib) {
                
                if([oneObject isKindOfClass:[TTOrderSearchTableCell class]]) {
                    cell = (TTOrderSearchTableCell *)oneObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.orderSearchDelegate = self;
                }
                
            }
            
        }
        
        //Configure the cell ...
        NSLog(@"%d",[[_orderSearchFilterEnumArray objectAtIndex:indexPath.row] intValue]);
        cell.currentSearchParameter = (ESearchFilterItems)[[_orderSearchFilterEnumArray objectAtIndex:indexPath.row] intValue];
        cell.filterParameterLabel.text = [_orderSearchFilterArray objectAtIndex:indexPath.row];
        //Show the selected state ...
        if(cell.currentSearchParameter == _searchFilterType){
            _previousSelectedCell = cell;
            cell.isSelected = YES;
        }
        else{
            cell.isSelected = NO;
            
        }
        return cell;
    }
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(tableView == _popoverTableView){
//        
//    }
//}

-(NSString *)getThePredicateString:(ESearchFilterItems)inType{
    _fromDateButton.hidden = YES;
    _toDateButton.hidden = YES;
    _orderSearchBar.hidden = NO;
    NSString *predicateString = @"";
    switch (inType) {
        case eCompanyName:
            predicateString = @"SELF.symbolData.symbolName BEGINSWITH[cd]";
            break;
        case eExchange:
            predicateString = @"exchangeType BEGINSWITH[cd]";
            break;
        case eInstrumentType:
            predicateString = @"instrumentType BEGINSWITH[cd]";
            break;
        case eProductType:
            predicateString = @"productType BEGINSWITH[cd]";
            break;
        case eDateRange:{
            _fromDateButton.hidden = NO;
            _toDateButton.hidden = NO;
            _orderSearchBar.hidden = YES;
            predicateString = @"exchangeType BEGINSWITH[cd]";
        }
            break;
        case eSide:{
            predicateString = @"transactionType BEGINSWITH[cd]";
        }
            break;
        default:
            break;
    }
    return predicateString;
}

#pragma Delegates 

-(void)didSelectOrderSearchParameter:(TTOrderSearchTableCell *)inSearchTableCell{
    if(_previousSelectedCell == nil)
        _previousSelectedCell = inSearchTableCell;
    else{
        //deselect the previous cell ...
        _previousSelectedCell.isSelected = NO;
        _previousSelectedCell = inSearchTableCell;
    }
    inSearchTableCell.isSelected = YES;
    _currentOrderArray = _actualOrderArray;
    [_ordersCollectionView reloadData];
    _searchFilterType = inSearchTableCell.currentSearchParameter;
    _currentPredicateString = [self getThePredicateString:_searchFilterType];
    
}

#pragma mark- UISearchBar Delegate Methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"Search text ************* %@",searchText);
    if([searchText length] > 0){
        //reload the table with the new filtered array ...
        NSString *predicateString = [NSString stringWithFormat: @"%@ \"%@\"",_currentPredicateString,searchText];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        _currentOrderArray = [_actualOrderArray filteredArrayUsingPredicate:predicate];
    }
    else
        _currentOrderArray = _actualOrderArray;

    [_ordersCollectionView reloadData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    _actualOrderArray = _currentOrderArray;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    _currentOrderArray = _actualOrderArray;
//    [_ordersCollectionView reloadData];
   [_orderSearchBar resignFirstResponder];
    
//    [searchBar performSelector:@selector(resignFirstResponder)
//                    withObject:nil
//                    afterDelay:1];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
//
//-(void)resignKeyboardOfSerachBar {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_orderSearchBar resignFirstResponder];
//        [self.view endEditing:YES];
//    });
//}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    
    [_orderSearchBar resignFirstResponder];
//    [searchBar performSelector:@selector(resignFirstResponder)
//                    withObject:nil
//                    afterDelay:1];
    return YES;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    _currentOrderArray = _actualOrderArray;
    [_ordersCollectionView reloadData];
    [searchBar resignFirstResponder];
}

-(void)populateCurrentOrderArray{
    switch (self.orderStatus) {
        case eOpen:
            self.currentOrderArray = self.openOrderArray;
            break;
        case eExecuted:
            self.currentOrderArray = self.executedOrderArray;
            break;
            
        default:
            self.currentOrderArray = self.ordersArray;
            break;
    }
     _actualOrderArray = _currentOrderArray;

}

#pragma UICollectionViewDelegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.currentOrderArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"OrderCell";
    UINib *cellNib = [UINib nibWithNibName:@"TTOrdersCollectionViewCell" bundle:nil];
    [self.ordersCollectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    TTOrdersCollectionViewCell *cell = (TTOrdersCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    TTOrder *currentOrder = [self.currentOrderArray objectAtIndex:indexPath.row];
    cell.dataSource = currentOrder;
    [cell configureCell];
    return cell;
    
}


@end
