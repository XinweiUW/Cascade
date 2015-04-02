//
//  LandingTableViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 3/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "LandingTableViewController.h"
#import "DescriptionsViewController.h"
#import "Delegate.h"

@interface LandingTableViewController ()
@property (strong) NSManagedObject *routedb;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;

@end

@implementation LandingTableViewController
@synthesize routedb;

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)executeParsing{
    @autoreleasepool {
        //NSString *file = @(__FILE__);
        //file = [[file stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Top_10_Rides_Content_pictureReplaced.csv"];
        //NSString *file;
        //file = @"https://drive.google.com/file/d/0BzxR2Xc3LZ7MRl9CSkJrUm5iLVU/view?usp=sharing";
        
        NSString *url = @"https://www.filepicker.io/api/file/7J6gqwDjSlWQXDy5fVPw";
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
        
        Delegate * d = [[Delegate alloc] init];
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
                NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Routes" inManagedObjectContext:context];
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
                [newDevice setValue:difficulties forKey:@"difficulties"];
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
            
            //NSError *error = nil;
            // Save the object to persistent store
            //if (![context save:&error]) {
            //    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            //}
        }
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.cachedImages = [[NSMutableDictionary alloc] init];
    
    if ([self dataCount] == 0){
        [self executeParsing];
        [self dataCount];
    }
    
    //[self loadImage];
    
    [self.tableView reloadData];
    NSLog(@"abc");
}

- (void)loadImage{
    
    for (NSManagedObject *obj in self.routeArray){
        
        NSString *imgURL = [obj valueForKey:@"imgURL"];
        NSString *str = [obj valueForKey:@"title"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgURL]];
            UIImage *image = [UIImage imageWithData:imageData];
            //UIImage *blurImage = [UIImageEffects imageByApplyingLightEffectToImage:image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cachedImages setObject: image forKey:str];
            });
        });
        
    }
}


- (NSInteger)dataCount{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Routes"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.routeArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return self.routeArray.count;
}

- (void)requestData{
    
    //NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Routes"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.routeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    tableView.rowHeight = 250;
    // Configure the cell...
    
    NSManagedObject *device = [self.routeArray objectAtIndex:indexPath.row];
    //[cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", [device valueForKey:@"fullname"], [device valueForKey:@"email"]]];
    //[cell.detailTextLabel setText:[device valueForKey:@"phone"]];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"title"]]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = 0;
    
    //UIImage *bgImage = [UIImage imageNamed:@"IDMXMmPB.jpeg"];
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"IDMXMmPB" ofType:@"jpeg"];
    //UIImage *bgImage =[[UIImage alloc] initWithContentsOfFile:path];
    //NSString *url = [NSString stringWithFormat:@"%@", [device valueForKey:@"imgURL"]];
    //NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:url]];
    //cell.backgroundView = [[UIImageView alloc] initWithImage: bgImage];
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
    
    //NSString *identifier = [NSString stringWithFormat:@"Cell%ld", (long)indexPath.row];
    
    //NSLog(identifier);
    if ([self.cachedImages objectForKey:[device valueForKey:@"title"]]){
        UIImage *image = [self.cachedImages objectForKey:[device valueForKey:@"title"]];
        //UIImage *blurImage = [UIImageEffects imageByApplyingLightEffectToImage:image];
        cell.backgroundView = [[UIImageView alloc] initWithImage:image];
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSString *imgURL = [NSString stringWithFormat:@"%@", [device valueForKey:@"imgURL"]];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgURL]];
            UIImage *image = [UIImage imageWithData:imageData];
            //UIImage *blurImage = [UIImageEffects imageByApplyingLightEffectToImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([tableView indexPathForCell:cell].row == indexPath.row){
                    [self.cachedImages setObject:image forKey:[device valueForKey:@"title"]];
                    cell.backgroundView = [[UIImageView alloc] initWithImage:image];
                }
            });
        });
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[self.cachedImages objectForKey:[device valueForKey:@"title"]]];
    
    
    
    
    
    /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
     dispatch_async(queue, ^{
     NSString *url = [NSString stringWithFormat:@"%@", [device valueForKey:@"imgURL"]];
     NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:url]];
     UIImage *image = [UIImage imageWithData:imageData];
     dispatch_async(dispatch_get_main_queue(), ^{
     cell.backgroundView = [[UIImageView alloc] initWithImage:image];
     });
     });*/
    
    return cell;

}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete object from database
        [context deleteObject:[self.routeArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.routeArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.tableView.separatorColor=[UIColor clearColor];
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showRouteDetail"]) {
        NSManagedObject *selectedDevice = [self.routeArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        DescriptionsViewController *destViewController = segue.destinationViewController;
        destViewController.routedb = selectedDevice;
    }

}


@end
