//
//  LandingTableViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 3/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "LandingTableViewController.h"
#import "DescriptionsViewController.h"
#import "SWTableViewCell.h"
#import "DataManager.h"

@interface LandingTableViewController ()
@property (strong) NSManagedObject *routedb;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;

@end

@implementation LandingTableViewController
@synthesize routedb;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.cachedImages = [[NSMutableDictionary alloc] init];
    
    /*if ([self dataCount] == 0){
     [self executeParsing];
     [self dataCount];
     }*/
    
    //[self loadImage];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTableView) name:@"NotificationMessageEvent" object:nil];
    
    DataManager *dm = [[DataManager alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        self.routeArray = [dm fetchRequest];
        if (self.routeArray.count == 0){
            self.routeArray = [dm executeParsing];
        }
        //[self loadImage];
        //UIImage *blurImage = [UIImageEffects imageByApplyingLightEffectToImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
    
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

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

/*- (NSInteger)dataCount{
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Routes"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.routeArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    return self.routeArray.count;
}*/

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showRouteDetail" sender:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //tableView.rowHeight = 250;
    // Configure the cell...
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:100.0f];
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth: 100.f];
    //UIImage *completeImage = [UIImage imageNamed:@"CompletedStamp.png"];
    //cell.completeView = [[UIImageView alloc] initWithImage:completeImage];
    cell.completeView.hidden = TRUE;
    cell.delegate = self;
    
    
    NSManagedObject *device = [self.routeArray objectAtIndex:indexPath.row];
    
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
    
    
    if ([device valueForKey:@"imgData"]){
        NSData *imageData = [[NSData alloc] initWithData:[device valueForKey:@"imgData"]];
        UIImage *image = [UIImage imageWithData:imageData];
        CGRect croprect = CGRectMake(0, image.size.height / 4 , image.size.width, image.size.width/1.3);
        
        // Draw new image in current graphics context
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
        
        // Create new cropped UIImage
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        
        CGImageRelease(imageRef);
        
        cell.backgroundView = [[UIImageView alloc] initWithImage:croppedImage];
        cell.backgroundView.backgroundColor = [UIColor blackColor];
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSString *imgURL = [NSString stringWithFormat:@"%@", [device valueForKey:@"imgURL"]];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgURL]];
            [device setValue:imageData forKey:@"imgData"];
            
            DataManager *dm = [[DataManager alloc] init];
            
            NSManagedObjectContext *context = [dm managedObjectContext];
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            UIImage *image = [UIImage imageWithData:imageData];
            CGRect croprect = CGRectMake(0, image.size.height / 4 , image.size.width, image.size.width/1.3);
            
            // Draw new image in current graphics context
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
            
            // Create new cropped UIImage
            UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
            
            CGImageRelease(imageRef);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([tableView indexPathForCell:cell].row == indexPath.row){
                    
                    cell.backgroundView = [[UIImageView alloc] initWithImage: croppedImage];
                    cell.backgroundView.backgroundColor = [UIColor blackColor];
                    //cell.backgroundView.alpha = 0.5;
                }
            });
        });
        
        
    }
    
    
    /*if ([self.cachedImages objectForKey:[device valueForKey:@"title"]]){
     UIImage *image = [self.cachedImages objectForKey:[device valueForKey:@"title"]];
     CGRect croprect = CGRectMake(0, image.size.height / 4 , image.size.width, image.size.width/1.3);
     
     // Draw new image in current graphics context
     CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
     
     // Create new cropped UIImage
     UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
     
     CGImageRelease(imageRef);
     
     cell.backgroundView = [[UIImageView alloc] initWithImage:croppedImage];
     cell.backgroundView.backgroundColor = [UIColor blackColor];
     //cell.backgroundView.alpha = 0.5;
     }else{
     dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
     dispatch_async(queue, ^{
     //NSString *imgURL = [NSString stringWithFormat:@"%@", [device valueForKey:@"imgURL"]];
     //NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgURL]];
     NSData *imageData = [[NSData alloc] initWithData:[device valueForKey:@"imgURL"]];
     UIImage *image = [UIImage imageWithData:imageData];
     CGRect croprect = CGRectMake(0, image.size.height / 4 , image.size.width, image.size.width/1.3);
     
     // Draw new image in current graphics context
     CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
     
     // Create new cropped UIImage
     UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
     
     CGImageRelease(imageRef);
     
     dispatch_async(dispatch_get_main_queue(), ^{
     if ([tableView indexPathForCell:cell].row == indexPath.row){
     [self.cachedImages setObject:image forKey:[device valueForKey:@"title"]];
     cell.backgroundView = [[UIImageView alloc] initWithImage: croppedImage];
     cell.backgroundView.backgroundColor = [UIColor blackColor];
     //cell.backgroundView.alpha = 0.5;
     }
     });
     });
     }*/
    
    
    
    //cell.backgroundView = [[UIImageView alloc] initWithImage:[self.cachedImages objectForKey:[device valueForKey:@"title"]]];
    //cell.backgroundView.backgroundColor = [UIColor blackColor];
    //cell.backgroundView.alpha = 0.5;
    
    
    
    /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
     dispatch_async(queue, ^{
     NSString *url = [NSString stringWithFormat:@"%@", [device valueForKey:@"imgURL"]];
     NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:url]];
     UIImage *image = [UIImage imageWithData:imageData];
     dispatch_async(dispatch_get_main_queue(), ^{
     cell.backgroundView = [[UIImageView alloc] initWithImage:image];
     });
     });*/
    
    /*NSData *imageData = [[NSData alloc] initWithData:[device valueForKey:@"imgURL"]];
     UIImage *image = [UIImage imageWithData:imageData];
     CGRect croprect = CGRectMake(0, image.size.height / 4 , image.size.width, image.size.width/1.3);
     
     // Draw new image in current graphics context
     CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
     
     // Create new cropped UIImage
     UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
     cell.backgroundView = [[UIImageView alloc] initWithImage: croppedImage];
     CGImageRelease(imageRef);*/
    
    
    return cell;
    
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Complete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Uncomplete"];
    
    return rightUtilityButtons;
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"Complete button was pressed");
            //UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            //[alertTest show];
            cell.backgroundView.alpha = 0.5;
            cell.completeView.hidden = FALSE;
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"Complete button was pressed");
            //UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            //[alertTest show];
            cell.backgroundView.alpha = 1;
            cell.completeView.hidden = TRUE;
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
            
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}
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
