//
//  ScatterMapViewController.m
//  TavantTrade
//
//  Created by Bandhavi on 5/20/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTScatterMapViewController.h"
#import "SBITradingNetworkManager.h"
#import "TTUrl.h"
#import "TTSymbolData.h"
#import "TTDiffusionData.h"
#import "TTDiffusionHandler.h"
#import "SBITradingUtility.h"
#import "TTMapParser.h"
#import "TTMapData.h"
#import "TTHeatMapColorSelector.h"
#import "TTTradePopoverController.h"

@interface TTScatterMapViewController ()

@property(nonatomic,weak)IBOutlet UIView *mapRenderView;
@property(nonatomic,weak)IBOutlet UIScrollView *scatterMapRenderScrollView;
@property(nonatomic,weak)IBOutlet UIScrollView *heatMapRenderScrollView;
@property(nonatomic,weak)IBOutlet UIView *heatMapRenderView;
@property(nonatomic,strong)UIPopoverController *selectPopoverController;
@property(nonatomic,strong)NSMutableArray *optionArray;
@property(nonatomic,strong)IBOutlet UIView *popoverOptionView;
@property(nonatomic,weak)IBOutlet UITableView *popOverOptionTableView;
@property(nonatomic,weak)IBOutlet UIButton *exchangeTypeButton;
@property(nonatomic,weak)IBOutlet UIButton *mapTypeButton;

@property(nonatomic,strong)TTDiffusionHandler *diffusion;
@property(nonatomic,strong)NSMutableArray *mapDataArray;
@property(nonatomic,strong)NSMutableDictionary *xAxisDictionary;

@property(nonatomic,weak)IBOutlet UILabel *symbolNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *companyNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *turnoverLabel;
@property(nonatomic,weak)IBOutlet UILabel *volumeLabel;
@property(nonatomic,weak)IBOutlet UILabel *perChangeLabel;
@property(nonatomic,weak)IBOutlet UILabel *netChangeLabel;
@property(nonatomic,weak)IBOutlet UILabel *mapHeadingLabel;

@property(nonatomic,weak)IBOutlet UISegmentedControl *mapTypeSegmentControl;
@property(nonatomic,assign)float yMax;
@property(nonatomic,assign)float yMin;
@property(nonatomic,assign)float previousZoomScale;

@property(nonatomic,assign)CGSize currentContentSize;
@property(nonatomic,strong)NSArray *sortedMapArray;

@property(nonatomic,assign)float currentZoomScale;

@property(nonatomic,strong)TTScatterMapSymbolView *previousSelectedSymbolView;
@property(nonatomic,strong)TTHeatMapSymbolView *previousSelectedHeatSymbolView;

@property(nonatomic,strong)NSString *niftyMapURL;
@property(nonatomic,strong)NSString *sensexMapURL;
@property(nonatomic,strong)NSString *previousSelection;


@end

@implementation TTScatterMapViewController

@synthesize diffusion,mapDataArray;

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 1004, 714);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _niftyMapURL = NSLocalizedStringFromTable(@"NSE_KEY", @"Localizable", @"NSE/NIFTY");
        _sensexMapURL = NSLocalizedStringFromTable(@"BSE_KEY", @"Localizable", @"BSE/BSE_SENSEX");
        
    }
    return self;
}

-(void)drawHeatMap{
    int tilesPerRow = 8;
    int xOffset = 18;
    int yOffset = 18;
//    int maxXAxis = 940 - (xOffset*tilesPerRow - 1);
    float blockWidth = 107;
    float blockHeight = 38;
    int i = 0,j = 0;
    float currentX = (_heatMapRenderScrollView.frame.size.width - tilesPerRow*blockWidth - (tilesPerRow-1)*xOffset)/2;
    float currentY = 20;//(_heatMapRenderScrollView.frame.size.height - tilesPerRow*blockHeight - (tilesPerRow-1)*yOffset)/2;
    
    
    //check if content size has to be modified ...
    if([_sortedMapArray count] > tilesPerRow*tilesPerRow){
        int extraRows = ceilf(([_sortedMapArray count]-tilesPerRow*tilesPerRow)*1.00/tilesPerRow*1.00);
        NSLog(@"Extra count is %d",extraRows);
        _heatMapRenderScrollView.contentSize = CGSizeMake(_heatMapRenderScrollView.frame.size.width, _heatMapRenderScrollView.frame.size.height+extraRows*(blockHeight+yOffset));
    }
    
    for(id objects in _sortedMapArray){
        TTMapData *mapData = (TTMapData *)objects;
        NSLog(@"Value of percentage change is %@",mapData.percentageChange);
        
        //add the symbol view ...
        TTHeatMapSymbolView *heatMapSymbolView = [[TTHeatMapSymbolView alloc] initWithFrame:CGRectMake(currentX + i*blockWidth + xOffset * i, currentY + j*blockHeight + yOffset * j, blockWidth, blockHeight)];
        NSLog(@"Rect frame is %@",NSStringFromCGRect(heatMapSymbolView.frame));
        heatMapSymbolView.layer.shadowOffset = CGSizeMake(3, 3);
//        heatMapSymbolView.layer.shadowRadius = 5;
        heatMapSymbolView.layer.shadowOpacity = 0.5;
//        heatMapSymbolView.layer.cornerRadius = 2.0;
        
        heatMapSymbolView.heatSymbolViewDelegate = self;
        heatMapSymbolView.currentMapData = mapData;
        [_heatMapRenderScrollView addSubview:heatMapSymbolView];
        NSLog(@" Block %d frame is %@",i,NSStringFromCGRect(heatMapSymbolView.frame));
        i++;
        
        if(i%tilesPerRow == 0){
            //new row ...
            i = 0;
            j++;
        }
        
    }
    
}

-(void)drawScatterMapOn:(CGSize)inRectFrameSize{
    
    //remove all subviews on the map ...
    
    for(UIView *views in [_scatterMapRenderScrollView subviews]){
        [views removeFromSuperview];
    }
    
    //    NSLog(@"Dict is %@",_xAxisDictionary);
    float currentX = 20;
    float xAxisWidth = inRectFrameSize.width - 22;
    //draw the x-axis ...
    
    UIView *xAxisView = [[UIView alloc] initWithFrame:CGRectMake(currentX, inRectFrameSize.height - currentX, xAxisWidth, 1)];
    xAxisView.backgroundColor = [UIColor darkGrayColor];
    [self.scatterMapRenderScrollView addSubview:xAxisView];
    
    float graphUnit = xAxisWidth/[[_xAxisDictionary allKeys] count];
    int i = 1;
    for(id objects in [_xAxisDictionary allKeys]){
        UIView * xAxisStrokes = [[UIView alloc] initWithFrame:CGRectMake(currentX + graphUnit*i, inRectFrameSize.height - currentX - 1, 1, 5)];
        xAxisStrokes.backgroundColor = [UIColor darkGrayColor];
        [self.scatterMapRenderScrollView addSubview:xAxisStrokes];
        i++;
    }
    
    //draw the y-axis ...
    
    int yOffset = 34;
    float yAxisHeight = inRectFrameSize.height - 54;
    
    UIView *yAxisView = [[UIView alloc] initWithFrame:CGRectMake(currentX, yOffset, 1, yAxisHeight)];
    yAxisView.backgroundColor = [UIColor darkGrayColor];
    [self.scatterMapRenderScrollView addSubview:yAxisView];
    
    int highestRadius = 80;
    int yAxisLength = (yAxisHeight - highestRadius)/2;
    
    
    UIView * yAxisZeroStroke = [[UIView alloc] initWithFrame:CGRectMake(19, yOffset+yAxisLength, xAxisWidth, 1)];
    yAxisZeroStroke.backgroundColor = [UIColor lightGrayColor];
    [self.scatterMapRenderScrollView addSubview:yAxisZeroStroke];
    
    UILabel * yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, yOffset+yAxisLength - 5, 10, 10)];
    yAxisLabel.text = @"0";
    yAxisLabel.font = [UIFont systemFontOfSize:10.0];
    [self.scatterMapRenderScrollView addSubview:yAxisLabel];
    
    float currentY = yOffset+yAxisLength;
    float num = (fabsf(_yMax) > fabsf(_yMin))?fabsf(_yMax):fabsf(_yMin);
    float graphYUnit = (yAxisLength-1)/num;
    
    //    int k = 1;
    for(int k = 1; k <= ceilf(num) ; k++){
        float yValue = currentY - graphYUnit*k;
        if(yValue < yOffset)
            break;
        UIView * yAxisStrokes = [[UIView alloc] initWithFrame:CGRectMake(20-3, yValue, 5, 1)];
        yAxisStrokes.backgroundColor = [UIColor darkGrayColor];
        [self.scatterMapRenderScrollView addSubview:yAxisStrokes];
        
        UILabel * yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, yValue - 5, 10, 10)];
        yAxisLabel.text = [NSString stringWithFormat:@"%d",k];
        yAxisLabel.font = [UIFont systemFontOfSize:10.0];
        [self.scatterMapRenderScrollView addSubview:yAxisLabel];
        
        //        k++;
    }
    //    k = 1;
    currentY = yOffset+yAxisLength;
    for(int k = 1; k <= ceilf(num) ; k++){
        float yValue = currentY + graphYUnit*k;
        if(yValue > yAxisHeight)
            break;
        UIView * yAxisStrokes = [[UIView alloc] initWithFrame:CGRectMake(20-3, yValue, 5, 1)];
        yAxisStrokes.backgroundColor = [UIColor darkGrayColor];
        [self.scatterMapRenderScrollView addSubview:yAxisStrokes];
        
        UILabel * yAxisLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, yValue - 5, 10, 10)];
        yAxisLabel.text = [NSString stringWithFormat:@"-%d",k];
        yAxisLabel.font = [UIFont systemFontOfSize:10.0];
        [self.scatterMapRenderScrollView addSubview:yAxisLabel];
        
        //        k++;
    }
    
    //plot the symbol views ...
    
    NSArray *keys = [_xAxisDictionary allKeys];
    keys = [keys sortedArrayUsingComparator:^(id a, id b) {
        return [a compare:b options:NSNumericSearch];
    }];
    
    for(NSString *object in keys){
        //        NSLog(@"Value is %@ and key sis %@",[_xAxisDictionary valueForKey:object], object);
        int j = 0;
        int symbolCount = [[_xAxisDictionary valueForKey:object] count];
        int symbolGraphUnit = graphUnit/symbolCount;
        for(TTMapData *mapData in [_xAxisDictionary valueForKey:object]){
            float yValue = yOffset+yAxisLength;
            //decide y value based on percentage change ...
            //            NSLog(@"GraphUnit is %f and cal is %f",graphYUnit,fabsf([mapData.percentageChange floatValue])*graphYUnit);
            if([mapData.percentageChange floatValue] < 0){
                yValue += fabsf([mapData.percentageChange floatValue])*graphYUnit;
            }
            else{
                yValue -= fabsf([mapData.percentageChange floatValue])*graphYUnit;
            }
            //            NSLog(@"Symbol is %@ ....... %f",mapData.symbolName,yValue);
            
            //decide upon the radius of the circle ...
            float radius = [mapData.turnover floatValue]/1000000.00;
            if(radius < 50)
                radius = 50;
            if(radius > 80)
                radius = 80;
            
            TTScatterMapSymbolView *scatterMapSymbolView = [[TTScatterMapSymbolView alloc] initWithFrame:CGRectMake(currentX+symbolGraphUnit*j, yValue, radius, radius)];
            
            scatterMapSymbolView.layer.shadowOffset = CGSizeMake(3, 3);
//            scatterMapSymbolView.layer.shadowRadius = 5;
            scatterMapSymbolView.layer.shadowOpacity = 0.5;
            
            scatterMapSymbolView.mapData = mapData;
            scatterMapSymbolView.symbolViewDelegate = self;
            [self.scatterMapRenderScrollView addSubview:scatterMapSymbolView];
            j++;
        }
        currentX+=graphUnit;
    }
    
}

-(void)drawTheHeatMapColorScale{
    int numberOfGrids = 7;
    int totalWidth = 952;
    int height = 18;
    float width = totalWidth/numberOfGrids;
    int xPos = 25;
    int yPos = 500;
    
    for(int i = 0; i<numberOfGrids; i++){
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(xPos + i*width, yPos, width, height)];
        colorView.backgroundColor = [TTHeatMapColorSelector returnColorForColorCase:i+1];
        
        //draw the uilabel for determining the percentage scale ...
        UILabel *percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        percentageLabel.textAlignment = NSTextAlignmentCenter;
        percentageLabel.textColor = [UIColor whiteColor];
        percentageLabel.font = [UIFont systemFontOfSize:9.0];
        percentageLabel.text = [TTHeatMapColorSelector returnPercentageRangeForColorCase:i+1];
        [colorView addSubview:percentageLabel];
        
        [_heatMapRenderView addSubview:colorView];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mapTypeSegmentControl.selectedSegmentIndex = 0;
    _currentZoomScale = 1;
    //mapDataArray = [NSMutableArray array];
    _scatterMapRenderScrollView.contentSize = CGSizeMake(_scatterMapRenderScrollView.frame.size.width, _scatterMapRenderScrollView.frame.size.height);
    NSLog(@"Content size is %@",NSStringFromCGSize(_scatterMapRenderScrollView.contentSize));
    _currentContentSize = _scatterMapRenderScrollView.contentSize;
    
    self.mapTypeSegmentControl.tintColor = [SBITradingUtility getColorForComponentKey:@"Default"];
    
    //set the minimum and maximum zoom scale ...
    
    _scatterMapRenderScrollView.minimumZoomScale = 1.0;
    _scatterMapRenderScrollView.maximumZoomScale = 2.5;
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [_scatterMapRenderScrollView addGestureRecognizer:pinchRecognizer];
    
//    NSString *mapXML = [[NSBundle mainBundle] pathForResource:@"HeatMap" ofType:@"xml"];
//    NSData *xmlFileData = [NSData dataWithContentsOfFile:mapXML];
//    mapDataArray = [TTMapParser returnScatterMapDataArray:xmlFileData andPopulateArray:mapDataArray];
    
    //get the symbol array ...
    NSString *relativePath = [NSString stringWithFormat:@"%@/%@/DAY",[TTUrl mapURL],_niftyMapURL];
    _previousSelection = @"NIFTY";
    [self reloadTheMapWithURL:relativePath];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)reloadTheMapWithURL:(NSString *)inRelativePath{
    
    SBITradingNetworkManager *networkManager = [SBITradingNetworkManager sharedNetworkManager];
    [networkManager makeGETRequestWithRelativePath:inRelativePath responceCallback:^(NSData *data,NSURLResponse *response,NSError *error) {
        mapDataArray = [[NSMutableArray alloc] init];
        if(data)
        {
            NSString *jsonString = [NSString stringWithUTF8String:[data bytes]];
            NSLog(@"************** %@ and status code is %@ for URL %@",jsonString,response,inRelativePath);
            
            NSError *jsonParsingError = nil;
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            for(id object in responseArray){
                TTMapData *mapData = [[TTMapData alloc] initWithDictionary:object];
                [mapDataArray addObject:mapData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //form group of each character ...
                _xAxisDictionary = [[NSMutableDictionary alloc] init];
                for (char character = 'A'; character <= 'Z'; character++)
                {
                    NSString* alphabet = [NSString stringWithFormat:@"%c" , character];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"symbolName BEGINSWITH %@",alphabet];
                    NSArray *characterElementsArray = [mapDataArray filteredArrayUsingPredicate:predicate];
                    if([characterElementsArray count] > 0)
                        [_xAxisDictionary setValue:characterElementsArray forKey:alphabet];
                }
                
                //sort map data array as per percentage change ...
                
                _sortedMapArray =  [mapDataArray sortedArrayUsingComparator:^(id a, id b) {
                    TTMapData *mapData1 = (TTMapData *)a;
                    TTMapData *mapData2 = (TTMapData *)b;
                    if([mapData1.percentageChange floatValue] < [mapData2.percentageChange floatValue])
                        return (NSComparisonResult)NSOrderedDescending;
                    else if([mapData1.percentageChange floatValue] > [mapData2.percentageChange floatValue])
                        return (NSComparisonResult)NSOrderedAscending;
                    else
                        return (NSComparisonResult)NSOrderedSame;
                    //        return [mapData1.percentageChange compare:mapData2.percentageChange options:NSNumericSearch];
                }];
                
                //find the min and max of percentage change ...
                
                NSMutableArray *yComponent = [[NSMutableArray alloc] init];
                
                _yMax = -MAXFLOAT;
                _yMin = MAXFLOAT;
                for (TTMapData *data in mapDataArray) {
                    [yComponent addObject:data.percentageChange];
                    float y = [data.percentageChange floatValue];
                    if (y < _yMin) _yMin = y;
                    if (y > _yMax) _yMax = y;
                }
                _heatMapRenderView.hidden = NO;
                _scatterMapRenderScrollView.hidden = YES;
                [self drawHeatMap];
                [self drawTheHeatMapColorScale];
                [self drawScatterMapOn:_currentContentSize];
                [self switchTheMapView:_mapTypeSegmentControl.selectedSegmentIndex];
            });
        }
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)zoomTheMapWithScale:(float)zoomScale{
    if(zoomScale < 1)
        zoomScale = 1;
    if(zoomScale > 3)
        zoomScale = 3;
    _currentZoomScale = zoomScale;
    _scatterMapRenderScrollView.contentSize = CGSizeMake(_scatterMapRenderScrollView.bounds.size.width * zoomScale, _scatterMapRenderScrollView.bounds.size.height * zoomScale);
    
    CGAffineTransform transform = CGAffineTransformScale(self.mapRenderView.transform, zoomScale, zoomScale);
    _currentContentSize = _scatterMapRenderScrollView.contentSize;
    self.mapRenderView.transform = transform;
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        float zoomScale = recognizer.scale;
        
        NSLog(@"Zoom Scale = %f", zoomScale);
        [self zoomTheMapWithScale:zoomScale];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self drawScatterMapOn:_currentContentSize];
            //set the scroll offset to the touch point ...
            //            if(zoomScale > 1){
            //                CGPoint offsetPoint = [recognizer locationInView:_mapRenderView];
            //                [_mapRenderScrollView setContentOffset:CGPointMake(offsetPoint.x * zoomScale, offsetPoint.y*zoomScale) animated:YES];
            //            }
        });
        
    }
    
}

-(IBAction)goToTrade:(id)sender{
    //open the trade screen ...
    if([_symbolNameLabel.text length] > 0){
        TTOrder *orderObj = [[TTOrder alloc] init];
        TTSymbolData *currentSymbolData = [[TTSymbolData alloc] init];
        currentSymbolData.symbolName = _symbolNameLabel.text;
        currentSymbolData.companyName = _companyNameLabel.text;
        orderObj.symbolData = currentSymbolData;
        TTTradePopoverController *tradeViewController = [[TTTradePopoverController alloc] initWithNibName:@"TTTradePopoverController" bundle:nil];
        tradeViewController.isModifyMode = YES;
        tradeViewController.tradeDataSource = orderObj;
        [self dismissViewControllerAnimated:YES completion:^{
            UINavigationController *tradeNavigationController = [[UINavigationController alloc] initWithRootViewController:tradeViewController];
            [self.ttTradeScreenDelegate tradeNavigationViewControllerShouldPresent:tradeNavigationController];
        }];
    }
}

-(IBAction)changeMapType:(id)sender{
    [self clearSymbolDetails];
    [self switchTheMapView:_mapTypeSegmentControl.selectedSegmentIndex];
}

-(void)switchTheMapView:(int)inIndex{
    if(inIndex == 0){
        //load heat map ...
        [_previousSelectedSymbolView setIsSelected:NO];
        _mapHeadingLabel.text = @"Heat Map";
        _scatterMapRenderScrollView.hidden = YES;
        _heatMapRenderView.hidden = NO;
    }
    else{
        //load scatter map ...
        [_previousSelectedHeatSymbolView setIsSelected:NO];
        _mapHeadingLabel.text = @"Scatter Map";
        _scatterMapRenderScrollView.hidden = NO;
        _heatMapRenderView.hidden = YES;
    }

}

-(IBAction)mapZoomIn:(id)sender{
    _currentZoomScale *= 2;
    [self zoomTheMapWithScale:_currentZoomScale];
    [self drawScatterMapOn:_currentContentSize];
    
}

-(IBAction)mapZoomOut:(id)sender{
    _currentZoomScale /= 2;
    [self zoomTheMapWithScale:_currentZoomScale];
    [self drawScatterMapOn:_currentContentSize];
}

- (IBAction)closeChartView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissPopOver{
    
    if([self.selectPopoverController isPopoverVisible]){
        [self.selectPopoverController dismissPopoverAnimated:YES];
    }
    self.selectPopoverController = nil;
}


-(IBAction)showPopover:(id)sender{
      UIButton *button = (UIButton *)sender;
      _optionArray = [[NSMutableArray alloc] init];
      if(button == _exchangeTypeButton){
          [_optionArray addObject:@"NIFTY"];
          [_optionArray addObject:@"SENSEX"];
      }
      else{
          [_optionArray addObject:@"Change vs Turnover"];
          [_optionArray addObject:@"ABC vs ABC"];
      }
      [self presentPopOver:button];
      [self drawScatterMapOn:_currentContentSize];
}

-(void)presentPopOver:(UIButton *)inButton{
    UIViewController* controller = [[UIViewController alloc] init];
    controller.view = self.popoverOptionView;
    
    self.selectPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self.selectPopoverController setPopoverContentSize:CGSizeMake(self.popoverOptionView.frame.size.width, self.popoverOptionView.frame.size.height)];
    [self.selectPopoverController presentPopoverFromRect:[inButton frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

-(void)showSymbolDetails:(TTMapData *)inMapData{
    self.symbolNameLabel.text = inMapData.symbolName;
    self.companyNameLabel.text = inMapData.companyName;
    self.netChangeLabel.text = [inMapData.netChange stringValue];
    self.perChangeLabel.text = [inMapData.percentageChange stringValue];
    self.turnoverLabel.text = [inMapData.turnover stringValue];
    self.volumeLabel.text = [inMapData.volume stringValue];
}

-(void)clearSymbolDetails{
    self.symbolNameLabel.text = @"";
    self.companyNameLabel.text = @"";
    self.netChangeLabel.text = @"";
    self.perChangeLabel.text = @"";
    self.turnoverLabel.text = @"";
    self.volumeLabel.text = @"";
}

#pragma SymbolView Delegate

-(void)didClickSymbolView:(TTScatterMapSymbolView *)inView{
    
    if(_previousSelectedSymbolView != nil)
        [_previousSelectedSymbolView setIsSelected:NO];
    [inView setIsSelected:YES];
    
    NSLog(@"Did Select %@",inView.mapData.symbolName);
    [self showSymbolDetails:inView.mapData];
    [_scatterMapRenderScrollView bringSubviewToFront:inView];

    _previousSelectedSymbolView = inView;
}

-(void)didClickHeatSymbolView:(TTHeatMapSymbolView *)inView{
    
    if(_previousSelectedHeatSymbolView != nil)
        [_previousSelectedHeatSymbolView setIsSelected:NO];
    [inView setIsSelected:YES];
    NSLog(@"Did Select %@",inView.currentMapData.symbolName);
    [self showSymbolDetails:inView.currentMapData];
    
    _previousSelectedHeatSymbolView = inView;
}

#pragma TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_optionArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if(tableView == _popOverOptionTableView){
        static NSString *cellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.textLabel.text = [_optionArray objectAtIndex:indexPath.row];
            
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![_previousSelection isEqualToString:[_optionArray objectAtIndex:indexPath.row]]){
        NSString *relativePath = @"";
        if(indexPath.row == 0){
            relativePath = [NSString stringWithFormat:@"%@/%@/DAY",[TTUrl mapURL],_niftyMapURL];
            _previousSelection = @"NIFTY";
        }
        else{
            relativePath = [NSString stringWithFormat:@"%@/%@/DAY",[TTUrl mapURL],_sensexMapURL];
            _previousSelection = @"SENSEX";
        }
        [_exchangeTypeButton setTitle:_previousSelection forState:UIControlStateNormal];
        [self reloadTheMapWithURL:relativePath];
    }
    [self dismissPopOver];
}

#pragma Diffusion Delegates

//-(void)onConnectionWithStatus:(BOOL)isConnected{
//
//    //get the watchlist...
//
//}
//
//-(void)onDelta:(DFTopicMessage *)message{
//    
//    //find the row to be updated...
//    NSArray *parsedArray = [SBITradingUtility parseArray:message.records];
//    NSMutableArray *symbolListArray = marqueeArray;
//    
//}


@end
