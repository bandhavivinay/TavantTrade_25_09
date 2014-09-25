//
//  TTWatchlist.h
//  Diffusion_Native
//
//  Created by Bandhavi on 12/10/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTWatchlist : NSObject
@property(nonatomic,strong)NSString *watchListName;
@property(nonatomic,assign)int watchlistID;
@property(nonatomic,strong)NSString *isSystemWatchlist;
@property(nonatomic,strong)NSString *isDefaultWatchlist;
@property(nonatomic,strong)NSArray *symbolsArray;
@end
