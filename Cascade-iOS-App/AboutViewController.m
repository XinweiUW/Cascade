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
    [self setSecondParagraph];
    [self setEventsButton];
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

- (void) setSecondParagraph {
    CGFloat labelY = firstParaLabel.frame.origin.y + firstParaLabel.frame.size.height + labelDistance;
    secondParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    secondParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    secondParaLabel.numberOfLines = 0;
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Learn more at: ";
    [secondParaLabel setText:labelText];
    [secondParaLabel sizeToFit];
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:secondParaLabel];
    
    CGFloat buttonX = secondParaLabel.frame.origin.x + secondParaLabel.frame.size.width;
    CGFloat buttonY = secondParaLabel.frame.origin.y;
    CGFloat buttonWidth = secondParaLabel.frame.size.width * 1.5;
    CGFloat buttonHeight = secondParaLabel.frame.size.height;
    UIButton *cascadeWebsite = [UIButton buttonWithType:UIButtonTypeCustom];
    [cascadeWebsite setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [cascadeWebsite setAttributedTitle:[self attributedText:@"www.cascade.org"] forState:UIControlStateNormal];
    //cascadeWebsite.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cascadeWebsite.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cascadeWebsite addTarget:self action:@selector(goToCascadeOfficialWebsite) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cascadeWebsite];

}

- (void) setEventsButton {
    CGFloat buttonX = secondParaLabel.frame.origin.x;
    CGFloat buttonY = secondParaLabel.frame.origin.y + secondParaLabel.frame.size.height + labelDistance;
    CGFloat buttonWidth = secondParaLabel.frame.size.width * 2.5;
    CGFloat buttonHeight = secondParaLabel.frame.size.height;
    UIButton *cascadeWebsite = [UIButton buttonWithType:UIButtonTypeCustom];
    [cascadeWebsite setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [cascadeWebsite setAttributedTitle:[self attributedText:@"Join an event >>"] forState:UIControlStateNormal];
    //cascadeWebsite.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    cascadeWebsite.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cascadeWebsite addTarget:self action:@selector(goToCascadeEventsWebsite) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cascadeWebsite];

}

- (NSMutableAttributedString *) attributedText: (NSString *)originalText {
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:originalText];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    UIColor* textColor = [UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1];
    [commentString setAttributes:@{NSForegroundColorAttributeName:textColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[commentString length])];
    return commentString;
}

- (void) goToCascadeOfficialWebsite {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.cascade.org" ];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) goToCascadeEventsWebsite {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://cascade.org/ride/major-rides" ];
    [[UIApplication sharedApplication] openURL:url];
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

- (BOOL) automaticallyAdjustsScrollViewInsets{
    return NO;
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
