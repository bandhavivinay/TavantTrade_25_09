//
//  TTNewsViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 1/31/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTNewsViewController.h"
#import "TTNewsData.h"
#import "SBITradingNetworkManager.h"
#import "TTUrl.h"
#import "SBITradingUtility.h"
#import "TTNewsCollectionViewCell.h"

@interface TTNewsViewController ()
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property(nonatomic,strong)NSMutableArray *newsArray;
@property(nonatomic,weak)IBOutlet UIView *navView;
@property(nonatomic,strong)TTNewsDetailViewController *newsDetailViewController;
@property(nonatomic,weak)IBOutlet UICollectionView *newsCollectionView;
@end

@implementation TTNewsViewController

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
    
    //set news heading ...
    _newsTitleLabel.text = NSLocalizedStringFromTable(@"News_Menu", @"Localizable", @"News");
    _newsTitleLabel.font = SEMI_BOLD_FONT_SIZE(19.0);
    //add swipe gesture on navView...
    _headerView.backgroundColor = [SBITradingUtility getColorForComponentKey:@"NewsTitleBar"];

    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(navigateToPreviousScreen:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.navView addGestureRecognizer:swipeGestureRecognizer];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self getTheNewsData];
    // Do any additional setup after loading the view from its nib.
}

-(void)prepareDummyNewsArray{
    for(int i = 0; i < 10; i++){
        NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:i],@"serialNumber",[NSString stringWithFormat:@"IPL 7: Bowlers will win us matches %d",i],@"heading",[NSString stringWithFormat:@"When KKR picked their players in the February auctions, there seemed to be a distinct design. Umesh Yadav, Morne Morkel and Pat Cummins did one thing very well - bowl at express speed. Gambhir feels that the quickies will play a massive role if KKR have to do well this year, irrespective of where the tournament is being played.  %d",i],@"arttext",@"01-01-2014 15:35",@"date",[NSString stringWithFormat:@"Don't be surprised if Kolkata Knight Riders unleash a battery of quick bowlers on defending Indian Premier League champions Mumbai Indians when the seventh edition of the T20 tournament starts in Abu Dhabi on Wednesday.  %d",i],@"sectionName", nil];
        TTNewsData *newsData = [[TTNewsData alloc] initWithDictionary:dictionary];
        NSLog(@"News data is %@",newsData);
        [self.newsArray addObject:newsData];
    }
    [self.newsCollectionView reloadData];
}

-(void)navigateToPreviousScreen:(UISwipeGestureRecognizer *)recognizer{
    [self.newsDelegate didNavigateToWatchListScreen];
}

-(void)getTheNewsData{
    
    //request for top 15 news ...
    
    int numberOfNewsToBeFetched = 15;
    
    NSString *relativePathString = [NSString stringWithFormat:@"%@/%d",[TTUrl marketNewsURL],numberOfNewsToBeFetched];
    NSLog(@"Request URL is %@",relativePathString);
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
//        NSLog(@"array is %@",self.newsArray);
        self.newsArray = [[NSMutableArray alloc] init];
        NSError *jsonParsingError = nil;
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        if(responseArray){
            for(id newsData in responseArray){
                TTNewsData *currentNewsData = [[TTNewsData alloc] initWithDictionary:newsData];
                [self.newsArray addObject:currentNewsData];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if([self.newsArray count] > 0){
                [self.newsCollectionView reloadData];
                //perform second network call to get the description of each news ...
                [self populateTheDescriptionField];
            }
            else
                [self prepareDummyNewsArray];
        });

    }];
}


-(void)populateTheDescriptionField{
    
    for(TTNewsData *news in self.newsArray){
        NSString *relativePathString = [NSString stringWithFormat:@"%@/%@",[TTUrl marketnewsDetailsURL],news.serialNumber];
        NSLog(@"Request URL is %@",relativePathString);
        SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
        [networkManager makeGETRequestWithRelativePath:relativePathString responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
            NSError *jsonParsingError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            if(responseDictionary != NULL)
                news.description = [responseDictionary objectForKey:@"arttext"];

//            [self.newsCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathWithIndex:[self.newsArray indexOfObject:news]]]];
            [self.newsCollectionView reloadData];
//            [self.newsCollectionView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathWithIndex:[self.newsArray indexOfObject:news]]] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UICollectionViewDelegate methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.newsArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"NewsCell";
    UINib *cellNib = [UINib nibWithNibName:@"TTNewsCollectionViewCell" bundle:nil];
    [self.newsCollectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    TTNewsCollectionViewCell *cell = (TTNewsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    TTNewsData *currentNews = [self.newsArray objectAtIndex:indexPath.row];
//    if(indexPath.row % 2 == 0){
//        //set background color of the cell to white...
//        cell.backgroundColor = [UIColor whiteColor];
//    }
//    else{
//        //set background color of the cell to gray...
//        cell.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1];
//    }
    cell.dataSource = currentNews;
    [cell configureCell];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.newsDetailViewController == nil){
        self.newsDetailViewController = [[TTNewsDetailViewController alloc] initWithNibName:@"TTNewsDetailViewController" bundle:nil];
        self.newsDetailViewController.ttNewsDetailDelegate = self;
    }
    self.newsDetailViewController.dataSource = self.newsArray;
    self.newsDetailViewController.currentIndex = indexPath.row;
    //    [self.navigationController pushViewController:self.newsDetailViewController animated:YES];
    self.newsDetailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:self.newsDetailViewController  animated:YES completion:nil];
}


//#pragma UITableView Delegates
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [self.newsArray count];
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString *cellIdentifier = @"Cell";
//    TTNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (cell == nil) {
//        
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TTNewsTableViewCell" owner:self options:nil];
//
//        for(id oneObject in nib) {
//            
//            if([oneObject isKindOfClass:[TTNewsTableViewCell class]]) {
//                cell = (TTNewsTableViewCell *)oneObject;
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                cell.headingLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:15.0f];
//                cell.dateTimeLabel.font = [UIFont fontWithName:@"OpenSans" size:10.0f];
//                cell.descriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:11.0f];
//            }
//            
//        }
//        
//    }
//    
//    //Configure the cell...
//    
//    TTNewsData *currentNews = [self.newsArray objectAtIndex:indexPath.row];
//
//    
//    
//    return cell;
//    
//}


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//   //pass the news object...
//
//    
//}

#pragma delegate

-(void)didClickOnNewsButton:(TTNewsDetailViewController *)inController{
//    [self.navigationController popViewControllerAnimated:YES];
    [inController dismissViewControllerAnimated:YES completion:nil];
}



@end
