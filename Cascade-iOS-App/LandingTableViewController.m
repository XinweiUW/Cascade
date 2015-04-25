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
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [self.dm updateTextFromServerWithCompletion:^{
            NSLog(@"text-based information update complete");
            [self.dm generateImageFromURL];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:NSManagedObjectContextDidSaveNotification object:self.dm.managedObjectContext];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"imageGenerated" object:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else{
        self.routeArray = [self.dm fetchRequest];
        [self.tableView reloadData];
    }
}

- (void)reloadTable:(NSNotification *)notification
{
    if (self.routeArray == nil){
        self.routeArray = [self.dm fetchRequest];
    }
    [self.tableView setNeedsDisplay];
    if ([[notification name] isEqualToString:@"imageGenerated"]){
        NSInteger number = [notification.object integerValue] - 1;
        NSIndexPath *index = [NSIndexPath indexPathForRow:number inSection:0];
        NSArray *indexArray = [NSArray arrayWithObjects:index, nil];
        [self.tableView performSelectorOnMainThread:@selector(reloadRowsAtIndexPaths:withRowAnimation:) withObject:indexArray waitUntilDone:NO];
        // This came from the background thread. Without performing in the main thread, cellForRowAtIndexPath will not be fired.
    }else{
        @synchronized(self.tableView){
            [self.tableView setNeedsDisplay];
            [self.tableView reloadData];
        }
    }
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
    cell.backgroundView = nil;
    
    // Configure the cell...
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:100.0f];
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth: 100.f];

    cell.completeView.hidden = TRUE;
    cell.delegate = self;
    
    NSManagedObject *device = [self.routeArray objectAtIndex:indexPath.row];
    
    UIImage *image;
    if (![self.dm loadImage:[device valueForKey:@"title"]]){
        image = [UIImage imageNamed:@"loading.png"];
        cell.textLabel.text = @"";
        cell.backgroundView = [[UIImageView alloc] initWithImage:image];
        return cell;
    }else if([self.cachedImages valueForKey:[device valueForKey:@"title"]]){
        image = [self.cachedImages valueForKey:[device valueForKey:@"title"]];
    }else{
        image = [self.dm loadImage:[device valueForKey:@"title"]];
        [self.cachedImages setValue:image forKey:[device valueForKey:@"title"]];
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:image];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"title"]]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = 0;
    
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
