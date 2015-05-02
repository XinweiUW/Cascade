//
//  RouteMapViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "RouteMapViewController.h"
#import "LandingTableViewController.h"

@interface RouteMapViewController ()

@end

@implementation RouteMapViewController

- (void)viewDidLoad {
    selfViewWidth = self.view.frame.size.width;
    selfViewHeight = self.view.frame.size.height;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackground];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    /*UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, 60)];
    [self.view addSubview:navBar];
    
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //backButton.bounds = CGRectMake( 0, 0, backImage.size.width, backImage.size.height );
    [backButton setFrame:CGRectMake(0, 0, navBar.frame.size.height/3, navBar.frame.size.height/2.5)];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
     UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
     initWithTitle:@"Back"
     style:UIBarButtonItemStylePlain
     target:self
     action:@selector(flipView)];
     */
    //UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    //item.leftBarButtonItem = flipButton;
    /*item.leftBarButtonItem = backButtonItem;
    [navBar pushNavigationItem:item animated:NO];*/
    [self loadMapView];
}

- (void) loadMapView {
    
    UIWebView *webView =[[UIWebView alloc] initWithFrame:CGRectMake(0,60,selfViewWidth,self.view.frame.size.height - 120)];
    
    webView.scalesPageToFit = YES;
    
    NSString *urlAddress = [self.routedb valueForKey:@"mapURL"];
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
    [self.view addSubview:webView];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)swipeDown:(UISwipeGestureRecognizer *)gestureRecognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)backToMenu{
    //LandingTableViewController *vc = [[LandingTableViewController alloc] initWithNibName:@"LandingTableViewController" bundle:nil];
    //[self.navigationController pushViewController:vc animated:YES];
    [self performSegueWithIdentifier:@"unwindFromRouteMap" sender:self];
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
