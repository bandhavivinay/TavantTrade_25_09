//
//  SBITradingNetworkManager.m
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import "SBITradingNetworkManager.h"
#import "SBITradingUtility.h"
#import "TTUrl.h"
#import "TTAlertView.h"

@implementation SBITradingNetworkManager


+ (instancetype)sharedNetworkManager
{
    
    static SBITradingNetworkManager *sharedNetworkManager = nil;
    if(!sharedNetworkManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedNetworkManager = [[super allocWithZone:nil] init];
            
        });
    }
    
    return sharedNetworkManager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


-(void)makeGETRequestWithRelativePath:(NSString *)relativePath responceCallback:(DiffusionResponse)responceCallback{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[TTUrl BaseURL],relativePath];
    NSLog(@"Relative URL is %@",url);
    
//    SBITradingUtility *utility = [SBITradingUtility sharedUtility];
//    [utility addLoadingSymbol:YES];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:url]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
                if(recievedResponse.statusCode == 200)
                    responceCallback(data,response,error);
                else{
                    //show a alert message to the user ...
                    TTAlertView *alertView = [TTAlertView sharedAlert];
                    
                    if(!alertView.isAlertShown){
                        alertView.isAlertShown = YES;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Network_Error", @"Localizable", @"Network Error")];
                        });

                    }
                    
                }
            }] resume];
}

-(void)makePOSTRequestWithRelativePath:(NSString *)relativePath withPostBody:(id)postBody responceCallback:(DiffusionResponse)responceCallback{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[TTUrl BaseURL],relativePath];
    NSLog(@"%@",url);
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Content-Type"       : @"application/json"
                                                   };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *urlObject = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlObject];
    NSData *jsonData = nil;
    
//    NSArray *postBodyArray = [[NSArray alloc] init];
//    if(postBody)
//        postBodyArray = [NSArray arrayWithObject:postBody];
    NSError *error;
    if(postBody)
        jsonData = [NSJSONSerialization dataWithJSONObject:postBody options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON String is %@",jsonString);
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    if(postBody)
        request.HTTPBody = jsonData;
    [request setHTTPMethod:@"POST"];
//    if(postBody)
//        [request setHTTPMethod:postBody];
//    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
//        if(recievedResponse.statusCode == 200)
//            responceCallback(data, response, error);
//        else
//            [SBITradingUtility showAlertWithMessage:error.localizedDescription];
        
        //check for the success response ...
        
        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
       // if(recievedResponse.statusCode == 200)
            responceCallback(data,response,error);
//        else{
//            //show a alert message to the user ...
//            TTAlertView *alertView = [TTAlertView sharedAlert];
//            
//            if(!alertView.isAlertShown){
//                alertView.isAlertShown = YES;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Network_Error", @"Localizable", @"Network Error")];
//                });
//
//            }
//
//        }
        
    }];
    [postDataTask resume];
}

//-(void)makeSOAPRequestWithURL:(NSString *)inURLString withSOAPMessage:(NSString *)inSOAPMessage responceCallback:(DiffusionResponse)responceCallback{
//    
//    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    sessionConfiguration.HTTPAdditionalHeaders = @{
//                                                   @"Content-Type"       : @"text/xml; charset=utf-8",
//                                                   @"SOAPAction"         : @"http://tempuri.org/GetMessages"
//                                                   };
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
//    NSURL *urlObject = [NSURL URLWithString:inURLString];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlObject];
//
//    request.HTTPBody = [inSOAPMessage dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPMethod:@"POST"];
//    NSLog(@"Request object is %@",request);
//    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        //check for the success response ...
//        
//        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
//        if(recievedResponse.statusCode == 200)
//            responceCallback(data,response,error);
//        else{
//            //show a alert message to the user ...
//            TTAlertView *alertView = [TTAlertView sharedAlert];
//            
//            if(!alertView.isAlertShown){
//                alertView.isAlertShown = YES;
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Network_Error", @"Localizable", @"Network Error")];
//                });
//                
//            }
//            
//        }
//        
//    }];
//    [postDataTask resume];
//}


-(void)makeDELETERequestWithRelativePath:(NSString *)relativePath withPostBody:(id)postBody responceCallback:(DiffusionResponse)responceCallback{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[TTUrl BaseURL],relativePath];
    NSLog(@"%@",url);
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Content-Type"       : @"application/json"
                                                   };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *urlObject = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlObject];
    NSData *jsonData = nil;
    
    //    NSArray *postBodyArray = [[NSArray alloc] init];
    //    if(postBody)
    //        postBodyArray = [NSArray arrayWithObject:postBody];
    NSError *error;
    if(postBody)
        jsonData = [NSJSONSerialization dataWithJSONObject:postBody options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"JSON String is %@",jsonString);
    
    //    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    //    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    if(postBody)
    request.HTTPBody = jsonData;
    [request setHTTPMethod:@"DELETE"];
    //    if(postBody)
    //        [request setHTTPMethod:postBody];
    //    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
        //        if(recievedResponse.statusCode == 200)
        //            responceCallback(data, response, error);
        //        else
        //            [SBITradingUtility showAlertWithMessage:error.localizedDescription];
        
        //check for the success response ...
        
        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
        // if(recievedResponse.statusCode == 200)
        responceCallback(data,response,error);
        //        else{
        //            //show a alert message to the user ...
        //            TTAlertView *alertView = [TTAlertView sharedAlert];
        //
        //            if(!alertView.isAlertShown){
        //                alertView.isAlertShown = YES;
        //
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Network_Error", @"Localizable", @"Network Error")];
        //                });
        //
        //            }
        //
        //        }
        
    }];
    [postDataTask resume];
}

-(void)makePUTRequestWithRelativePath:(NSString *)relativePath withBody:(NSString *)body responceCallback:(DiffusionResponse)responceCallback{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",[TTUrl BaseURL],relativePath];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"PUT"];

    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:noteContents completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
//        responceCallback(data,response,error);
//    }];
//    [uploadTask resume];
    
    NSURLSessionDataTask *putDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *recievedResponse = (NSHTTPURLResponse *)response;
        if(recievedResponse.statusCode == 200)
            responceCallback(data,response,error);
        else{
            //show a alert message to the user ...
            TTAlertView *alertView = [TTAlertView sharedAlert];
            
            if(!alertView.isAlertShown){
                alertView.isAlertShown = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertView showAlertWithMessage:NSLocalizedStringFromTable(@"Network_Error", @"Localizable", @"Network Error")];
                });

            }
            
        }
    }];
    [putDataTask resume];

}
// method which does basic authentication login
-(void)makeBasicAuthenticationRequestWithRelativePath:(NSString *)relativePath withUserName:(NSString *)userName withPassword:(NSString *)password responceCallback:(DiffusionResponse)responceCallback{

    NSString *loginString =(NSMutableString*)[NSString stringWithFormat:@"%@:%@",userName,password];
    
    NSData *encodedLoginData=[loginString dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString *authHeader=[NSString stringWithFormat:@"Basic %@",  [encodedLoginData base64Encoding]];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
   
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:relativePath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];

    NSURLSessionDataTask *putDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         responceCallback(data, response, error);
    }];
    [putDataTask resume];
}

-(void)makeLogoutRequestWithRelativePath:(NSString *)relativePath responceCallback:(DiffusionResponse)responceCallback{
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:relativePath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *putDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        responceCallback(data, response, error);
    }];
    [putDataTask resume];
}


@end
