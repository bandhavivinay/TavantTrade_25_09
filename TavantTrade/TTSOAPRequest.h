//
//  TTSOAPRequest.h
//  TavantTrade
//
//  Created by Bandhavi on 13/06/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTSOAPRequest : NSObject
+(NSString *)returnSOAPMessageFor:(NSString *)inSoapRequestType withParameters:(NSDictionary *)inParameterDict;
@end
