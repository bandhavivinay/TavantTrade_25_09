//
//  TTGlobalSymbolSearchViewController.h
//  TavantTrade
//
//  Created by Gautham S Shetty on 24/01/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSymbolSearch.h"
#import "TTSymbolSearchTableCell.h"
#import "TTConstants.h"

typedef enum InstrumentMode {
    iDefaultMode = 0,
    iOptionMode= 1,
    iEquityMode=2,
    iFutureMode=3
}IInstrumentMode;

@protocol TTGlobalSymbolSearchDelegate;

@interface TTGlobalSymbolSearchViewController : UIViewController<SelectSearchSymbolProtocol>
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *searchSymbolTitle;
@property (nonatomic, assign) NSObject <TTGlobalSymbolSearchDelegate> *delegate;
@property(nonatomic,assign)BOOL isExpiry;
@property(nonatomic,assign)BOOL isOptionSeries;
@property (nonatomic, assign) IInstrumentMode instrumentMode;
@property(nonatomic,assign)ESearchType searchType;
@property(nonatomic,assign)BOOL shouldShowBackButton;
@property(nonatomic,strong)NSString *previousScreenTitle;
@end


@protocol TTGlobalSymbolSearchDelegate <NSObject>

- (void) globalSymbolSearchViewControllerDidCancelSearch:(TTGlobalSymbolSearchViewController *)inController;
- (void) globalSymbolSearchViewController:(TTGlobalSymbolSearchViewController *)inController didSelectSymbol:(TTSymbolData *)inSymbol;

@end