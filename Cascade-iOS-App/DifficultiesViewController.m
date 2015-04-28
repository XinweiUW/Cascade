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
    selfViewWidth = self.view.frame.size.width;
    selfViewHeight = self.view.frame.size.height;
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBar.backItem.title = @"Custom text";
    
    [self setBackground];
    
    UIImageView *distanceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.15 * selfViewWidth, 0.2 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [distanceIcon setImage:[UIImage imageNamed:@"distance.png"]];
    [self.view addSubview:distanceIcon];
    [self setLabel:distanceIcon connectWithValue:@"distance"];
    
    UIImageView *durationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.4 * selfViewWidth, 0.35 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [durationIcon setImage:[UIImage imageNamed:@"time.png"]];
    [self.view addSubview:durationIcon];
    [self setLabel:durationIcon connectWithValue:@"duration"];
    
    UIImageView *terrainIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.4 * selfViewWidth, 0.55 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [terrainIcon setImage:[UIImage imageNamed:@"terrain.png"]];
    [self.view addSubview:terrainIcon];
    [self setLabel:terrainIcon connectWithValue:@"terrain"];
    
    UIImageView *roadConditionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.15 * selfViewWidth, 0.7 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [roadConditionIcon setImage:[UIImage imageNamed:@"road condition.png"]];
    [self.view addSubview:roadConditionIcon];
    [self setLabel:roadConditionIcon connectWithValue:@"roadCondition"];
    
    [self setDifficultyLabelWith:distanceIcon andRoadConditionIcon:roadConditionIcon];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, 60)];
    [self.view addSubview:navBar];
    
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //backButton.bounds = CGRectMake( 0, 0, backImage.size.width, backImage.size.height );
    [backButton setFrame:CGRectMake(0, 0, navBar.frame.size.height/2.5, navBar.frame.size.height/2)];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    /*
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(flipView)];
   */
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    //item.leftBarButtonItem = flipButton;
    item.leftBarButtonItem = backButtonItem;
    [navBar pushNavigationItem:item animated:NO];
    
}

- (void) setDifficultyLabelWith: (UIImageView *) distanceIcon andRoadConditionIcon: (UIImageView *) roadConditionIcon{
    CGFloat originX = distanceIcon.frame.origin.x;
    CGFloat originY = (distanceIcon.frame.origin.y + roadConditionIcon.frame.origin.y)/2;
    CGFloat labelWidth = distanceIcon.frame.size.width * 2;
    CGFloat labelHeight = distanceIcon.frame.size.height;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    [label setTextAlignment:NSTextAlignmentLeft];
    label.text = [self.routedb valueForKey:@"difficulties"];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:21.0f];
    label.numberOfLines = 2;
    label.lineBreakMode = 0;
    [self.view addSubview:label];

}

- (void) setBackground {
    self.dm = [[DataManager alloc] init];
    UIImage *backgroundImage = [self.dm loadImage:[self.routedb valueForKey:@"title"]];
    
    
    CGRect croprect = CGRectMake(backgroundImage.size.width/6, 0 , backgroundImage.size.height/2, backgroundImage.size.height);
    //Draw new image in current graphics context
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([backgroundImage CGImage], croprect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    UIImageView * backgroundView  =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth, selfViewHeight)];
    [backgroundView setImage:croppedImage];
    [self.view addSubview:backgroundView];

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


- (void)backToMenu{
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
    if ([[segue identifier] isEqualToString:@"showRouteMapSegue"]) {
        //NSManagedObject *selectedDevice = [self.routeArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        DifficultiesViewController *destViewController = segue.destinationViewController;
        destViewController.routedb = self.routedb;
    }

}


@end
