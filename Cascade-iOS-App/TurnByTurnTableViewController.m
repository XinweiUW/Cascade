//
//  TurnByTurnTableViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 5/2/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "TurnByTurnTableViewController.h"
#import "TurnByTurnTableViewCell.h"
#import "DataManager.h"

@interface TurnByTurnTableViewController ()

@property (nonatomic,strong) NSArray *turns;
@property (strong, nonatomic) DataManager *dm;

@end

@implementation TurnByTurnTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //selfViewWidth = self.view.frame.size.width;
    //selfViewHeight = self.view.frame.size.height;
    
    [self setBackground];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    NSString *turnByTurn = [self.routedb valueForKey:@"turnByTurnText"];
    self.turns = [turnByTurn componentsSeparatedByString:@";"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setBackground {
    self.dm = [[DataManager alloc] init];
    UIImage *backgroundImage = [self.dm loadImage:[self.routedb valueForKey:@"title"]];
    
    
    CGRect croprect = CGRectMake(backgroundImage.size.width/6, 0 , backgroundImage.size.height/2, backgroundImage.size.height);
    //Draw new image in current graphics context
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([backgroundImage CGImage], croprect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    UIImageView * backgroundView  =[[UIImageView alloc]initWithImage:croppedImage];
    //[backgroundView setImage:croppedImage];
    //[self.view addSubview:backgroundView];
    //self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.opaque = YES;
    self.tableView.backgroundView = backgroundView;
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:croppedImage];
}

- (void)swipeDown:(UISwipeGestureRecognizer *)gestureRecognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backToMenu{
    //LandingTableViewController *vc = [[LandingTableViewController alloc] initWithNibName:@"LandingTableViewController" bundle:nil];
    //[self.navigationController pushViewController:vc animated:YES];
    [self performSegueWithIdentifier:@"unwindFromTurnByTurn" sender:self];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.turns.count;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset1 = scrollView.contentOffset;
    CGRect bounds1 = scrollView.bounds;
    //CGSize size1 = scrollView.contentSize;
    UIEdgeInsets inset1 = scrollView.contentInset;
    float y1 = offset1.y + bounds1.size.height - inset1.bottom;
    //NSLog(@"%f", y1);
    //float h1 = size1.height;
    NSLog(@"%f", self.tableView.frame.size.height);
    //NSLog(@"%f", self.tableView.frame.size.height / 10 * 9);
    if (y1 < self.tableView.frame.size.height / 10 * 9) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    TurnByTurnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    UIImage *img = [UIImage imageNamed:@"arrow-up.png"];
    cell.arrowView = [[UIImageView alloc] initWithImage:img];
    cell.arrowView.backgroundColor =[UIColor whiteColor];
    
    cell.direction.lineBreakMode = 0;
    cell.direction.numberOfLines = 2;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.direction setFont:[UIFont fontWithName:@"Arial" size:16]];
    [cell.distance setFont:[UIFont fontWithName:@"Arial" size:10]];
    cell.direction.textColor = [UIColor whiteColor];
    cell.distance.textColor = [UIColor whiteColor];
    
    NSString *turn = [self.turns objectAtIndex:indexPath.row];
    
    cell.userInteractionEnabled = NO;
    if ([turn containsString:@"Start"] || [turn containsString:@"End"] || ![turn containsString:@"&"])
    {
        //cell.textLabel.text = turn;
        //cell.detailTextLabel.text = nil;
        cell.direction.text = turn;
        cell.distance.text = nil;
        return cell;
    }
    NSArray *arr = [[self.turns objectAtIndex:indexPath.row] componentsSeparatedByString:@"&"];
    cell.direction.text = [arr objectAtIndex:0];
    cell.distance.text = [arr objectAtIndex:1];
    
    // Configure the cell...
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
