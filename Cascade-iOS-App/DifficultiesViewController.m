//
//  DifficultiesViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/24/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "DifficultiesViewController.h"
#import "LandingTableViewController.h"

@interface DifficultiesViewController ()

@end

@implementation DifficultiesViewController
@synthesize routedb;

- (void)viewDidLoad {
    CGFloat selfViewWidth = self.view.frame.size.width;
    CGFloat selfViewHeight = self.view.frame.size.height;
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBar.backItem.title = @"Custom text";
    
    self.dm = [[DataManager alloc] init];
    UIImage *backgroundImage = [self.dm loadImage:[self.routedb valueForKey:@"title"]];
    
    
    CGRect croprect = CGRectMake(backgroundImage.size.width/6, 0 , backgroundImage.size.height/2, backgroundImage.size.height);
    //Draw new image in current graphics context
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([backgroundImage CGImage], croprect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    UIImageView * backgroundView  =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth, selfViewHeight)];
    [backgroundView setImage:croppedImage];
    [self.view addSubview:backgroundView];

    UIImageView *distanceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.15 * selfViewWidth, 0.2 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [distanceIcon setImage:[UIImage imageNamed:@"distance.png"]];
    [backgroundView addSubview:distanceIcon];
    [self setLabel:distanceIcon connectWithValue:@"distance"];
    
    
    UIImageView *durationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.4 * selfViewWidth, 0.35 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [durationIcon setImage:[UIImage imageNamed:@"time.png"]];
    [backgroundView addSubview:durationIcon];
    [self setLabel:durationIcon connectWithValue:@"duration"];
    
    UIImageView *terrainIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.4 * selfViewWidth, 0.55 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [terrainIcon setImage:[UIImage imageNamed:@"terrain.png"]];
    [backgroundView addSubview:terrainIcon];
    [self setLabel:terrainIcon connectWithValue:@"terrain"];
    
    UIImageView *roadConditionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.15 * selfViewWidth, 0.7 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [roadConditionIcon setImage:[UIImage imageNamed:@"road condition.png"]];
    [backgroundView addSubview:roadConditionIcon];
    [self setLabel:roadConditionIcon connectWithValue:@"roadCondition"];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, 60)];
    [self.view addSubview:navBar];
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(flipView)];
   
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    item.leftBarButtonItem = flipButton;
    [navBar pushNavigationItem:item animated:NO];
    
}

- (void) setLabel: (UIImageView *) iconImageView connectWithValue: (NSString *)valueName {
    CGFloat originX = iconImageView.frame.origin.x + iconImageView.frame.size.width * 1.1;
    CGFloat originY = iconImageView.frame.origin.y;
    CGFloat labelWidth = iconImageView.frame.size.width * 4;
    CGFloat labelHeight = iconImageView.frame.size.height;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    [label setTextAlignment:NSTextAlignmentLeft];
    label.text = [self.routedb valueForKey:valueName];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:21.0f];
    label.numberOfLines = 2;
    label.lineBreakMode = 0;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)flipView{
    //LandingTableViewController *vc = [[LandingTableViewController alloc] initWithNibName:@"LandingTableViewController" bundle:nil];
    //[self.navigationController pushViewController:vc animated:YES];
    [self performSegueWithIdentifier:@"showLandingTableView" sender:self];
}

- (void)swipeDown:(UISwipeGestureRecognizer *)gestureRecognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"backToDescriptionSegue"]) {
        //NSManagedObject *selectedDevice = [self.routeArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        DescriptionsViewController *destViewController = segue.destinationViewController;
        destViewController.routedb = self.routedb;
    }

}


@end
