//
//  DataManager.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/12/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "CHCSVParser.h"
#import "Ride.h"

@interface DataManager : NSObject <CHCSVParserDelegate>

//- (NSManagedObjectContext *)managedObjectContext;
//- (NSMutableArray *)executeParsing;
- (NSMutableArray *)mutableArrayUsingFetchRequest;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)updateTextFromServerWithCompletion:(void (^)(void))completionHandler;
- (void)generateImageFromURL;
- (void)saveImage: (UIImage *)image :(NSString *)title;
- (UIImage *)loadImage:(NSString *)title;
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (NSInteger)numberOfImage;
- (void) putAlertView:(id)sender;

@property (strong) Ride *routedb;
@property (readonly) NSArray *lines;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
