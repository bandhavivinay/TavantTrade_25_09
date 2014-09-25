//
//  SBITradingUtility.h
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTConstants.h"
#import "TTSymbolSearch.h"
#import "TTWatchlist.h"
#import "TTWatchlistController.h"

@interface SBITradingUtility : NSObject
@property(nonatomic,strong)UIView *loadingView;
@property(nonatomic,assign)EExchangeType globalExchangeType;
@property(nonatomic,strong)TTWatchlist *currentSelectedWatchlist;
@property(nonatomic,strong)TTWatchlistController *watchlistController;

+ (instancetype)sharedUtility;
-(void)addLoadingSymbol:(BOOL)shouldAdd;
+(NSArray *)parseArray:(NSArray *)rawArray;
+(UIWindow *)returnWindowObject;
+ (NSString *) getTitleForInstrumentType:(InstrumentType)instrType;
+(NSString *)getInstrumentTypeURLKey:(InstrumentType)instrType;
+ (NSString *) getTitleForMarketDataType:(MarketDataType)inMarketType;
+(NSString *)getMarketDataTypeURLKey:(MarketDataType)inMarketType;
-(void)updateExchangeTypeWith:(EExchangeType)inExchangeType;
-(EExchangeType)returnCurrentExchangeType;
+ (NSString *) getTitleForTransactionType:(ETransactionType) transType;
+ (NSString *) getTitleForOrderType:(EOrderType) ordType;
+ (NSString *) getTitleForProductType:(EProductType) prodType;
+ (NSString *) getTitleForDuration:(EDuration) duration;
+(NSString *)getLimitType:(ELimits)limits;
+(void)searchSymbolWithText:(NSString *)searchText WithExchangeType:(EExchangeType)inExchangeType andInstrumentType:(InstrumentType)inIntrumentType;
+(void)getSymbolDetailsForSymbol:(TTSymbolData *)inSymbolData withExchange:(EExchangeType)inExchangeType andInstrumentType:(InstrumentType)inInstrumentType;
+(EOrderType)returnOrderType:(NSString *)inOrderType;
+ (NSString *) getTitleForEchangeType:(EExchangeType)inType;
+(NSString *)plistFilePath ;
+ (UIColor *)getColorForComponentKey:(NSString *)inComponent;
+(float)getWatchlistColumnWidthFor:(EWatchlistColumns)inColumn;
+(NSString *)getTitleForWatchlistActionType:(EWatchListActionItems)inActionItem;
+(NSString *)getQueryTypeString:(ESOAPRequestType)inRequestType;
+(NSString *)returnStringFromDate:(NSDate *)inDate;
+(NSDate *)returnDateWithTimeFrom:(NSString *)dateString;
+(NSDate *)returnDateWithoutTimeFrom:(NSString *)dateString;
+(NSString *)getWatchlistKey:(EWatchlistColumns)watchlistColumn;
+(void)getSymbolDataForSymbolName:(NSString *)inSymbolName withExchange:(NSString *)inExchangeType andInstrumentType:(NSString *)inInstrumentType :(void(^)(id, NSError *))handler;

//+(UIFont *)navBarHeadingFont;
//+(UIFont *)widgetNavBarHeadingFont;
//+(UIFont *)tickerFont;
//+(UIFont *)watchlistValueFont;
//+(UIFont *)watchlistTitleFont;
//+(UIFont *)symbolNameFont;
//+(UIFont *)cancelButtonFont;
//
//
//+(UIFont *)semiBoldFontWithSize13;
//+(UIFont *)semiBoldFontWithSize14;
//+(UIFont *)semiBoldFontWithSize15;
//+(UIFont *)semiBoldFontWithSize16;
//+(UIFont *)fontWithSize17;
//
//+(UIFont *)regularFontWithSize11;
//+(UIFont *)regularFontWithSize13;
//+(UIFont *)regularFontWithSize14;
//+(UIFont *)regularFontWithSize15;
//+(UIFont *)regularFontWithSize16;


@end
