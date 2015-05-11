//
//  TurnByTurnViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 5/3/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "TurnByTurnViewController.h"
#import "DataManager.h"
#import "TurnByTurnTableViewCell.h"
#import "DSNavigationBar.h"
//#import "MYUtil.h"

@interface TurnByTurnViewController ()

@property (nonatomic,strong) NSArray *turns;
@property (strong, nonatomic) DataManager *dm;

@end

@implementation TurnByTurnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selfViewWidth = self.view.frame.size.width;
    selfViewHeight = self.view.frame.size.height;
    
    [self setBackground];
    [customTableView reloadData];
    
    NSString *turnByTurn = [self.routedb valueForKey:@"turnByTurnText"];
    self.turns = [turnByTurn componentsSeparatedByString:@";"];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];

    /*
    DSNavigationBar *navBar = [[DSNavigationBar alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, 60)];
    [self.view addSubview:navBar];
    
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //backButton.bounds = CGRectMake( 0, 0, backImage.size.width, backImage.size.height );
    [backButton setFrame:CGRectMake(0, 0, navBar.frame.size.height/3, navBar.frame.size.height/2.5)];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    item.leftBarButtonItem = backButtonItem;
    [navBar pushNavigationItem:item animated:NO];
     */
    [self setNavigationBar];
    
    CGSize imgSizeUp = CGSizeMake(45, 45);
    CGSize imgSizeHorizontal = CGSizeMake(45, 45);
    startImage = [self imageWithImage:[UIImage imageNamed:@"attraction 1.png"] scaledToSize:imgSizeUp];
    endImage = [self imageWithImage:[UIImage imageNamed:@"attraction 1.png"] scaledToSize:imgSizeUp];
    leftImage = [self imageWithImage:[UIImage imageNamed:@"arrow left 1.png"] scaledToSize:imgSizeHorizontal];
    rightImage = [self imageWithImage:[UIImage imageNamed:@"arrow right 1.png"] scaledToSize:imgSizeHorizontal];
    upImage = [self imageWithImage:[UIImage imageNamed:@"arrow up 1.png"] scaledToSize:imgSizeUp];
    attractionImage = [self imageWithImage:[UIImage imageNamed:@"attraction 1.png"] scaledToSize:imgSizeUp];
}

- (void)swipeDown:(UISwipeGestureRecognizer *)gestureRecognizer{
    [self dismissViewControllerAnimated:YES completion:nil];
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


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)backToMenu{
    //LandingTableViewController *vc = [[LandingTableViewController alloc] initWithNibName:@"LandingTableViewController" bundle:nil];
    //[self.navigationController pushViewController:vc animated:YES];
    [self performSegueWithIdentifier:@"unwindFromTurnByTurn" sender:self];
}


- (void)setBackground {

    customTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    customTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    customTableView.delegate = self;
    customTableView.dataSource = self;
    [customTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    customTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    customTableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    
    self.dm = [[DataManager alloc] init];
    UIImage *backgroundImage = [self.dm loadImage:[self.routedb valueForKey:@"title"]];
    
    CGRect croprect = CGRectMake(backgroundImage.size.width/6, 0 , backgroundImage.size.height/2, backgroundImage.size.height);
    //Draw new image in current graphics context
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([backgroundImage CGImage], croprect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    UIImageView * backgroundView  =[[UIImageView alloc]initWithImage:croppedImage];

    customTableView.backgroundView = backgroundView;
    customTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:customTableView];
    
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

/*- (void)setTableView:(UITableView *)tableView{
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}*/

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
    return self.turns.count - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *turn = [self.turns objectAtIndex:indexPath.row];
    if (cell == nil){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    //[cell setIndentationLevel:5];
    //[cell setIndentationWidth:6];
    
    if ([turn containsString:@"Start"] || [turn containsString:@"End"] || ![turn containsString:@"&"])
    {
        cell.textLabel.text = turn;
        cell.detailTextLabel.text = nil;
    }
    else{
        NSArray *arr = [[self.turns objectAtIndex:indexPath.row] componentsSeparatedByString:@"&"];
        cell.textLabel.text = [arr objectAtIndex:0];
        cell.detailTextLabel.text = [arr objectAtIndex:1];
    }
    //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //UIImage *img;
    //cell.imageView.frame = CGRectMake(0,0,32,32);
    //[cell.imageView setFrame:CGRectMake(0,0,32,32)];
    //cell.imageView.transform = CGAffineTransformMakeScale(0.35, 0.35);
    if ([turn containsString:@"Start"]){
        //cell.imageView.transform = CGAffineTransformMakeScale(0.16, 0.16);
        cell.imageView.image = startImage;//[UIImage imageNamed:@"attraction.png"];
    }else if([turn containsString:@"End"]){
        //cell.imageView.transform = CGAffineTransformMakeScale(0.16, 0.16);
        cell.imageView.image = endImage;//[UIImage imageNamed:@"attraction.png"];
    }else if([turn containsString:@"Arrive"]){
        //cell.imageView.transform = CGAffineTransformMakeScale(0.16, 0.16);
        cell.imageView.image = endImage;//[UIImage imageNamed:@"attraction.png"];
    }else if([turn containsString:@"left"]){
        //cell.imageView.transform = CGAffineTransformMakeScale(0.37, 0.35);
        cell.imageView.image = leftImage;//[UIImage imageNamed:@"arrow left.png"];
    }else if([turn containsString:@"right"]){
        //cell.imageView.transform = CGAffineTransformMakeScale(0.35, 0.35);
        cell.imageView.image = rightImage;//[UIImage imageNamed:@"arrow right.png"];
    }else /*if([turn containsString:@"End"])*/{
        //cell.imageView.transform = CGAffineTransformMakeScale(0.40, 0.35);
        //cell.imageView.transform = CGAffineTransformMakeScale(0.50, 0.50);
        cell.imageView.image = upImage;//[UIImage imageNamed:@"arrow-up.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) return;
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset1 = scrollView.contentOffset;
    CGRect bounds1 = scrollView.bounds;
    //CGSize size1 = scrollView.contentSize;
    UIEdgeInsets inset1 = scrollView.contentInset;
    float y1 = offset1.y + bounds1.size.height - inset1.bottom;
    NSLog(@"%f", y1);
    //float h1 = size1.height;
    NSLog(@"%f", customTableView.frame.size.height * 0.75);
    if (y1 < customTableView.frame.size.height * 0.75) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
