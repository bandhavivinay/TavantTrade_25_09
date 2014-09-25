//
//  TTFeedbackViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 13/06/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTFeedbackViewController.h"
#import "FeedbackCategory.h"
#import "FeedbackSubCategory.h"
#import "TTAppDelegate.h"
#import "TTSOAPRequest.h"
#import "TTConstants.h"
#import "SBITradingUtility.h"
#import "SBITradingNetworkManager.h"
#import "TTUrl.h"
#import "TTAlertView.h"

@interface TTFeedbackViewController ()
@property(nonatomic,strong)FeedbackCategory *selectedCategory;
@property(nonatomic,strong)FeedbackSubCategory *selectedSubCategory;
@property(nonatomic,strong)NSString *selectedQuery;
@property(nonatomic,strong)NSArray *categoryArray;
@property(nonatomic,strong)NSArray *subCategoryArray;
@property(nonatomic,strong)NSArray *queryArray;
@property(nonatomic,strong)UIPopoverController *selectPopoverController;
@property(nonatomic,strong)IBOutlet UIView *popoverView;
@property(nonatomic,weak)IBOutlet UITableView *popoverTableView;
@property(nonatomic,weak)IBOutlet UIButton *categoryButton;
@property(nonatomic,weak)IBOutlet UIButton *subCategoryButton;
@property(nonatomic,weak)IBOutlet UIButton *queryButton;
@property(nonatomic,strong)IBOutlet UIView *existingCustomerView;
@property(nonatomic,strong)IBOutlet UIView *nonExistingCustomerView;
@property(nonatomic,assign)ESOAPRequestType soapRequestType;
@property(nonatomic,assign)EButtonType buttonType;
@property(nonatomic,weak)IBOutlet UISegmentedControl *customerTypeSegmentControl;
@property(nonatomic,strong)NSString *customerID;

@property(nonatomic,strong)NSString *currentDescription;

//Existing Customer IBOutlets ...
@property(nonatomic,weak)IBOutlet UITextField *clientCodeTextField;
@property(nonatomic,weak)IBOutlet UITextField *ECPANNumberTextField;
@property(nonatomic,weak)IBOutlet UITextField *DOBTextField;
@property(nonatomic,weak)IBOutlet UITextField *ECcontactNumberTextField;
@property(nonatomic,weak)IBOutlet UITextField *ECemailIDTextField;
@property(nonatomic,weak)IBOutlet UITextView *ECdescriptionTextView;

//Non-Existing Customer IBOutlets ...
@property(nonatomic,weak)IBOutlet UITextField *customerNameTextField;
@property(nonatomic,weak)IBOutlet UITextField *NECPANNumberTextField;
@property(nonatomic,weak)IBOutlet UITextField *applicationNumberTextField;
@property(nonatomic,weak)IBOutlet UITextField *NECcontactNumberTextField;
@property(nonatomic,weak)IBOutlet UITextField *NECemailIDTextField;
@property(nonatomic,weak)IBOutlet UITextView *NECdescriptionTextView;
- (IBAction)test:(id)sender;

@end

BOOL isCategoryClicked=YES;

@implementation TTFeedbackViewController

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
    //    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _selectedCategory = nil;
    _buttonType = eCategory;
    _soapRequestType = eFeedbackQRC;
    //get the subcategoryArray ...
    TTAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FeedbackCategory" inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entity];
    NSError *error1;
    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:request error:&error1];
    _categoryArray = [NSArray arrayWithArray:results];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[SBITradingUtility plistFilePath]];
    _customerID = [dictionary objectForKey:@"clientID"];
    
    _queryArray = [NSArray arrayWithObjects:[SBITradingUtility getQueryTypeString:eFeedbackQRC],[SBITradingUtility getQueryTypeString:eClientStatus],[SBITradingUtility getQueryTypeString:eLeadStatus], nil];
    
//    NSLog(@"%@",results);
//    FeedbackCategory *category = (FeedbackCategory *)[results objectAtIndex:0];
//    NSLog(@"Category name is %@",category.name);
//    NSLog(@"Subcategory list is %@",[category.subcategory allObjects]);
//
//    for(FeedbackSubCategory *objects in [category.subcategory allObjects]){
//        NSLog(@"subcategory is %@",objects.name);
//    }
//    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissPopOver{
    
    if([self.selectPopoverController isPopoverVisible]){
        [self.selectPopoverController dismissPopoverAnimated:YES];
    }
    self.selectPopoverController = nil;
}

-(void)showPopover:(UIButton *)inButton{
    [self dismissPopOver];
    UIViewController* controller = [[UIViewController alloc] init];
    controller.view = self.popoverView;
    [_popoverTableView reloadData];
    self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self.selectPopoverController setPopoverContentSize:CGSizeMake(self.popoverView.frame.size.width, self.popoverView.frame.size.height)];
    [self.selectPopoverController presentPopoverFromRect:[inButton frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(IBAction)selectCategory:(id)sender{
    _buttonType = eCategory;
    [self showPopover:(UIButton *)sender];
}

-(IBAction)selectSubCategory:(id)sender{
    if(_selectedCategory){
        _buttonType = eSubCategory;
        [self showPopover:(UIButton *)sender];
    }
}

-(IBAction)selectQueryType:(id)sender{
    _buttonType = eQuery;
    [self showPopover:(UIButton *)sender];
}

-(IBAction)segmentControlDidChange:(id)sender
{
    UISegmentedControl *segmentControl = (UISegmentedControl *)sender;
    
    if(segmentControl.selectedSegmentIndex == 0){
        //Existing Customer ...
        _existingCustomerView.hidden = NO;
        _nonExistingCustomerView.hidden = YES;
        _queryButton.hidden = YES;
        _categoryButton.hidden = _subCategoryButton.hidden = NO;
        _soapRequestType = eFeedbackQRC;
    }
    else{
        //Non Existing Customer ...
        _existingCustomerView.hidden = YES;
        _nonExistingCustomerView.hidden = NO;
        _queryButton.hidden = NO;
        _categoryButton.hidden = _subCategoryButton.hidden = YES;
    }
    
}

-(IBAction)dismissController:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sendCustomerFeedback:(id)sender{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    switch (_soapRequestType) {
        case eFeedbackQRC:
        {
            [dictionary setValue:@"ESI64786" forKey:@"CustId"];
            [dictionary setValue:@"adafgaga" forKey:@"CustName"];
            [dictionary setValue:@"64786" forKey:@"ContactNo"];
            [dictionary setValue:@"ESI64786" forKey:@"Email"];
            [dictionary setValue:@"ESI64786" forKey:@"Subject"];
            [dictionary setValue:@"ESI64786" forKey:@"comments"];
            [self makeSOAPRequestWithURL:[TTUrl customerFeedbackUrl] withSOAPMessage:[TTSOAPRequest returnSOAPMessageFor:@"FeedbackQRC" withParameters:dictionary] andType:@"FeedbackQRC"];

        }
            break;
        case eClientStatus:
        {
            [dictionary setValue:@"D321413" forKey:@"refid"];
            [dictionary setValue:@"BABPP1278H" forKey:@"IdentityProof"];
            [self makeSOAPRequestWithURL:[TTUrl customerFeedbackUrl] withSOAPMessage:[TTSOAPRequest returnSOAPMessageFor:@"ClientStatus" withParameters:dictionary] andType:@"ClientStatus"];

        }
            break;
        
        case eLeadStatus:{
            [dictionary setValue:@"9831051183" forKey:@"MobileNo"];
            [self makeSOAPRequestWithURL:[TTUrl customerFeedbackUrl] withSOAPMessage:[TTSOAPRequest returnSOAPMessageFor:@"LeadStatus" withParameters:dictionary] andType:@"LeadStatus"];
        }
            break;
            
        default:
            break;
    }

    
}

-(void)makeSOAPRequestWithURL:(NSString *)inURLString withSOAPMessage:(NSString *)inSOAPMessage andType:(NSString *)inRequestType{
    NSURL *url = [NSURL URLWithString:inURLString];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [inSOAPMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: [NSString stringWithFormat:@"http://tempuri.org/%@",inRequestType]  forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [inSOAPMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        NSData *webData = [NSMutableData data] ;
        NSLog(@"webdata is %@",webData);
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"didReceiveResponse %@",response);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReceiveData %@",responseString);
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    // Don't forget to set the delegate!
    xmlParser.delegate = self;
    
    // Run the parser
    BOOL parsingResult = [xmlParser parse];
    
    if(parsingResult == YES){
        NSLog(@"Parsed Successfully");
    }
    else{
        NSLog(@"Error in parsing");
    }

}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentDescription = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    _currentDescription = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    TTAlertView *alertView = [TTAlertView sharedAlert];
    switch (_soapRequestType) {
        case eFeedbackQRC:
        {
            if([elementName isEqual: @"FeedbackQRCResult"]){
                NSLog(@"_currentDescription is %@",_currentDescription);
                [alertView showAlertWithMessage:_currentDescription];
            }

        }
            break;
            
        case eClientStatus:
        {
            if([elementName isEqual: @"ClientStatusResult"]){
                NSLog(@"_currentDescription is %@",_currentDescription);
                [alertView showAlertWithMessage:_currentDescription];
            }
        }
            break;
        case eLeadStatus:
        {
            if([elementName isEqual: @"ClientName"]){
                NSLog(@"_currentDescription is %@",_currentDescription);
                [alertView showAlertWithMessage:_currentDescription];
            }
        }
            break;
        default:
            break;
    }
    
    
}
#pragma TableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (_buttonType) {
        case eCategory:
           return [_categoryArray count];
        case eSubCategory:
            return [_subCategoryArray count];
        case eQuery:
            return [_queryArray count];
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *labelText = @"";
    
    switch (_buttonType) {
        case eCategory:
        {
            FeedbackCategory *category = [_categoryArray objectAtIndex:indexPath.row];
            labelText = category.name;
        }
            break;
        case eSubCategory:
        {
            FeedbackSubCategory *subcategory = [_subCategoryArray objectAtIndex:indexPath.row];
            labelText = subcategory.name;
        }
            break;
        
        case eQuery:
        {
            labelText = [_queryArray objectAtIndex:indexPath.row];
        }
            break;
        default:
            break;
    }
    
    cell.textLabel.text = labelText;
    
    cell.textLabel.font = [UIFont systemFontOfSize:11.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = (UITableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    cell.textLabel.textColor = [UIColor colorWithRed:46.0/255.0 green:96.0/255.0 blue:254.0/255.0 alpha:1];
    
    switch (_buttonType) {
        case eCategory:
        {
            _selectedCategory = (FeedbackCategory *)[_categoryArray objectAtIndex:indexPath.row];
            //populate the subcategory accordingly ...
            _subCategoryArray = [NSArray arrayWithArray:[_selectedCategory.subcategory allObjects]];
            [_categoryButton setTitle:_selectedCategory.name forState:UIControlStateNormal];
        }
            break;
        case eSubCategory:
        {
            if(_selectedCategory){
                _selectedSubCategory = (FeedbackSubCategory *)[_subCategoryArray objectAtIndex:indexPath.row];
                [_subCategoryButton setTitle:_selectedSubCategory.name forState:UIControlStateNormal];
            }
        }
            break;
            
        case eQuery:
        {
            _selectedQuery = [_queryArray objectAtIndex:indexPath.row];
            if([[_queryArray objectAtIndex:indexPath.row] isEqualToString:[SBITradingUtility getQueryTypeString:eFeedbackQRC]])
                _soapRequestType = eFeedbackQRC;
            else if ([[_queryArray objectAtIndex:indexPath.row] isEqualToString:[SBITradingUtility getQueryTypeString:eClientStatus]])
                _soapRequestType = eClientStatus;
            else
                _soapRequestType = eLeadStatus;
            [_queryButton setTitle:[_queryArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }

    [self dismissPopOver];
}


- (IBAction)test:(id)sender {
}
@end
