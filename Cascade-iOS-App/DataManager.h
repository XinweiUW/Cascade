//
//  DataManager.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/12/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CHCSVParser.h"
#import "Rides.h"

@interface DataManager : NSObject <CHCSVParserDelegate>

//- (NSManagedObjectContext *)managedObjectContext;
//- (NSMutableArray *)executeParsing;
- (NSMutableArray *)fetchRequest;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)updateFromServerWithCompletion:(void (^)(void))completionHandler;

@property (strong) Rides *routedb;
@property (readonly) NSArray *lines;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
