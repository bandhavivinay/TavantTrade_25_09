//
//  TTAccountDataSource.m
//  TavantTrade
//
//  Created by TAVANT on 2/10/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTAccountDataSource.h"
#import "SBITradingUtility.h"
#import "TTDiffusionData.h"
#import "TTDiffusionHandler.h"

@interface TTAccountDataSource()

@property (nonatomic, strong) NSMutableArray *headersArray;

@end


@implementation TTAccountDataSource
@synthesize ledgerBalance,additionAdhocMargin,adhocMargin,amountUnlened,cncSales,collateral,directCollateral,fundsFormSales,IPOAmount,lienedAmount,marginUsed,mtmLoss,mutualFundAmount,nationalCash,realisedGain,realisedMTMGain,totalMarginUsed,limit,type,mtmLossOnPositions;

-(TTAccountDataSource *) initWithAccountsData:(DFTopicMessage *)message
{
    self = [super init];
    if(self)
    {
        //(In case of streaming off)
        NSArray *streamingData = [SBITradingUtility parseArray:message.records];
        
        
        // take header arry on initial load
        if(message.isInitialLoad){
            
            [[NSUserDefaults standardUserDefaults] setObject:message.userHeaders forKey:@"HeadersArray"];
        }
        
        _headersArray= [[NSUserDefaults standardUserDefaults] objectForKey:@"HeadersArray"];
        
        // Assigning values from diffusion response to members of object
        ledgerBalance   = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"ledgerBalance"]] floatValue]);
        lienedAmount    = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"payinAmount"]] floatValue]);
        type            = EMPTY_IF_NIL([streamingData objectAtIndex:[_headersArray indexOfObject:@"segment"]]);
        limit           = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"marginAvailable"]] floatValue]);
        adhocMargin     = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"marginAvailable"]] floatValue]);
        nationalCash    = EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"notianalCash"]] floatValue]);
        directCollateral= EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"directCollateral"]] floatValue]);
        float sum       = adhocMargin+nationalCash+directCollateral;
        additionAdhocMargin = sum;
        lienedAmount= EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"ledgerBalance"]] floatValue]);
        amountUnlened= EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"notianalCash"]] floatValue]);
        cncSales= EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"cncSalesCredit"]] floatValue]);
        collateral=EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"collateral"]] floatValue]);
        fundsFormSales= EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"cncSalesCredit"]] floatValue]);
        IPOAmount= EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"ipoAmount"]] floatValue]);
        marginUsed= EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"exposureLimit"]] floatValue]);
        mtmLoss= EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"marginUsedPercent"]] floatValue]);
        mutualFundAmount= EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"mutualfundAmount"]] floatValue]);
        realisedGain=EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"cncSalesCredit"]] floatValue]);
        realisedMTMGain=EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"realizedmtomPercent"]] floatValue]);
        totalMarginUsed=EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"marginUsedPercent"]] floatValue]);
        mtmLossOnPositions=EMPTY_Float_IF_NIL([[streamingData objectAtIndex:[_headersArray indexOfObject:@"unrealizedmtomPercent"]] floatValue]);
    }
    
    
    return self;
}




-(TTAccountDataSource *) initWithDictionary:(NSDictionary *)dict
{
  
    self = [super init];
    if(self && dict)
    {
        
        // Assigning values from server response to members of object
        
        ledgerBalance = EMPTY_Float_IF_NIL([[dict objectForKey:@"ledgerBalance"] floatValue]);
        lienedAmount =EMPTY_Float_IF_NIL([[dict objectForKey:@"payinAmount"] floatValue] );
        type= EMPTY_IF_NIL([dict objectForKey:@"segment"]) ;
         limit=EMPTY_Float_IF_NIL([[dict objectForKey:@"marginAvailable"] floatValue]);
        adhocMargin = EMPTY_Float_IF_NIL([[dict objectForKey:@"adhocMargin"] floatValue]);
        nationalCash =EMPTY_Float_IF_NIL([[dict objectForKey:@"notianalCash"] floatValue]);
        directCollateral= EMPTY_Float_IF_NIL([[dict objectForKey:@"notianalCash"] floatValue]);
        float sum= adhocMargin+nationalCash+directCollateral;
        additionAdhocMargin = sum;
        lienedAmount=EMPTY_Float_IF_NIL([[dict objectForKey:@"ledgerBalance"] floatValue]);
        amountUnlened=EMPTY_Float_IF_NIL([[dict objectForKey: @"notianalCash"] floatValue]);
        cncSales=EMPTY_Float_IF_NIL([[ dict objectForKey:@"cncSalesCredit"] floatValue]);
        collateral=EMPTY_Float_IF_NIL([[dict objectForKey:@"collateral"] floatValue]);
        fundsFormSales= EMPTY_Float_IF_NIL([[dict objectForKey:@"cncSalesCredit"] floatValue]);
        IPOAmount=EMPTY_Float_IF_NIL([[dict objectForKey: @"ipoAmount"] floatValue]);
        marginUsed=EMPTY_Float_IF_NIL([[dict objectForKey:@"exposureLimit"] floatValue]);
        mtmLoss=EMPTY_Float_IF_NIL([[dict objectForKey: @"marginUsedPercent"] floatValue]);
        mutualFundAmount=EMPTY_Float_IF_NIL([[dict objectForKey: @"mutualfundAmount"] floatValue]);
        realisedGain=EMPTY_Float_IF_NIL([[dict objectForKey: @"cncSalesCredit"] floatValue]);
        realisedMTMGain=EMPTY_Float_IF_NIL([[dict objectForKey: @"realizedmtomPercent"] floatValue]);
        totalMarginUsed=EMPTY_Float_IF_NIL([[dict objectForKey: @"marginUsedPercent"] floatValue]);
        mtmLossOnPositions=EMPTY_Float_IF_NIL([[dict objectForKey: @"unrealizedmtomPercent"] floatValue]);
    }
    return self;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"Type : %@ Limit: %f ledgerBalance:%f  IPOAmount:%f", type, limit,ledgerBalance,IPOAmount];
}
-(void)setType:(NSString *)inType
{
    type = inType;
    NSLog(@"TEst");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
