//
//  TTUrl.h
//  TavantTrade
//
//  Created by Gautham S Shetty on 23/12/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTUrl : NSObject

+ (NSString *)BaseURL;
+(NSString *)tradeLimitURL;
+(NSString *)tickerNSEURL;
+(NSString *)tickerBSEURL;
+(NSString *)marketNewsURL;
+(NSString *)marketnewsDetailsURL;
+(NSString *)orderBookURL;
+(NSString *)cancelOrderURL;
+(NSString *)modifyOrderURL;
+(NSString *)tradeOrderURL;
+(NSString *)accountLoginURL;
+(NSString *)accountLogoutURL;
+(NSString *)positionURL;
+(NSString *)recommendationURL;
+(NSString *)messagesUrl;
+(NSString *)optionChainUrl;
+(NSString *)customerFeedbackUrl;
+(NSString *)diffusionHost;
+(NSString *)watchListURL;
+(NSString *)mapURL;

@end
