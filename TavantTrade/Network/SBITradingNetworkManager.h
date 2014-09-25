//
//  SBITradingNetworkManager.h
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBITradingNetworkManager : NSObject

typedef void (^DiffusionResponse) (NSData *data,
                                   NSURLResponse *response,
                                   NSError *error);

+ (instancetype)sharedNetworkManager;
-(void)makeGETRequestWithRelativePath:(NSString *)relativePath responceCallback:(DiffusionResponse)responceCallback;
-(void)makePOSTRequestWithRelativePath:(NSString *)relativePath withPostBody:(id)postBody responceCallback:(DiffusionResponse)responceCallback;
-(void)makePUTRequestWithRelativePath:(NSString *)relativePath withBody:(NSString *)body responceCallback:(DiffusionResponse)responceCallback;
-(void)makeBasicAuthenticationRequestWithRelativePath:(NSString *)relativePath withUserName:(NSString *)userName withPassword:(NSString *)password responceCallback:(DiffusionResponse)responceCallback ;
-(void)makeLogoutRequestWithRelativePath:(NSString *)relativePath responceCallback:(DiffusionResponse)responceCallback;
-(void)makeSOAPRequestWithURL:(NSString *)inURLString withSOAPMessage:(NSString *)inSOAPMessage responceCallback:(DiffusionResponse)responceCallback;
-(void)makeDELETERequestWithRelativePath:(NSString *)relativePath withPostBody:(id)postBody responceCallback:(DiffusionResponse)responceCallback;

@end
