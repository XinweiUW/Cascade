//
//  RouteMapViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "RouteMapViewController.h"
#import "LandingTableViewController.h"
#import "DSNavigationBar.h"
#import "TurnByTurnViewController.h"
#import "GCNetworkReachability.h"
#define iPhone5Height 568


@interface RouteMapViewController ()

@end

@implementation RouteMapViewController

- (void)viewDidLoad {
    self.dm = [[DataManager alloc] init];
    selfViewWidth = self.view.frame.size.width;
    selfViewHeight = self.view.frame.size.height;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackground];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    /*
    DSNavigationBar *navBar = [[DSNavigationBar alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, 50)];
    [self.view addSubview:navBar];
    
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //backButton.bounds = CGRectMake( 0, 0, backImage.size.width, backImage.size.height );
    [backButton setFrame:CGRectMake(0, 0, navBar.frame.size.height/3, navBar.frame.size.height/2.5)];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
     
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    //item.leftBarButtonItem = flipButton;
    item.leftBarButtonItem = backButtonItem;
    [navBar pushNavigationItem:item animated:NO];
    */
    allowLoad = YES;
    [self setNavigationBar];
    
    
    [self loadMapView];
    [self setLastPageButton];
    [self setNextPageButton];
    
    GCNetworkReachability *reachability = [GCNetworkReachability reachabilityForInternetConnection];
    if (![reachability isReachable]){
        [self.dm putAlertView:self];
    }
    
}

- (void) setLastPageButton {
    CGFloat arrowX = 0;
    CGFloat arrowY = 46;
    CGFloat arrowWidth = selfViewWidth;
    CGFloat arrowHeight = selfViewHeight * 0.07;
    UIButton * lastPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastPageButton setFrame:CGRectMake(arrowX, arrowY, arrowWidth, arrowHeight)];
    lastPageButton.backgroundColor = [UIColor colorWithRed:(68/255.0) green:(68/255.0) blue:(68/255.0) alpha:1.0f];
    [lastPageButton setImage:[UIImage imageNamed:@"last page arrow 4.png"] forState:UIControlStateNormal];
    [lastPageButton addTarget:self action:@selector(goToLastPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastPageButton];
}

- (void) goToLastPage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setNextPageButton {
    CGFloat arrowX = 0;
    CGFloat arrowY = webView.frame.origin.y + webView.frame.size.height;
    CGFloat arrowWidth =selfViewWidth;
    CGFloat arrowHeight = selfViewHeight - arrowY;
    UIButton * nextPageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextPageButton setFrame:CGRectMake(arrowX, arrowY, arrowWidth, arrowHeight)];
    nextPageButton.backgroundColor = [UIColor clearColor];
    [nextPageButton addTarget:self action:@selector(goToNextPage) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *startPoint = [self.routedb valueForKey:@"start"];
    [nextPageButton setTitle:startPoint forState:UIControlStateNormal];
    nextPageButton.titleLabel.backgroundColor = [UIColor clearColor];
    nextPageButton.titleLabel.lineBreakMode = 0;
    nextPageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    nextPageButton.contentEdgeInsets = UIEdgeInsetsMake(0, 71 * selfViewHeight/iPhone5Height, 0, 0);
    nextPageButton.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:nextPageButton];
    
    UIImage *startImage = [UIImage imageNamed:@"attraction 1.png"];
    UIImageView *startView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowHeight * 0.22, arrowHeight * 0.2, arrowHeight * 0.6, arrowHeight * 0.6)];
    [startView setImage:startImage];
    [nextPageButton addSubview:startView];
}

- (void) goToNextPage {
    [self performSegueWithIdentifier:@"showTurnByTurnSegue" sender:self];
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



- (void) loadMapView {
    UIImageView *arrowBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 46, selfViewWidth, selfViewHeight * 0.12 - 46)];
    arrowBackground.backgroundColor = [UIColor colorWithRed:(32/255.0) green:(32/255.0) blue:(32/255) alpha:1.0f];
    //[self.view addSubview:arrowBackground];
    
    webView =[[UIWebView alloc] initWithFrame:CGRectMake(0,46,selfViewWidth,selfViewHeight * 0.8)];
    
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    NSString *urlAddress = [self.routedb valueForKey:@"mapURL"];
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    //Load the request in the UIWebView.
    [webView loadRequest:requestObj];
    [self.view addSubview:webView];
    
    CGFloat buttonX = 0.72 * selfViewWidth;
    CGFloat buttonY = 0.87 * webView.frame.size.height;
    CGFloat buttonWidth = 0.15 * selfViewWidth;
    
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonWidth)];
    [resetButton setImage:[UIImage imageNamed:@"back to original 2.png"] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetMap) forControlEvents:UIControlEventTouchUpInside];
    [webView addSubview:resetButton];
}

- (void) resetMap {
    allowLoad = YES;
    [webView reload];
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    return allowLoad;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    allowLoad = NO;
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
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = 0.4;
    effectView.frame = self.view.bounds;
    [backgroundView addSubview:effectView];

    
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
    if ([[segue identifier] isEqualToString:@"showTurnByTurnSegue"]) {
        //NSManagedObject *selectedDevice = [self.routeArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        TurnByTurnViewController *destViewController = segue.destinationViewController;
        destViewController.routedb = self.routedb;
    }
    
}


@end
