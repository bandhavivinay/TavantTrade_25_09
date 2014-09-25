//
//  TTAppDelegate.h
//  TavantTrade
//
//  Created by UDAY-MAC on 11/12/13.
//  Copyright (c) 2013 Tavant. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TTDashboardViewController;

@interface TTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)UIImage *chartImage;

@property (nonatomic, retain) TTDashboardViewController *dashboardViewController;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void)showLoginView;

@end
