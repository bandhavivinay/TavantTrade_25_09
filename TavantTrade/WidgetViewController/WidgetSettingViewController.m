//
//  WidgetSettingViewController.m
//  TavantTrade
//
//  Created by Gautham S Shetty on 03/02/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "WidgetSettingViewController.h"
#import "TTConstants.h"

@interface WidgetSettingViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, strong) NSMutableArray *widgetsList;

@property (nonatomic, assign) BOOL isEditableMode;

@property (nonatomic, weak) IBOutlet UILabel *widgetSettingsHeadingTitle;
@end

@implementation WidgetSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isEditableMode = NO;
        
        _widgetsList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KWidgetsSetting]];
        
//        if(!_widgetsList)
//        {
//            _widgetsList = [[NSMutableArray alloc] initWithObjects:
//                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eChart],@"Type", @"Charts", @"Name", nil],
//                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eMarket],@"Type", @"Market", @"Name", nil],
//                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eQuotes],@"Type", @"Quotes", @"Name", nil],
//                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eOrders],@"Type", @"Orders", @"Name", nil],
//                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eTrade],@"Type", @"Trade", @"Name", nil],
//                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eAccounts],@"Type", @"Accounts", @"Name", nil],
//                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:ePosition],@"Type", @"Positions", @"Name", nil],
//                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eMessages],@"Type", @"Messages", @"Name", nil],
//                            [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:eOptionChain],@"Type", @"Option Chain", @"Name", nil],
//                            nil];
//            [[NSUserDefaults standardUserDefaults] setObject:_widgetsList forKey:KWidgetsSetting];
//        }
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _widgetSettingsHeadingTitle.text = NSLocalizedStringFromTable(@"Widgets_Settings_Heading", @"Localizable", @"Widgets Settings");
    //set up the font ...
    _widgetSettingsHeadingTitle.font = SEMI_BOLD_FONT_SIZE(22.0);

}

-(void)viewWillAppear:(BOOL)animated
{
    _tableview.editing = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 425, 554);

    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 425, 554);
}

-(IBAction)doneAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:_widgetsList forKey:KWidgetsSetting];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KWidgetsSettingsDidChangeNotification object:nil];
}

-(IBAction)closeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_widgetsList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    
    TTWidgetSettingsCell *cell = nil;
    cell = (TTWidgetSettingsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTWidgetSettingsCell" owner:self options:nil];
        
        for(id oneObject in nib) {
            
            if([oneObject isKindOfClass:[TTWidgetSettingsCell class]]) {
                
                cell = (TTWidgetSettingsCell *)oneObject;
                cell.delegate = self;
            }
        }
    }

    NSMutableDictionary *dict = [_widgetsList objectAtIndex:indexPath.row];
    cell.label.text = [dict objectForKey:@"Name"];
    
    [cell.icon setBackgroundImage:[UIImage imageNamed:@"redio_button_unselect.png"] forState:UIControlStateNormal];
    BOOL shouldShow = [[dict valueForKey:@"ShouldShow"] boolValue];
    if(shouldShow)
    {
        [cell.icon setBackgroundImage:[UIImage imageNamed:@"redio_button_select.png"] forState:UIControlStateNormal];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    id objectToMove = [_widgetsList objectAtIndex:fromIndexPath.row];
    [_widgetsList removeObjectAtIndex:fromIndexPath.row];
    [_widgetsList insertObject:objectToMove atIndex:toIndexPath.row];
    [tableView reloadData];
}

- (void) widgetSettingsCellDidSelect:(TTWidgetSettingsCell *)inCell
{
    NSIndexPath *indexPath = [_tableview indexPathForCell:inCell];
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSMutableDictionary dictionaryWithDictionary:[_widgetsList objectAtIndex:indexPath.row]];
    
    BOOL shouldShow = [[dict valueForKey:@"ShouldShow"] boolValue];
    [dict setValue:[NSNumber numberWithBool:!shouldShow] forKey:@"ShouldShow"];
    [_widgetsList replaceObjectAtIndex:indexPath.row withObject:dict];
//    for(id objects in _widgetsList){
//        NSLog(@"%@",[objects valueForKey:@"Type"]);
//    }
    [_tableview reloadData];
}

@end
