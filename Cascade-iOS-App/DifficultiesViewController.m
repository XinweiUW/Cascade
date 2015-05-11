//
//  DifficultiesViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/24/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "DifficultiesViewController.h"
#import "LandingTableViewController.h"
#import "DSNavigationBar.h"
#define iPhone5Height 568

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
    
    iconX = 0.11 * selfViewWidth;
    iconY = 0.33 * selfViewHeight;
    iconDistance = 0.15 * selfViewHeight;
    iconWidth = 0.15 * selfViewWidth;
    
    /*
    UIImageView *difficultyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX - iconWidth * 0.5, 0.15 * selfViewHeight, iconWidth*2, iconWidth*2)];
    [difficultyIcon setImage:[UIImage imageNamed:@"medium 1.png"]];
    [self.view addSubview:difficultyIcon];
     */
    [self setDifficultyImageAndLabel];
    
    UIImageView *distanceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconWidth, iconWidth)];
    [distanceIcon setImage:[UIImage imageNamed:@"distance 1.png"]];
    [self.view addSubview:distanceIcon];
    [self setLabel:distanceIcon connectWithValue:@"distance"];
    
    UIImageView *durationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY + iconDistance, iconWidth, iconWidth)];
    [durationIcon setImage:[UIImage imageNamed:@"time 1.png"]];
    [self.view addSubview:durationIcon];
    [self setLabel:durationIcon connectWithValue:@"duration"];
    
    UIImageView *terrainIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY + iconDistance*2, iconWidth, iconWidth)];
    [terrainIcon setImage:[UIImage imageNamed:@"terrain 1.png"]];
    [self.view addSubview:terrainIcon];
    [self setLabel:terrainIcon connectWithValue:@"terrain"];
    
    UIImageView *roadConditionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY + iconDistance * 3, iconWidth, iconWidth)];
    [roadConditionIcon setImage:[UIImage imageNamed:@"road condition 1.png"]];
    [self.view addSubview:roadConditionIcon];
    [self setLabel:roadConditionIcon connectWithValue:@"roadCondition"];
    
    //[self setDifficultyLabelWith:distanceIcon andRoadConditionIcon:roadConditionIcon];
    
    [self setNavigationBar];
    [self setLastPageButton];
    [self setNextPageButton];
    
    //UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    /*UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(flipView)];*/
   /*
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    //item.leftBarButtonItem = flipButton;
    item.leftBarButtonItem = backButtonItem;
    [navBar pushNavigationItem:item animated:NO];
    */
    
}

- (void) setDifficultyImageAndLabel {
    UIImageView *difficultyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX - iconWidth * 0.5, 0.15 * selfViewHeight, iconWidth*2, iconWidth*2)];
    NSString *difficultyText = [self.routedb valueForKey:@"difficulties"];
    difficultyText = [difficultyText uppercaseString];
    NSString *imageName;
    if ([difficultyText containsString:@"EASY"]) {
        imageName = @"easy 1.png";
    } else if ([difficultyText containsString:@"MEDIUM"]) {
        imageName = @"medium 1.png";
    } else {
        imageName = @"hard 1.png";
    }
    [difficultyIcon setImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:difficultyIcon];
    
    CGFloat originX = 0.3 * selfViewWidth;
    CGFloat originY = difficultyIcon.frame.origin.y - difficultyIcon.frame.size.width * 0.2;
    CGFloat labelWidth = difficultyIcon.frame.size.width * 4;
    CGFloat labelHeight = difficultyIcon.frame.size.height * 1.5;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    //label.backgroundColor = [UIColor grayColor];
    [label setTextAlignment:NSTextAlignmentLeft];
    label.text = difficultyText;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:22.0f * selfViewHeight/iPhone5Height];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    
}

- (void) setLastPageButton {
    CGFloat arrowX = 0;
    CGFloat arrowY = 46;
    CGFloat arrowWidth = selfViewWidth;
    CGFloat arrowHeight = selfViewHeight * 0.07;
    UIButton * lastPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastPageButton setFrame:CGRectMake(arrowX, arrowY, arrowWidth, arrowHeight)];
    lastPageButton.backgroundColor = [UIColor clearColor];
    [lastPageButton setImage:[UIImage imageNamed:@"last page arrow 4.png"] forState:UIControlStateNormal];
    [lastPageButton addTarget:self action:@selector(goToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastPageButton];
}


- (void) setNextPageButton {
    CGFloat arrowX = 0;
    CGFloat arrowY = 0.93 * selfViewHeight;
    CGFloat arrowWidth =selfViewWidth;
    CGFloat arrowHeight = selfViewHeight * 0.07;
    UIButton * nextPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextPageButton setFrame:CGRectMake(arrowX, arrowY, arrowWidth, arrowHeight)];
    nextPageButton.backgroundColor = [UIColor clearColor];
    [nextPageButton setImage:[UIImage imageNamed:@"next page arrow 3.png"] forState:UIControlStateNormal];
    [nextPageButton addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextPageButton];
}

- (void) goToLastPage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) goToNextPage {
    [self performSegueWithIdentifier:@"showRouteMapSegue" sender:self];
}

- (void) setNavigationBar {
    DSNavigationBar *navBar = [[DSNavigationBar alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, 46)];
    [self.view addSubview:navBar];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(selfViewWidth * 0.027, -navBar.frame.size.height * 0.1, navBar.frame.size.height*1.51, navBar.frame.size.height*1.12)];
    [backButton setImage:[UIImage imageNamed:@"back 3 layer.png"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backButton];
}

- (void) setDifficultyLabelText: (UILabel *)label withStarStrings: (NSString *)starString {
    if ([starString isEqualToString:@"*"]) {
        label.text = @"Easy";
    } else if ([starString isEqualToString:@"**"]) {
        label.text = @"Medium";
    } else {
        label.text = @"Hard";
    }
}

- (void) setBackground {
    self.dm = [[DataManager alloc] init];
    UIImage *backgroundImage = [self.dm loadImage:[self.routedb valueForKey:@"title"]];
    
    
    CGRect croprect = CGRectMake(backgroundImage.size.width/7, 0 , backgroundImage.size.height/2, backgroundImage.size.height);
    //Draw new image in current graphics context
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([backgroundImage CGImage], croprect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    UIImageView * backgroundView  =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth, selfViewHeight)];
    [backgroundView setImage:croppedImage];
    [self.view addSubview:backgroundView];
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = 0.4;
    effectView.frame = self.view.bounds;
    [backgroundView addSubview:effectView];

}

- (void) setLabel: (UIImageView *) iconImageView connectWithValue: (NSString *)valueName {
    //CGFloat originX = iconImageView.frame.origin.x + iconImageView.frame.size.width * 1.3;
    CGFloat originX = 0.3 * selfViewWidth;
    CGFloat originY = iconImageView.frame.origin.y - iconImageView.frame.size.width * 0.2;
    CGFloat labelWidth = iconImageView.frame.size.width * 4;
    CGFloat labelHeight = iconImageView.frame.size.height * 1.5;
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, labelWidth, labelHeight)];
    //label.backgroundColor = [UIColor grayColor];
    [label setTextAlignment:NSTextAlignmentLeft];
    label.text = [self.routedb valueForKey:valueName];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:18.0f * selfViewHeight/iPhone5Height];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)backToMenu{
    //LandingTableViewController *vc = [[LandingTableViewController alloc] initWithNibName:@"LandingTableViewController" bundle:nil];
    //[self.navigationController pushViewController:vc animated:YES];
    [self performSegueWithIdentifier:@"unwindFromDifficulty" sender:self];
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
