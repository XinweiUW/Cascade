//
//  DataManager.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/12/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"

@interface DataManager()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation DataManager{
    NSMutableArray *_lines;
    NSMutableArray *_currentLine;
    
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Cascade_iOS_App" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Cascade_iOS_App.sqlite"];
    NSError *error = nil;
    //NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        /*
         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
         dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
         dict[NSLocalizedFailureReasonErrorKey] = failureReason;
         dict[NSUnderlyingErrorKey] = error;
         error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
         // Replace this with code to handle the error appropriately.
         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Cascade.org.Cascade_iOS_App" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    _lines = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    _currentLine = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    NSLog(@"%@", field);
    [_currentLine addObject:field];
}
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [_lines addObject:_currentLine];
    _currentLine = nil;
}
- (void)parserDidEndDocument:(CHCSVParser *)parser {
    //	NSLog(@"parser ended: %@", csvFile);
}
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"ERROR: %@", error);
    _lines = nil;
}


- (void)updateTextFromServerWithCompletion:(void (^)(void))completionHandler{
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *rides = [self mutableArrayUsingFetchRequest];
    if (rides.count != 0){
        [self deleteObjects];
    }
    
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    backgroundContext.parentContext = self.managedObjectContext;
    
    [backgroundContext performBlock:^{
        NSError *error;
        NSString *url = @"https://www.filepicker.io/api/file/GJY1HLYyROPWwUoshwEN";
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSString *file = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] ;
    
        NSLog(@"Beginning...");
        NSStringEncoding encoding = 0;
        CHCSVParser * p = [[CHCSVParser alloc] initWithCSVString:file];
        [p setRecognizesBackslashesAsEscapes:YES];
        [p setSanitizesFields:YES];
        
        NSLog(@"encoding: %@", CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding)));
        
        DataManager * d = [[DataManager alloc] init];
        [p setDelegate:d];
        [p parse];
        
        NSLog(@"%@", [d lines]);
        
        NSInteger size = [d lines].count;
        
        for (NSInteger i = 1; i < size; i++){
            NSArray *temp = [[d lines] objectAtIndex:i];
            NSNumber *number = [NSNumber numberWithInt:i];
            NSNumber *comp = [NSNumber numberWithInt:0];
            
            NSString *title = [temp objectAtIndex:0];
            NSString *distance = [temp objectAtIndex:1];
            NSString *duration = [temp objectAtIndex:2];
            NSString *terrain = [temp objectAtIndex:3];
            NSString *keyWords = [temp objectAtIndex:4];
            NSString *shortOverview = [temp objectAtIndex:5];
            NSString *start = [temp objectAtIndex:6];
            NSString *finish = [temp objectAtIndex:7];
            NSString *mapURL = [temp objectAtIndex:8];
            NSString *roadCondition = [temp objectAtIndex:9];
            NSString *imgURL = [temp objectAtIndex:10];
            NSString *attractions = [temp objectAtIndex:11];
            NSString *descriptions = [temp objectAtIndex:12];
            NSString *turnByTurn = [temp objectAtIndex:13];
            NSString *difficulties = [temp objectAtIndex:14];
            NSString *latitude = [temp objectAtIndex:15];
            NSString *longitude = [temp objectAtIndex:16];
            

            Ride *newRide = [NSEntityDescription insertNewObjectForEntityForName:@"Routes" inManagedObjectContext:backgroundContext];
            newRide.id = number;
            newRide.title = title;
            newRide.distance = distance;
            newRide.duration = duration;
            newRide.terrain = terrain;
            newRide.keyWords = keyWords;
            newRide.shortOverview = shortOverview;
            newRide.start = start;
            newRide.finish = finish;
            newRide.mapURL = mapURL;
            newRide.roadCondition = roadCondition;
            newRide.imgURL = imgURL;
            newRide.attractions = attractions;
            newRide.descriptions = descriptions;
            newRide.turnByTurn = turnByTurn;
            newRide.difficulties = difficulties;
            newRide.complete = comp;
            newRide.latitude = latitude;
            newRide.longitude = longitude;
        }
        
        if (![backgroundContext save:&error]){
            NSLog(@"background save failed: %@", error.localizedFailureReason);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.managedObjectContext save:nil];
            });
        }
        if (completionHandler) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
            dispatch_async(queue, completionHandler);
            //dispatch_async(dispatch_get_main_queue(), completionHandler);
            //completionHandler();
        }
    }];
}

- (void)generateImageFromURL{

    NSMutableArray *routes = [self mutableArrayUsingFetchRequest];
    NSError *error;
    if (routes == nil){
        NSLog(@"routes don't exist! Error: %@", error.localizedDescription);
        return;
    }
    
    NSString *imgURL;
    NSString *title;
    
    for (NSManagedObject *route in routes) {
        title = [route valueForKey:@"title"];
        imgURL = [route valueForKey:@"imgURL"];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgURL]];
        UIImage *image = [UIImage imageWithData:imageData];
        // We store original images instead of cropped images since we want to use original images later.
        [self saveImage:image :title];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageGenerated" object:[route valueForKey:@"id"]];
    }
}


- (void)saveImage: (UIImage *)image :(NSString *)title {
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", title]];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

- (UIImage *)loadImage:(NSString *)title{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:title];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    if (!image) {
        NSLog(@"Image doesn't exist!");
    }
    return image;
}

- (NSMutableArray *)mutableArrayUsingFetchRequest{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Routes"];
    NSArray *sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES]];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    NSError *error;
    NSArray *fetchResult = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (!fetchResult){
        NSLog(@"fetch failed: %@", error.localizedDescription);
    }
    return [fetchResult mutableCopy];
}


// Currently, if we want to update the core data, we would delete all the data and insert all the new data. Later, we will just update those that has been changed.
- (void) deleteObjects{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Routes"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSMutableArray *rides = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath;
    NSError *error;
    
    for (id ride in rides){
        [managedObjectContext deleteObject:ride];
        filePath = [documentsDirectory stringByAppendingPathComponent:[ride valueForKey:@"title"]];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
}


@end
