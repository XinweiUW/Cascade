//
//  DescriptionsViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 3/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "DescriptionsViewController.h"
#import "DifficultiesViewController.h"
#import "DSNavigationBar.h"

@interface DescriptionsViewController ()

@end

@implementation DescriptionsViewController
@synthesize routedb;

- (void)viewDidLoad {
    selfViewWidth = self.view.frame.size.width;
    selfViewHeight = self.view.frame.size.height;
    [super viewDidLoad];
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //[[self navigationItem] setBackBarButtonItem:backButton];
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBar.backItem.title = @"Custom text";
    
    [self setBackground];
    
    UILabel *routeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, selfViewHeight * 0.3, selfViewWidth, selfViewWidth/5)];
    routeTitleLabel.backgroundColor = [UIColor clearColor];
    routeTitleLabel.textColor = [UIColor whiteColor];
    [routeTitleLabel setTextAlignment:NSTextAlignmentCenter];
    routeTitleLabel.font = [UIFont boldSystemFontOfSize:23.0f];
    routeTitleLabel.numberOfLines = 2;
    routeTitleLabel.lineBreakMode = 0;
    [self.view addSubview:routeTitleLabel];
    
    UIImageView *descriptImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, selfViewHeight * 0.5, selfViewWidth, selfViewHeight*0.5)];
    descriptImage.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:0];
    descriptImage.backgroundColor = [UIColor clearColor];
    [self.view addSubview:descriptImage];
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.alpha = 0.4;
    effectView.frame = descriptImage.bounds;
    [descriptImage addSubview:effectView];
    
    UILabel *keyWordsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.08 * descriptImage.frame.size.width, 0, 0.84 * descriptImage.frame.size.width, 0.2 * descriptImage.frame.size.height)];
    keyWordsLabel.backgroundColor = [UIColor clearColor];
    keyWordsLabel.textColor = [UIColor whiteColor];
    keyWordsLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    keyWordsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    keyWordsLabel.numberOfLines = 0;
    [descriptImage addSubview:keyWordsLabel];
    
    
    
    UILabel *routeDescriptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.08 * descriptImage.frame.size.width, 0.15 * descriptImage.frame.size.height, 0.84 * descriptImage.frame.size.width, 0.8 * descriptImage.frame.size.height)];
    routeDescriptLabel.backgroundColor = [UIColor clearColor];
    routeDescriptLabel.textColor = [UIColor whiteColor];
    routeDescriptLabel.font = [UIFont systemFontOfSize:16.0f];
    routeDescriptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    routeDescriptLabel.numberOfLines = 0;
    [descriptImage addSubview:routeDescriptLabel];
    
    if (self.routedb) {
        routeTitleLabel.text = [self.routedb valueForKey:@"title"];
        keyWordsLabel.text = [self.routedb valueForKey:@"keyWords"];
        routeDescriptLabel.text = [self.routedb valueForKey:@"descriptions"];
    }
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    //[self setNavigationBar];
    //self.navigationItem.hidesBackButton = YES;
    
    //[self setNavigationBar];
    [self setArrow];
    [self setBackButton];
   
    
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
    
}


- (void) setArrow {
    CGFloat arrowX = 0.45 * selfViewWidth;
    CGFloat arrowY = 0.94 * selfViewHeight;
    CGFloat arrowWidth = 0.1 * selfViewWidth;
    CGFloat arrowHeight = 0.03 * selfViewHeight;
    UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(arrowX, arrowY, arrowWidth, arrowHeight)];
    [arrowView setImage:[UIImage imageNamed:@"next page arrow.png"]];
    [self.view addSubview:arrowView];
}

- (void) setBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(didTapBackButton) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0.0f, 0.0f, 16.0f, 28.0f);
    backBtn.backgroundColor = [UIColor clearColor];
    //[backBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 16.0f, 28.0f)];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    //[backButtonItem setWidth:-5];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void) didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDifficultySegue"]) {
        //NSManagedObject *selectedDevice = [self.routeArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
        DifficultiesViewController *destViewController = segue.destinationViewController;
        destViewController.routedb = self.routedb;
    }
}


@end
