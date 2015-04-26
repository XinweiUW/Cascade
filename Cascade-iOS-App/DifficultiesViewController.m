//
//  DifficultiesViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/24/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "DifficultiesViewController.h"

@interface DifficultiesViewController ()

@end

@implementation DifficultiesViewController
@synthesize routedb;

- (void)viewDidLoad {
    CGFloat selfViewWidth = self.view.frame.size.width;
    CGFloat selfViewHeight = self.view.frame.size.height;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBar.backItem.title = @"Custom text";
    
    self.dm = [[DataManager alloc] init];
    UIImage *backgroundImage = [self.dm loadImage:[self.routedb valueForKey:@"title"]];
    
    
    CGRect croprect = CGRectMake(backgroundImage.size.width/6, 0 , backgroundImage.size.height/2, backgroundImage.size.height);
    //Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect([backgroundImage CGImage], croprect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    UIImageView *backgroundView  =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth, selfViewHeight)];
    [backgroundView setImage:croppedImage];
    [self.view addSubview:backgroundView];
    
    UIImageView *distanceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.15 * selfViewWidth, 0.15 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [distanceIcon setImage:[UIImage imageNamed:@"5-distance.png"]];
    [backgroundView addSubview:distanceIcon];
    
    UIImageView *durationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.4 * selfViewWidth, 0.3 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [durationIcon setImage:[UIImage imageNamed:@"6-duration.png"]];
    [backgroundView addSubview:durationIcon];
    
    UIImageView *terrainIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.4 * selfViewWidth, 0.5 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [terrainIcon setImage:[UIImage imageNamed:@"7-terrain.png"]];
    [backgroundView addSubview:terrainIcon];
    
    UIImageView *roadConditionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.15 * selfViewWidth, 0.65 * selfViewHeight, 0.15 * selfViewWidth, 0.15 * selfViewWidth)];
    [roadConditionIcon setImage:[UIImage imageNamed:@"8-road condition.png"]];
    [backgroundView addSubview:roadConditionIcon];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
