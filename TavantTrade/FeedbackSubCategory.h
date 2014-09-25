//
//  FeedbackSubCategory.h
//  TavantTrade
//
//  Created by Bandhavi on 12/06/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FeedbackSubCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSManagedObject *category;

@end
