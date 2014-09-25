//
//  TTMessagesViewController.m
//  TavantTrade
//
//  Created by TAVANT on 2/26/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTMessagesViewController.h"
#import "TTConstants.h"
#import "TTUrl.h"
#import "SBITradingNetworkManager.h"
#import "TTMessageTableViewCell.h"
#import "TTMessages.h"
#import "SBITradingUtility.h"
@interface TTMessagesViewController ()
@property (nonatomic, weak) IBOutlet UIView *enlargedHeaderView;
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property(nonatomic,strong) NSMutableArray *responseData;
@property(nonatomic,strong)NSMutableDictionary *sectionDictionary;
@property(nonatomic,strong) NSArray *allKeysArray;
@end

BOOL shouldCustomData = YES;
@implementation TTMessagesViewController
@synthesize isEnlargedView,responseData,sectionDictionary,allKeysArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 428, 506);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    _messageWidgetTitleLabel.font = SEMI_BOLD_FONT_SIZE(19.0);
    _messageTitleLabel.font=SEMI_BOLD_FONT_SIZE(22.0);
    responseData=[[NSMutableArray alloc] init];
    sectionDictionary=[[NSMutableDictionary alloc] init];
    allKeysArray=[[NSArray alloc] init];
    [self getAllMessages];
    _enlargedHeaderView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"AdminMessagesTitleBar"];
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"AdminMessagesTitleBar"];
     _messageWidgetTitleLabel.text=NSLocalizedStringFromTable(@"Message_Title", @"Localizable", @"Messages");

    // Do any additional setup after loading the view from its nib.
}
// get all messages from server
-(void)getAllMessages{
    NSString *relativePath = [TTUrl messagesUrl];
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
   [networkManager makeGETRequestWithRelativePath:(NSString *)relativePath responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
       NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
       if(recievedResponse.statusCode != 200){
           NSLog(@"error %d",recievedResponse.statusCode);
       }
       else{
           
       NSError *jsonParsingError = nil;
        NSMutableArray *dateArray=[[NSMutableArray alloc] init];
       NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        NSLog(@"Rec Array %d",responseArray.count);
       if(responseArray && [responseArray isKindOfClass:[NSArray class]]){
           [responseData removeAllObjects];
                for(NSDictionary *messages in responseArray){
               TTMessages *rec = [[TTMessages alloc] initWithMessagesDictionary:messages];
                [dateArray addObject:rec.date];
               [responseData addObject:rec];
                
            }
           shouldCustomData=NO;
       }
       else{
           shouldCustomData=YES;
       }
           // make a sections dictionary
        [self makeDictionaryForSections:dateArray:responseData];
       dispatch_async(dispatch_get_main_queue(), ^{
           if(isEnlargedView == YES){
               [self.messagesTableView reloadData];
           }
           else
               [self.widgetTableView reloadData];
       });
       
   }


}];
}

-(void)makeDictionaryForSections:(NSMutableArray *) dateArray : (NSMutableArray *) response{
    TTMessages *referenceMessage=[response objectAtIndex:0];
    NSMutableArray *messagesArray=[[NSMutableArray alloc] init];
        for(TTMessages *message in response){
         if([message.date isEqualToString:referenceMessage.date]){
             [messagesArray addObject:message];
          }
        else{
              messagesArray = [[NSMutableArray alloc] init];
              referenceMessage=message;
              [messagesArray addObject:referenceMessage];
            }
           [sectionDictionary setObject:messagesArray forKey:referenceMessage.date];
            NSLog(@"The dict values are %@",messagesArray);
        }
           NSLog(@"The dict values are %d",[[sectionDictionary valueForKey:@"07/05/13"] count]);
   
    allKeysArray=[sectionDictionary allKeys];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _messageTitleLabel.text=NSLocalizedStringFromTable(@"Message_Title", @"Localizable", @"Messages");
   
    [_cancelButton setTitle:NSLocalizedStringFromTable(@"Cancel_Button_Title", @"Localizable", @"Cancel") forState:UIControlStateNormal];
    [self getAllMessages];
}



- (IBAction)showEnlargedView:(id)sender {
     isEnlargedView = YES;
     NSLog(@"navigation %@",self.navigationController);
       [self.messagesViewDelagate MessagesViewControllerShouldPresentinEnlargedView:self.navigationController];
}

- (IBAction)dimsissEnlargedView:(id)sender {
    isEnlargedView = NO;
     [self.widgetTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
// customizing tableview section header with specific font and color
-(void)setTableViewSectionHeader:(NSInteger) section{
    _sectionHederLabel=[[UILabel alloc] initWithFrame:CGRectMake(16,0,300,20)];
    _widgetSectionHeaderLabel=[[UILabel alloc] initWithFrame:CGRectMake(16,0,200,18)];
    _widgetSectionHeaderLabel.font=SEMI_BOLD_FONT_SIZE(14.0);
    _widgetSectionHeaderLabel.textColor=[UIColor colorWithRed:(66/255.f) green:(142/255.f) blue:(254/255.f) alpha:1.0f];
    _sectionHederLabel.font=SEMI_BOLD_FONT_SIZE(14.0);
    _sectionHederLabel.textColor=[UIColor colorWithRed:(66/255.f) green:(142/255.f) blue:(254/255.f) alpha:1.0f];
    [_sectionHeader addSubview:_sectionHederLabel];
    [_WidgetSectionHeader addSubview:_widgetSectionHeaderLabel];
    
    if(shouldCustomData){
        
        _sectionHederLabel.text=_widgetSectionHeaderLabel.text=[NSString stringWithFormat:@"Section %d",section];
    }
    else{
        _sectionHederLabel.text=_widgetSectionHeaderLabel.text=[allKeysArray objectAtIndex:section];
    }
}

#pragma tableview delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(shouldCustomData)
        return 1;
    else
    return [sectionDictionary count] ;
//    return 1;
}
-(float) tableView :(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

-(NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection:(NSInteger)section{
    //NSArray *array=[sectionDictionary allKeys];
    if(shouldCustomData)
        return 5;
    else
    return [[sectionDictionary  objectForKey:[allKeysArray objectAtIndex:section]] count];
//        return [responseData count];
}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    _sectionHeader =[[UIView alloc] initWithFrame:CGRectMake(0,0,428,22)];
    _WidgetSectionHeader =[[UIView alloc] initWithFrame:CGRectMake(0,0,327,21)];
    _sectionHeader.backgroundColor=_WidgetSectionHeader.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self setTableViewSectionHeader:section];
    if(isEnlargedView){
        
        return _sectionHeader;
    }
    else{
        
        return _WidgetSectionHeader;
    }
}


-(UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    TTMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTMessageTableViewCell" owner:self options:nil];
        for(id oneObject in nib) {
            
            if([oneObject isKindOfClass:[TTMessageTableViewCell class]]) {
                cell = (TTMessageTableViewCell *)oneObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            }
        
        }
        cell.messageLabel.font = REGULAR_FONT_SIZE(13.0);
        cell.timeLabel.font = REGULAR_FONT_SIZE(13.0);
    
        if( !shouldCustomData){
            TTMessages *object= [[sectionDictionary objectForKey:[allKeysArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
            cell.messageLabel.text=object.messageLine;
            cell.timeLabel.text= object.time;
       
    }
    
    return cell;
}

@end
