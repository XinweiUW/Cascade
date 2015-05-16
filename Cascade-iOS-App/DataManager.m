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

@property (strong, nonatomic) NSMutableDictionary *rideExist;
@property (strong, nonatomic) NSMutableArray *currentRides;
@property (strong, nonatomic) NSMutableArray *ridesFromCSV;

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

- (NSArray *)fetchCSV{
    
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    NSString *url = @"http://cbc-drupal-assets.s3.amazonaws.com/Top_10_Rides_Content.csv";
    NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *file = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Beginning...");
    NSStringEncoding encoding = 0;
    CHCSVParser * p = [[CHCSVParser alloc] initWithCSVString:file];
    [p setRecognizesBackslashesAsEscapes:YES];
    [p setSanitizesFields:YES];
    
    NSLog(@"encoding: %@", CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding)));
    
    DataManager * d = [[DataManager alloc] init];
    [p setDelegate:d];
    [p parse];
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    NSLog(@"raw difference: %f", (end-start));
    
    return [d lines];
}


- (void)updateTextFromServerWithCompletion:(void (^)(void))completionHandler{
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.parentContext = self.managedObjectContext;
    
    [backgroundContext performBlock:^{
        NSError *error;
        //NSLog(@"%@", [d lines]);
        //dispatch_async(dispatch_get_main_queue(), ^{
        //    [[NSNotificationCenter defaultCenter] postNotificationName:@"CSVFileFetched" object:nil];
        //});
        
        self.ridesFromCSV = [[NSMutableArray alloc] initWithArray:[self fetchCSV]];
        self.currentRides = [self mutableArrayUsingFetchRequest];
        self.rideExist = [[NSMutableDictionary alloc] init];
        
        for (NSInteger i = 0; i < self.currentRides.count; i++){
            NSString *title = [[self.currentRides objectAtIndex:i] valueForKey:@"title"];
            [self.rideExist setValue:[NSNumber numberWithInteger:0] forKey:title];
        }

        NSInteger size = self.ridesFromCSV.count;
        
        for (NSInteger i = 1; i < size; i++){
            NSArray *temp = [self.ridesFromCSV objectAtIndex:i];
            NSNumber *number = [NSNumber numberWithInteger:i];
            //NSNumber *comp = [NSNumber numberWithInt:0];
            
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
            NSString *turnByTurnText = [temp objectAtIndex:17];
            
            if (/*self.rideExist.count == 0 || */![self.rideExist valueForKey:title]){
                Ride *newRide = [NSEntityDescription insertNewObjectForEntityForName:@"Routes" inManagedObjectContext:backgroundContext];
                newRide.id = (NSInteger)number;
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
                newRide.complete = 0;
                newRide.latitude = latitude;
                newRide.longitude = longitude;
                newRide.turnByTurnText = turnByTurnText;
            }else{
                [self.rideExist setValue:[NSNumber numberWithInteger:1] forKey:title];
                Ride *currentRide = [self.currentRides objectAtIndex:i-1];
                currentRide.id = (NSInteger)number;
                currentRide.title = title;
                currentRide.distance = distance;
                currentRide.duration = duration;
                currentRide.terrain = terrain;
                currentRide.keyWords = keyWords;
                currentRide.shortOverview = shortOverview;
                currentRide.start = start;
                currentRide.finish = finish;
                currentRide.mapURL = mapURL;
                currentRide.roadCondition = roadCondition;
                if (![currentRide.imgURL isEqualToString:imgURL]){
                    //mark the imgURL that the image needs to be deleted in local and we will regenerate the current image based on the new imageURL.
                    [self deleteImage:i-1];
                }
                currentRide.imgURL = imgURL;
                currentRide.attractions = attractions;
                currentRide.descriptions = descriptions;
                currentRide.turnByTurn = turnByTurn;
                currentRide.difficulties = difficulties;
                //currentRide.complete = 0;
                currentRide.latitude = latitude;
                currentRide.longitude = longitude;
                currentRide.turnByTurnText = turnByTurnText;
            }
        }
        
        for (NSInteger i = 0; i < self.currentRides.count; i++){
            NSString *title = [[self.currentRides objectAtIndex:i] valueForKey:@"title"];
            if ([[self.rideExist valueForKey:title] integerValue] == 0 && self.ridesFromCSV.count > 0){ // self.ridesFromCSV.count > 0 is to make sure no data will be deleted if CSV was not fetched.
                // delete Object
                [self deleteObject:i];
            }
        }
        
        if (![backgroundContext save:&error]){
            NSLog(@"background save failed: %@", error.localizedFailureReason);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.managedObjectContext save:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"textDataGenerated" object:nil];
                //if (completionHandler) {
                //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0ul);
                //    dispatch_async(queue, completionHandler);
                    //dispatch_async(dispatch_get_main_queue(), completionHandler);
                    //completionHandler();
                //}
            });
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
    
    //NSString *imgURL;
    NSString *title;
    
    for (NSManagedObject *route in routes) {
        title = [route valueForKey:@"title"];
        if ([self loadImage:title]) continue;
        //NSLog(@"%@", title);
        //NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        NSString *imgURL = [route valueForKey:@"imgURL"];
        NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString:imgURL]];
        //NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
        //NSLog(@"url to imageData: %f", (end-start));
        
        UIImage *image = [UIImage imageWithData:imageData];
        //NSLog(@"imageData to image %f", (end2 - end));
        // We store original images instead of cropped images since we want to use original images later.
        [self saveImage:image :title];

        NSTimeInterval end2 = [NSDate timeIntervalSinceReferenceDate];
        if (image){
            UIImage *greyImage = [self convertImageToGrayScale:image];
            NSString *greyTitle = [NSString stringWithFormat:@"grey%@", title];
            [self saveImage:greyImage :greyTitle];
        }
        NSTimeInterval end3 = [NSDate timeIntervalSinceReferenceDate];
        NSLog(@"save image %f", (end3 - end2));
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imageGenerated" object:[route valueForKey:@"id"]];
    }
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
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

- (NSInteger)numberOfImage{
    NSMutableArray *routes = [self mutableArrayUsingFetchRequest];
    NSInteger count = 0;
    NSString *title;
    for (Ride *ride in routes){
        title = ride.title;
        if ([self loadImage:title]) count ++;
    }
    return count;
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

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) deleteObject:(NSInteger)index{
    //self.managedObjectContext = [self managedObjectContext];
    Ride *ride = [self.currentRides objectAtIndex:index];
    [self.managedObjectContext deleteObject:ride];
}

- (void) deleteImage:(NSInteger)index{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    Ride *ride = [self.currentRides objectAtIndex:index];
    
    filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", ride.title]]; //[documentsDirectory stringByAppendingPathComponent:ride.title];
    [fileManager removeItemAtPath:filePath error:&error];
    NSString *greyFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"grey%@.png", ride.title]];
    if (greyFilePath){
        [fileManager removeItemAtPath:greyFilePath error:&error];
    }
}

- (void) putAlertView:(id)sender{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error"
                                                     message:@"No Internet Connection!"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert show];
}


@end
