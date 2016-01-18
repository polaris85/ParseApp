//
//  AppDelegate.h
//  ParseApp
//
//  Created by Adam on 7/8/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GlobalVariable.h"
#import "ZUUIRevealController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) ZUUIRevealController  *viewController;

- (void) saveContext;
- (NSURL *) applicationDocumentsDirectory;
- (void) onGoHome;

@end
