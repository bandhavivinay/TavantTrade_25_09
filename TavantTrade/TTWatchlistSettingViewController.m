//
//  TTWatchlistSettingViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 6/5/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTWatchlistSettingViewController.h"
#import "TTConstants.h"

@interface TTWatchlistSettingViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UIButton *editButton;
@property (nonatomic, strong) NSMutableArray *watchlistColumnList;

@property (nonatomic, assign) BOOL isEditableMode;
@end

@implementation TTWatchlistSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isEditableMode = NO;
        
        _watchlistColumnList = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:KWatchlistColumnSetting]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    _tableview.editing = YES;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 425, 554);
    
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 425, 554);
}

-(IBAction)doneAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:_watchlistColumnList forKey:KWatchlistColumnSetting];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KWatchlistSettingsDidChangeNotification object:nil];
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
    return [_watchlistColumnList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"WatchlistCell";
    
    TTWatchlistSettingCell *cell = nil;
    cell = (TTWatchlistSettingCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTWatchlistSettingCell" owner:self options:nil];
        
        for(id oneObject in nib) {
            
            if([oneObject isKindOfClass:[TTWatchlistSettingCell class]]) {
                
                cell = (TTWatchlistSettingCell *)oneObject;
                cell.delegate = self;
            }
        }
    }
    
    NSMutableDictionary *dict = [_watchlistColumnList objectAtIndex:indexPath.row];
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
    id objectToMove = [_watchlistColumnList objectAtIndex:fromIndexPath.row];
    [_watchlistColumnList removeObjectAtIndex:fromIndexPath.row];
    [_watchlistColumnList insertObject:objectToMove atIndex:toIndexPath.row];
    [tableView reloadData];
}

- (void) watchlistSettingsCellDidSelect:(TTWatchlistSettingCell *)inCell
{
    NSIndexPath *indexPath = [_tableview indexPathForCell:inCell];
    NSMutableDictionary *dict = (NSMutableDictionary *)[NSMutableDictionary dictionaryWithDictionary:[_watchlistColumnList objectAtIndex:indexPath.row]];
    
    BOOL shouldShow = [[dict valueForKey:@"ShouldShow"] boolValue];
    [dict setValue:[NSNumber numberWithBool:!shouldShow] forKey:@"ShouldShow"];
    [_watchlistColumnList replaceObjectAtIndex:indexPath.row withObject:dict];
    [_tableview reloadData];
}


@end
