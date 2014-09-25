//
//  TTMapParser.h
//  TavantTrade
//
//  Created by Bandhavi on 5/21/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMapParser : NSObject<NSXMLParserDelegate>
+(NSMutableArray *)returnScatterMapDataArray:(NSData *)xmlData andPopulateArray:(NSMutableArray *)inArray;
@end
