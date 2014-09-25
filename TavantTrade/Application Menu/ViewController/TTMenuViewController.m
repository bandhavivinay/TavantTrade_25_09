//
//  TTMenuViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 12/20/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "TTMenuViewController.h"
#import "TTMenuTableViewCell.h"
#import "SBITradingUtility.h"

@interface TTMenuViewController ()
@property(nonatomic,weak)IBOutlet UITableView *menuOptionsTableView;
@property(nonatomic,strong) NSArray *itemLabelArray;
@end

@implementation TTMenuViewController

@synthesize itemLabelArray,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //define menu items array...
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:[SBITradingUtility plistFilePath]];
    
    itemLabelArray = [dict objectForKey:@"MenuItems"];

//    itemLabelArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:eWidgetsMenuItem],[NSNumber numberWithInt:eWatchlistMenuItem],[NSNumber numberWithInt:eNewsMenuItem], [NSNumber numberWithInt:eAccountsMenuItem],[NSNumber numberWithInt:eSettingsMenuItem], nil];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [itemLabelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    TTMenuTableViewCell *cell = nil;
    cell = (TTMenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTMenuTableViewCell" owner:self options:nil];
        
        for(id oneObject in nib) {
            
            if([oneObject isKindOfClass:[TTMenuTableViewCell class]]) {
                
                cell = (TTMenuTableViewCell *)oneObject;
            }
            
        }
        
    }
    NSDictionary *dict = [itemLabelArray objectAtIndex:indexPath.row];
    cell.labelView.text = [ dict objectForKey:@"Name"];
    cell.backgroundColor = [UIColor clearColor];
    NSString *imageName = [ dict objectForKey:@"Image"];
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
    cell.iconView.image = image;
    
//    cell.leftLogoImageView.image = [UIImage imageNamed:[itemLabelArray objectAtIndex:indexPath.row]] ;
//    cell.activeImageView.image = [UIImage imageNamed:[itemLabelArray objectAtIndex:indexPath.row]] ;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate didSelectMenuItem:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (NSString *) titleForMenuItemType:(EApplicationMenuItems) inType
//
//{
//    NSString *title = @"";
//    switch (inType) {
//        case eWidgetsMenuItem:
//        {
//            title = NSLocalizedStringFromTable(@"Widget_Menu", @"Localizable", "Widgets");
//        }
//            break;
//        case eWatchlistMenuItem:
//        {
//            title = NSLocalizedStringFromTable(@"Watchlist_Menu", @"Localizable", "Watchlist");
//        }
//            break;
//        case eNewsMenuItem:
//        {
//            title = NSLocalizedStringFromTable(@"News_Menu", @"Localizable", "News");
//        }
//            break;
//        case eAccountsMenuItem:
//            
//            
//        {
//            title = NSLocalizedStringFromTable(@"Accounts_Menu", @"Localizable", "Account");
//        }
//            break;
//        case eSettingsMenuItem:
//        {
//            title = NSLocalizedStringFromTable(@"Settings_Menu", @"Localizable", "Settings");
//        }
//            break;
//
//        case ePositionsMenuItem:
//        {
//            title = NSLocalizedStringFromTable(@"Position_Heading", @"Localizable", "Positions");
//        }
//            break;
//        default:
//            break;
//    }
//    return title;
//}
@end
