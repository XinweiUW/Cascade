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
#import "AppDelegate.h"

@interface LandingTableViewController ()

@property (strong) NSManagedObject *routedb;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;
@property (strong, nonatomic) DataManager *dm;
@property id plist;

@end

@implementation LandingTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.dm = [[DataManager alloc] init];
    self.cachedImages = [[NSMutableDictionary alloc] init];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]){

        [self.dm updateFromServerWithCompletion:^{
            NSLog(@"datastore update complete");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:NSManagedObjectContextDidSaveNotification object:self.dm.managedObjectContext];
    }
    else{
        self.routeArray = [self.dm fetchRequest];
        [self.tableView reloadData];
    }
}

- (void)reloadTable:(NSNotification *)notification
{
    //NSError *error;
    self.routeArray = [self.dm fetchRequest];
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
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
    
    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    cell.backgroundView = nil;//[[UIImageView alloc] init];

    //CGAffineTransform transform = cell.completeView.transform;
    
    // Rotate the view 45 degrees (the actual function takes radians)
    //transform = CGAffineTransformRotate(transform, (-M_PI / 5));
    //cell.completeView.transform = transform;
    cell.completeView.hidden = YES;
    
    NSManagedObject *device = [self.routeArray objectAtIndex:indexPath.row];
    /*if ([[device valueForKey:@"complete"] integerValue] == 1) {
        cell.backgroundView.alpha = 0.5;
        cell.completeView.hidden = FALSE;
    } else if ([[device valueForKey:@"complete"] integerValue]  == 0){
        cell.backgroundView.alpha = 1;
        cell.completeView.hidden = TRUE;
    }
    [cell hideUtilityButtonsAnimated:YES];*/
    
    // Configure the cell...
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:80.0f];
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth: 80.f];

    //cell.completeView.hidden = TRUE;
    cell.delegate = self;
    cell.routeNameLabel.numberOfLines = 2;
    cell.routeNameLabel.lineBreakMode = 0;
    //[cell.textLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"title"]]];
    [cell.routeNameLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"title"]]];
    
    //if ([self.cachedImages valueForKey:[device valueForKey:@"title"]]){
    if ([self.dm loadImage:[device valueForKey:@"title"]]){

        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            
            UIImage *image;
            if ([self.cachedImages valueForKey:[device valueForKey:@"title"]]){
                image = [self.cachedImages valueForKey:[device valueForKey:@"title"]];
            }else{
                image = [self.dm loadImage:[device valueForKey:@"title"]];
                CGRect croprect = CGRectMake(0, image.size.height / 4 , image.size.width, image.size.width/1.3);
                
                // Draw new image in current graphics context
                CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
                UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
                image = croppedImage;
                [self.cachedImages setValue:image forKey:[device valueForKey:@"title"]];
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
                //cell.backgroundView = nil;
                cell.backgroundView = [[UIImageView alloc] initWithImage:image];
                //cell.backgroundView = [[UIImageView alloc] initWithImage:image];
                
                if ([[device valueForKey:@"complete"] integerValue] == 1) {
                    cell.backgroundView.alpha = 0.5;
                    cell.completeView.hidden = FALSE;
                } else if ([[device valueForKey:@"complete"] integerValue] == 0 ){
                    cell.backgroundView.alpha = 1;
                    cell.completeView.hidden = TRUE;
                }
                [cell hideUtilityButtonsAnimated:YES];
                
            });
        });
    
    }else{
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            
            NSString *imgURL = [NSString stringWithFormat:@"%@", [device valueForKey:@"imgURL"]];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgURL]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            CGRect croprect = CGRectMake(0, image.size.height / 4 , image.size.width, image.size.width/1.3);
            
            // Draw new image in current graphics context
            CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
            UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
            
            [self.cachedImages setValue:croppedImage forKey: [device valueForKey:@"title"]];
            [self.dm saveImage:image :[device valueForKey:@"title"]];
            CGImageRelease(imageRef);
            // Create new cropped UIImage
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self.cachedImages setValue:[self.dm loadImage:[device valueForKey:@"title"]] forKey: [device valueForKey:@"title"]];
                //cell.backgroundView = [[UIImageView alloc] initWithImage:image];

                //cell.backgroundView = nil;
                
                cell.backgroundView = [[UIImageView alloc] initWithImage:croppedImage];
                
                if ([[device valueForKey:@"complete"] integerValue] == 1) {
                    cell.backgroundView.alpha = 0.5;
                    cell.completeView.hidden = FALSE;
                } else if ([[device valueForKey:@"complete"] integerValue] == 0 ){
                    cell.backgroundView.alpha = 1;
                    cell.completeView.hidden = TRUE;
                }
                [cell hideUtilityButtonsAnimated:YES];
            });
        });
    }
    
    return cell;
    
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0]
                                                title:@"Done"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:102/255.0f green:205/255.0f blue:102/255.0f alpha:1.0]
                                                title:@"Reset"];
    
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
            //self.dm.routedb.complete = 1;
            
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            NSManagedObject *obj = [self.routeArray objectAtIndex:cellIndexPath.row];
            
            NSNumber *comp = [NSNumber numberWithInt:1];
            [obj setValue:comp forKey:@"complete"];
            NSError *error;
            [self.dm.managedObjectContext save:&error];
            break;
        }
        
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"Uncomplete button was pressed");
            //UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            //[alertTest show];
            cell.backgroundView.alpha = 1;
            cell.completeView.hidden = TRUE;
            [cell hideUtilityButtonsAnimated:YES];
            
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            NSManagedObject *obj = [self.routeArray objectAtIndex:cellIndexPath.row];
            
            NSNumber *comp = [NSNumber numberWithInt:0];
            [obj setValue:comp forKey:@"complete"];
            NSError *error;
            [self.dm.managedObjectContext save:&error];
            break;
        }
            
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
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
