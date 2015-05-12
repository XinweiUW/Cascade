//
//  AboutViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/6/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "AboutViewController.h"
#define iPhone5Height 568

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButton];
    // Do any additional setup after loading the view.
    
    selfViewWidth = self.view.frame.size.width;
    selfViewHeight = self.view.frame.size.height;
    
    originX = 0;
    originY = 0.14 * selfViewHeight;
    labelWidth = 0.92 * selfViewWidth;
    labelDistance = 0.03 * selfViewHeight;
    
    scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.045 * selfViewWidth, 45, 0.95 * selfViewWidth, 0.9 * selfViewHeight)];
    scrollView.contentSize = CGSizeMake(0.95 * selfViewWidth, selfViewHeight);
    //[scrollView setContentOffset:CGPointZero];
    //scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
    [self setTitleLabel];
    [self setFirstParagraph];
}

- (void) setTitleLabel {
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.02 * selfViewHeight, 0.96 * selfViewWidth, selfViewWidth * 0.1)];
    NSString *title = @"About Cascade:";
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1];
    titleLabel.font = [UIFont boldSystemFontOfSize:30.0f * selfViewHeight/iPhone5Height];
    //titleLabel.backgroundColor = [UIColor grayColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel sizeToFit];
    [scrollView addSubview:titleLabel];
}

- (void) setFirstParagraph {
    firstParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY, labelWidth, 0.2 * selfViewWidth)];
    firstParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    firstParaLabel.numberOfLines = 0;
    //firstParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Cascade Bicycle Club, the nation’s largest locally based bicycle organization, is 15,000-members and 36-staff strong, and serves bike riders of all ages and abilities throughout the Puget Sound region.";
    firstParaLabel.font = [UIFont systemFontOfSize:16.0f * selfViewHeight/iPhone5Height];
    firstParaLabel.textColor = [UIColor blackColor];
    [firstParaLabel setText:labelText];
    [firstParaLabel sizeToFit];
    [scrollView addSubview:firstParaLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back 3.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(didTapBackButton) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0.0f, 10.0f, 24.0f, 28.0f);
    backBtn.backgroundColor = [UIColor clearColor];
    //[backBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 16.0f, 28.0f)];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    //[backButtonItem setWidth:-5];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void) didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
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
