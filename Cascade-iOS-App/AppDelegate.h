//
//  AppDelegate.h
//  Cascade-iOS-App
//
//  Created by iGuest on 3/25/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GCNetworkReachability.h"
@class DataManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DataManager *datamanager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSUserDefaults *userDefault;
@property (strong, nonatomic) GCNetworkReachability *reachability;


@end

