//
//  TTSOAPRequest.m
//  TavantTrade
//
//  Created by Bandhavi on 13/06/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import "TTSOAPRequest.h"
#import "TTConstants.h"

@implementation TTSOAPRequest

+(NSString *)returnSOAPMessageFor:(NSString *)inSoapRequestType withParameters:(NSDictionary *)inParameterDict{
    
    NSString *soapBody = @"";
    
    //prepare the parameter dictionary ...
    
    NSString *parameterString = @"";
    for(NSString *key in [inParameterDict allKeys]){
        parameterString = [parameterString stringByAppendingFormat:@"<%@>%@</%@>\n",key,[inParameterDict valueForKey:key],key];
    }
    
     soapBody = [NSString stringWithFormat:@"<%@ xmlns=\"http://tempuri.org/\">%@</%@>",inSoapRequestType,parameterString,inSoapRequestType];
    
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "%@"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",soapBody];
    
//    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body>%@</soap:Body></soap:Envelope>",@"<FeedbackQRC xmlns=\"http://tempuri.org/\" /><CustId>ESI64786</CustId><CustName>adafgaga</CustName><ContactNo>64786</ContactNo><Email>ESI64786</Email><Subject>ESI64786</Subject><comments>ESI64786</comments></FeedbackQRC>"];
    
    NSLog(@"soapMessage: \n%@",soapMessage);

    
    return soapMessage;
}

@end
