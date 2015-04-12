//
//  DataManager.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/12/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "DataManager.h"
#import "AppDelegate.h"


@implementation DataManager{
    NSMutableArray *_lines;
    NSMutableArray *_currentLine;
    
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

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (NSMutableArray *)executeParsing{
    @autoreleasepool {
        //NSString *file = @(__FILE__);
        //file = [[file stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Top_10_Rides_Content_pictureReplaced.csv"];
        //NSString *file;
        //file = @"https://drive.google.com/file/d/0BzxR2Xc3LZ7MRl9CSkJrUm5iLVU/view?usp=sharing";
        
        NSString *url = @"https://www.filepicker.io/api/file/B9uBaBZRTs2lmD5j2Ff8";
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSString *file = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] ;
        //NSString *robots = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://www.filepicker.io/api/file/w5eur5N6QmuK8znclVWf"] encoding:NSUTF8StringEncoding error:nil];
        //NSString *file = @"/var/mobile/Containers/Bundle/Application/31AB2441-9139-43B2-9722-C08C037EF052/MyContacts.app/Top_10_Rides_Content_pictureReplaced.csv";
        //NSString *file = @"https://www.filepicker.io/api/file/w5eur5N6QmuK8znclVWf";
        
        
        NSLog(@"Beginning...");
        NSStringEncoding encoding = 0;
        //NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:file];
        CHCSVParser * p = [[CHCSVParser alloc] initWithCSVString:file];
        [p setRecognizesBackslashesAsEscapes:YES];
        [p setSanitizesFields:YES];
        
        NSLog(@"encoding: %@", CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding)));
        
        DataManager * d = [[DataManager alloc] init];
        [p setDelegate:d];
        
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        [p parse];
        NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
        
        NSLog(@"raw difference: %f", (end-start));
        
        NSLog(@"%@", [d lines]);
        
        NSInteger size = [[d lines ]count];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        
        // extract contents in csv file and convert to core data
        for (NSInteger i = 1; i < size; i++){
            NSArray *temp = [[d lines] objectAtIndex:i];
            NSNumber *number = [NSNumber numberWithInt:i];
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
            
            if (!self.routedb){
                /*NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Routes" inManagedObjectContext:context];
                [newDevice setValue:number forKey:@"id"];
                [newDevice setValue:title forKey:@"title"];
                [newDevice setValue:distance forKey:@"distance"];
                [newDevice setValue:duration forKey:@"duration"];
                [newDevice setValue:terrain forKey:@"terrain"];
                [newDevice setValue:keyWords forKey:@"keyWords"];
                [newDevice setValue:shortOverview forKey:@"shortOverview"];
                [newDevice setValue:start forKey:@"start"];
                [newDevice setValue:finish forKey:@"finish"];
                [newDevice setValue:mapURL forKey:@"mapURL"];
                [newDevice setValue:roadCondition forKey:@"roadCondition"];
                [newDevice setValue:imgURL forKey:@"imgURL"];
                [newDevice setValue:attractions forKey:@"attractions"];
                [newDevice setValue:descriptions forKey:@"descriptions"];
                [newDevice setValue:turnByTurn forKey:@"turnByTurn"];
                [newDevice setValue:difficulties forKey:@"difficulties"];*/
                Rides *newRide = [NSEntityDescription insertNewObjectForEntityForName:@"Routes" inManagedObjectContext:context];
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
                
            }else{
                [self.routedb setValue:number forKey:@"id"];
                [self.routedb setValue:title forKey:@"title"];
                [self.routedb setValue:distance forKey:@"distance"];
                [self.routedb setValue:duration forKey:@"duration"];
                [self.routedb setValue:terrain forKey:@"terrain"];
                [self.routedb setValue:keyWords forKey:@"keyWords"];
                [self.routedb setValue:shortOverview forKey:@"shortOverview"];
                [self.routedb setValue:start forKey:@"start"];
                [self.routedb setValue:finish forKey:@"finish"];
                [self.routedb setValue:mapURL forKey:@"mapURL"];
                [self.routedb setValue:roadCondition forKey:@"roadCondition"];
                [self.routedb setValue:imgURL forKey:@"imgURL"];
                [self.routedb setValue:attractions forKey:@"attractions"];
                [self.routedb setValue:descriptions forKey:@"descriptions"];
                [self.routedb setValue:turnByTurn forKey:@"turnByTurn"];
                [self.routedb setValue:difficulties forKey:@"difficulties"];
            }
        }
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Routes"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        
        return [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
    }
}



@end
