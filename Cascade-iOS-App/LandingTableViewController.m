//
//  LandingTableViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 3/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "LandingTableViewController.h"
#import "DescriptionsViewController.h"
#import "CustomLandingTableViewCell.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "Ride.h"

@interface LandingTableViewController ()

@property (strong) NSManagedObject *routedb;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;
@property (strong, nonatomic) DataManager *dm;
@property (nonatomic) CGRect croprect;
@property (nonatomic, strong) UIImage *placeholder;

@end

@implementation LandingTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dm = [[DataManager alloc] init];
    self.cachedImages = [[NSMutableDictionary alloc] init];
    self.tableView.rowHeight = self.view.frame.size.height * 0.43;
    self.view.backgroundColor = [UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1];
    //CGSize imgSizeHorizontal = CGSizeMake(10, 10);
    //self.placeholder = [self.dm imageWithImage:[UIImage imageNamed:@"loading.png"] scaledToSize:imgSizeHorizontal];
    self.placeholder = [UIImage imageNamed:@"loading 2.png"];
    /*
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
     */
    self.tableView.contentInset = UIEdgeInsetsMake(-45, 0, 0, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"imageGenerated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:@"greyimageGenerated" object:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasBeenLaunchedOnceKey"])
    {
        [self.dm updateTextFromServerWithCompletion:^{
            NSLog(@"text-based information update complete");
            //[self.dm generateImageFromURL];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable:) name:NSManagedObjectContextDidSaveNotification object:self.dm.managedObjectContext];
    }
    else{
        self.routeArray = [self.dm mutableArrayUsingFetchRequest];
        /*[self.tableView reloadData];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            [self.dm generateImageFromURL];
        });*/
        [self updateTable];
    }
}

- (void)reloadTable:(NSNotification *)notification
{
    if (self.routeArray == nil){
        self.routeArray = [self.dm mutableArrayUsingFetchRequest];
    }
    [self.tableView setNeedsDisplay];
    if ([[notification name] isEqualToString:@"imageGenerated"]){
        NSInteger number = [notification.object integerValue] - 1;
        NSIndexPath *index = [NSIndexPath indexPathForRow:number inSection:0];
        NSArray *indexArray = [NSArray arrayWithObjects:index, nil];
        [self.tableView performSelectorOnMainThread:@selector(reloadRowsAtIndexPaths:withRowAnimation:) withObject:indexArray waitUntilDone:NO];
        // This came from the background thread. Without performing in the main thread, cellForRowAtIndexPath will not be fired.
    }
    else if ([[notification name] isEqualToString:@"greyimageGenerated"]){
        //NSInteger number = [notification.object integerValue];
        //number = number - 1;
        //NSIndexPath *index = [NSIndexPath indexPathForRow:number inSection:0];
        //NSArray *indexArray = [NSArray arrayWithObjects:index, nil];
        //[self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
    else{
        //@synchronized(self.tableView){
        [self.tableView setNeedsDisplay];
        [self updateTable];
        //}
    }
}

- (void) updateTable {
    [self.tableView reloadData];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        [self.dm generateImageFromURL];
    });
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    CustomLandingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    cell.routeNameLabel.text = nil;
    if (cell == nil){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    cell.completeView.hidden = YES;
    cell.backgroundView = nil;
    
    NSManagedObject *device = [self.routeArray objectAtIndex:indexPath.row];
    UIImage *image;
    if (![self.dm loadImage:[device valueForKey:@"title"]]){
        //image = [[UIImage alloc] initWithCIImage:self.placeholder];
        cell.userInteractionEnabled = NO;
        cell.backgroundView = [[UIImageView alloc] initWithImage:self.placeholder];
        
        return cell;
    }
    cell.userInteractionEnabled = YES;
    
    // Configure the cell...
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:100.0f];
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth: 100.f];
    if([self.cachedImages valueForKey:[device valueForKey:@"title"]]){
        image = [self.cachedImages valueForKey:[device valueForKey:@"title"]];
    }else{
        
        NSString *title = [device valueForKey:@"title"];
        if ([[device valueForKey:@"complete"] integerValue] == 0){
            title = [device valueForKey:@"title"];
        }else{
            title = [NSString stringWithFormat:@"grey%@", [device valueForKey:@"title"]];
        }
        image = [self.dm loadImage:title];
        image = [self getCroppedImage:cell fromOriginalImage:image];
        [self.cachedImages setValue:image forKey:[device valueForKey:@"title"]];
        
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:image];
    //UIImage *grayBackGound = [self convertImageToGrayScale:image];
    
    [cell.routeNameLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"title"]]];
    cell.routeNameLabel.numberOfLines = 2;
    cell.routeNameLabel.lineBreakMode = 0;
    
    if ([[device valueForKey:@"complete"] integerValue] == 1) {
        //cell.backgroundView.alpha = 0.5;
        cell.completeView.hidden = FALSE;
        //cell.backgroundView = [[UIImageView alloc] initWithImage:grayBackGound];
    } else if ([[device valueForKey:@"complete"] integerValue]  == 0 ){
        //cell.backgroundView.alpha = 1;
        cell.completeView.hidden = TRUE;
        //cell.backgroundView = [[UIImageView alloc] initWithImage:image];
    }
    
    return cell;
}

- (UIImage *) getCroppedImage: (CustomLandingTableViewCell *) cell fromOriginalImage: (UIImage *) image {
    CGFloat cellWidth = cell.frame.size.width;
    CGFloat cellHeight = cell.frame.size.height;
    //if (CGRectIsEmpty(self.croprect)){
    //self.croprect = CGRectMake(0, image.size.height / 4 , image.size.width, image.size.width*cellHeight/cellWidth);
    //}
    //CGRect croprect = CGRectMake(0, image.size.height / 4 , image.size.width, image.size.width/1.3);
    CGRect croprect = CGRectMake(0, image.size.height / 5 , image.size.width, image.size.width*cellHeight/cellWidth);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], croprect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
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

- (void)swipeableTableViewCell:(CustomLandingTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"Complete button was pressed");
            //UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            //[alertTest show];
            //cell.backgroundView.alpha = 0.5;
            cell.completeView.hidden = FALSE;
            [cell hideUtilityButtonsAnimated:NO];
            //self.dm.routedb.complete = 1;
            
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            Ride *obj = [self.routeArray objectAtIndex:cellIndexPath.row];
            
            // Setting up grey image.
            NSString *title = [NSString stringWithFormat:@"grey%@", obj.title];
            UIImage *image;
            
            if ([self.dm loadImage:title]){
                image = [self.dm loadImage:title];
            }else{
                image = [self.dm loadImage:obj.title];
                image = [self convertImageToGrayScale:image];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                dispatch_async(queue, ^{
                    [self.dm saveImage:image :title];
                });
                
            }
            
            image = [self getCroppedImage:cell fromOriginalImage:image];
            [self.cachedImages setValue:image forKey:obj.title];
            //[self.cachedImages setValue:image forKey:[device valueForKey:@"title"]];
            
            
            
            //cell.backgroundView = [[UIImageView alloc] initWithImage:image];
            
            NSNumber *comp = [NSNumber numberWithInt:1];
            //obj.complete = comp;
            [obj setValue:comp forKey:@"complete"];
            NSError *error;
            [self.dm.managedObjectContext save:&error];
            NSNumber *i = [NSNumber numberWithInteger:obj.id - 1];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"greyimageGenerated" object:i];
            break;
        }
            
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swipeableTableViewCell:(CustomLandingTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"Uncomplete button was pressed");
            //UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            //[alertTest show];
            cell.backgroundView.alpha = 1;
            cell.completeView.hidden = TRUE;
            [cell hideUtilityButtonsAnimated:NO];
            
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            Ride *obj = [self.routeArray objectAtIndex:cellIndexPath.row];
            
            //UIImage *image = [self.cachedImages valueForKey:[obj valueForKey:@"title"]];
            NSString *title = obj.title;
            UIImage *image = [self.dm loadImage:obj.title];
            
            image = [self getCroppedImage:cell fromOriginalImage:image];
            [self.cachedImages setValue:image forKey:obj.title];
            
            //cell.backgroundView = [[UIImageView alloc] initWithImage:image];
            
            [self.cachedImages setValue:image forKey:title];
            
            //NSNumber *comp = [NSNumber numberWithInt:0];
            NSNumber *comp = [NSNumber numberWithInt:0];
            //obj.complete = comp;
            [obj setValue:comp forKey:@"complete"];
            NSError *error;
            
            [self.dm.managedObjectContext save:&error];
            
            NSNumber *i = [NSNumber numberWithInteger:obj.id - 1];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"greyimageGenerated" object:i];
            
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
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    NSManagedObject *obj = [self.routeArray objectAtIndex:cellIndexPath.row];
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            
            if ([[obj valueForKey:@"complete"] integerValue] == 0) {
                return NO;
            }
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            if ([[obj valueForKey:@"complete"] integerValue] == 1) {
                return NO;
            }
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


- (IBAction)unwindSegue:(UIStoryboardSegue *)segue {
    NSLog(@"segue worked");
    [self.tableView reloadData];
}

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
