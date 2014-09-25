//
//  TTDiffusionHandler.h
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFClient.h"

@protocol DiffusionProtocol
@optional
-(void)onConnectionWithStatus:(BOOL)isConnected;
-(void)onDelta:(DFTopicMessage *)message;
@end

@interface TTDiffusionHandler : NSObject<DFClientDelegate>
@property(nonatomic,strong)NSMutableDictionary *symbolControllerMapping;
@property(nonatomic,strong)id initialConnectionContext;
+ (id)sharedDiffusionManager;

-(void)initDiffusion;
-(void)connectWithViewControllerContext:(id)context;
-(void)subscribe:(NSString *)symbol withContext:(id)context;
-(void)unsubscribe:(NSString *)symbol withContext:(id)context;
-(void)disconnect;
@end
