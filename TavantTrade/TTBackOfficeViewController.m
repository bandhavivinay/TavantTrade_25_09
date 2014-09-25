//
//  TTBackOfficeViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 23/06/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTBackOfficeViewController.h"
#import "TTBODetailViewController.h"

@interface TTBackOfficeViewController ()
@property(nonatomic,weak)IBOutlet UITableView *backOfficeTableView;
@property(nonatomic,strong)NSArray *backOfficeLinkArray;
@end

@implementation TTBackOfficeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        NSURLConnection
    }
    return self;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    self.view.superview.bounds = CGRectMake(0, 0, 428, 506);
    self.navigationController.view.bounds = CGRectMake(0, 0, 428, 506);
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 428, 506);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _backOfficeLinkArray = [NSArray arrayWithObjects:@"Client Modification",@"Research Report",@"Demat Report( SSL DP View)",@"Fayde ka Sauda (FKS)",@"Offer For Sale (OFS)",@"Change Password", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dismissViewController:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma TableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_backOfficeLinkArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    cell.textLabel.text = @"Google";
    cell.textLabel.text = [_backOfficeLinkArray objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //open a webview ....
    TTBODetailViewController *backOfficeViewController = [[TTBODetailViewController alloc] initWithNibName:@"TTBODetailViewController" bundle:nil];
    backOfficeViewController.webURL = @"http://www.google.com";
    [self.navigationController pushViewController:backOfficeViewController animated:YES];
    
}


@end
