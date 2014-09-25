//
//  FeedbackCategory.h
//  TavantTrade
//
//  Created by Bandhavi on 12/06/14.
//  Copyright (c) 2014 Tavant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FeedbackSubCategory;

@interface FeedbackCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *subcategory;
@end

@interface FeedbackCategory (CoreDataGeneratedAccessors)

- (void)addSubcategoryObject:(FeedbackSubCategory *)value;
- (void)removeSubcategoryObject:(FeedbackSubCategory *)value;
- (void)addSubcategory:(NSSet *)values;
- (void)removeSubcategory:(NSSet *)values;

@end
