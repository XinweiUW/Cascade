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
    scrollView.contentSize = CGSizeMake(0.95 * selfViewWidth, selfViewHeight * 1.5);
    //[scrollView setContentOffset:CGPointZero];
    //scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
    [self setAppTitle];
    [self setAppFirstParagraph];
    [self setAppSecondParagraph];
    [self setAppCreditWebsite];
    
    [self setClubTitle];
    [self setClubParagraph];
    [self setClubWebsite];
    [self setEventsButton];
    [self setExploreButton];
    [self setClassButton];
    [self setVolunteerButton];
    [self setTransformButton];
    [self setSecondTitleLabel];
    [self setContactContent];
}

- (void) setAppTitle {
    appTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0.02 * selfViewHeight, 0.96 * selfViewWidth, selfViewWidth * 0.1)];
    NSString *title = @"About the Let’s Ride! App:";
    appTitleLabel.text = title;
    appTitleLabel.textColor = [UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1];
    appTitleLabel.font = [UIFont boldSystemFontOfSize:30.0f * selfViewHeight/iPhone5Height];
    //titleLabel.backgroundColor = [UIColor grayColor];
    [appTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [appTitleLabel sizeToFit];
    [scrollView addSubview:appTitleLabel];
}

- (void) setAppFirstParagraph {
    appFirstParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, appTitleLabel.frame.origin.y + appTitleLabel.frame.size.height + labelDistance, labelWidth, 0.2 * selfViewWidth)];
    appFirstParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    appFirstParaLabel.numberOfLines = 0;
    //firstParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Hop on a bike discover Seattle on two wheels with these 10 amazing bike rides curated by the pro’s and guaranteed to be amazing experiences for you to ride solo or with your adventurous friends!  Whether you’re new to Seattle or just looking to experience new corners of its of its beautiful surroundings, this app is sure to please. Challenge yourself to complete all 10 beautiful rides! #UnlockYourCity";
    appFirstParaLabel.font = [UIFont systemFontOfSize:16.0f * selfViewHeight/iPhone5Height];
    appFirstParaLabel.textColor = [UIColor blackColor];
    [appFirstParaLabel setText:labelText];
    [appFirstParaLabel sizeToFit];
    [scrollView addSubview:appFirstParaLabel];
}

-(void) setAppSecondParagraph {
    CGFloat labelY = appFirstParaLabel.frame.origin.y + appFirstParaLabel.frame.size.height + labelDistance;
    appSecondParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    appSecondParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    appSecondParaLabel.numberOfLines = 0;
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"This app was created by a dedicated team of students from University of Washington’s iSchool and Cascade Bicycle Club. ";
    [appSecondParaLabel setText:labelText];
    [appSecondParaLabel sizeToFit];
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:appSecondParaLabel];
}

-(void) setAppCreditWebsite {
    CGFloat labelY = appSecondParaLabel.frame.origin.y + appSecondParaLabel.frame.size.height + labelDistance;
    appCreditParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    appCreditParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    appCreditParaLabel.numberOfLines = 0;
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Learn more at: ";
    [appCreditParaLabel setText:labelText];
    [appCreditParaLabel sizeToFit];
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:appCreditParaLabel];
    
    CGFloat buttonX = appCreditParaLabel.frame.origin.x + appCreditParaLabel.frame.size.width;
    CGFloat buttonY = appCreditParaLabel.frame.origin.y;
    CGFloat buttonWidth = appCreditParaLabel.frame.size.width * 1.5;
    CGFloat buttonHeight = appCreditParaLabel.frame.size.height;
    appCreditButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [appCreditButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [appCreditButton setAttributedTitle:[self attributedText:@"here"] forState:UIControlStateNormal];
    //cascadeWebsite.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    appCreditButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [appCreditButton addTarget:self action:@selector(goToCascadeOfficialWebsite) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:appCreditButton];
}

- (void) setClubTitle {
    CGFloat labelY = appCreditParaLabel.frame.origin.y + appCreditParaLabel.frame.size.height + labelDistance * 2;
    clubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, labelY, 0.96 * selfViewWidth, selfViewWidth * 0.1)];
    NSString *title = @"About Cascade Bicycle Club:";
    clubTitleLabel.text = title;
    clubTitleLabel.textColor = [UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1];
    clubTitleLabel.font = [UIFont boldSystemFontOfSize:30.0f * selfViewHeight/iPhone5Height];
    //titleLabel.backgroundColor = [UIColor grayColor];
    [clubTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [clubTitleLabel sizeToFit];
    [scrollView addSubview:clubTitleLabel];
}

- (void) setClubParagraph {
    CGFloat labelY = clubTitleLabel.frame.origin.y + clubTitleLabel.frame.size.height + labelDistance * 1.5;
    clubFirstParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    clubFirstParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    clubFirstParaLabel.numberOfLines = 0;
    //firstParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Cascade Bicycle Club, the nation’s largest locally based bicycle organization, is 15,000-members and 36-staff strong, and serves bike riders of all ages and abilities throughout the Puget Sound region.";
    clubFirstParaLabel.font = [UIFont systemFontOfSize:16.0f * selfViewHeight/iPhone5Height];
    clubFirstParaLabel.textColor = [UIColor blackColor];
    [clubFirstParaLabel setText:labelText];
    [clubFirstParaLabel sizeToFit];
    [scrollView addSubview:clubFirstParaLabel];
}

- (void) setClubWebsite {
    CGFloat labelY = clubFirstParaLabel.frame.origin.y + clubFirstParaLabel.frame.size.height + labelDistance;
    clubSecondParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    clubSecondParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    clubSecondParaLabel.numberOfLines = 0;
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Learn more at: ";
    [clubSecondParaLabel setText:labelText];
    [clubSecondParaLabel sizeToFit];
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    [scrollView addSubview:clubSecondParaLabel];
    
    CGFloat buttonX = clubSecondParaLabel.frame.origin.x + clubSecondParaLabel.frame.size.width;
    CGFloat buttonY = clubSecondParaLabel.frame.origin.y;
    CGFloat buttonWidth = clubSecondParaLabel.frame.size.width * 1.5;
    CGFloat buttonHeight = clubSecondParaLabel.frame.size.height;
    clubWebsiteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clubWebsiteButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [clubWebsiteButton setAttributedTitle:[self attributedText:@"www.cascade.org"] forState:UIControlStateNormal];
    //cascadeWebsite.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    clubWebsiteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [clubWebsiteButton addTarget:self action:@selector(goToCascadeOfficialWebsite) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:clubWebsiteButton];

}

- (void) setEventsButton {
    CGFloat buttonX = clubSecondParaLabel.frame.origin.x;
    CGFloat buttonY = clubSecondParaLabel.frame.origin.y + clubSecondParaLabel.frame.size.height + labelDistance;
    CGFloat buttonWidth = clubSecondParaLabel.frame.size.width * 2.5;
    CGFloat buttonHeight = clubSecondParaLabel.frame.size.height;
    EventsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [EventsButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [EventsButton setAttributedTitle:[self attributedText:@"Join an event >>"] forState:UIControlStateNormal];
    //cascadeWebsite.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    EventsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [EventsButton addTarget:self action:@selector(goToCascadeEventsWebsite) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:EventsButton];

}

- (void) setExploreButton {
    CGFloat buttonX = EventsButton.frame.origin.x;
    CGFloat buttonY = EventsButton.frame.origin.y + EventsButton.frame.size.height + labelDistance;
    CGFloat buttonWidth = EventsButton.frame.size.width;
    CGFloat buttonHeight = EventsButton.frame.size.height;
    exploreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exploreButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [exploreButton setAttributedTitle:[self attributedText:@"Explore routes with friends >>"] forState:UIControlStateNormal];
    //cascadeWebsite.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    exploreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [exploreButton addTarget:self action:@selector(goToCascadeExploreWebsite) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:exploreButton];
}

- (void) setClassButton {
    CGFloat buttonX = exploreButton.frame.origin.x;
    CGFloat buttonY = exploreButton.frame.origin.y + exploreButton.frame.size.height + labelDistance;
    CGFloat buttonWidth = exploreButton.frame.size.width;
    CGFloat buttonHeight = exploreButton.frame.size.height;
    classButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [classButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [classButton setAttributedTitle:[self attributedText:@"Take a class >>"] forState:UIControlStateNormal];
    //cascadeWebsite.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    classButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [classButton addTarget:self action:@selector(goToCascadeClassWebsite) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:classButton];
}

- (void) setVolunteerButton {
    CGFloat buttonX = classButton.frame.origin.x;
    CGFloat buttonY = classButton.frame.origin.y + classButton.frame.size.height + labelDistance;
    CGFloat buttonWidth = classButton.frame.size.width;
    CGFloat buttonHeight = classButton.frame.size.height;
    volunteerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [volunteerButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [volunteerButton setAttributedTitle:[self attributedText:@"Volunteer >>"] forState:UIControlStateNormal];
    //cascadeWebsite.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    volunteerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [volunteerButton addTarget:self action:@selector(goToCascadeVolunteerWebsite) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:volunteerButton];
}

- (void) setTransformButton {
    CGFloat buttonX = volunteerButton.frame.origin.x;
    CGFloat buttonY = volunteerButton.frame.origin.y + volunteerButton.frame.size.height + labelDistance;
    CGFloat buttonWidth = volunteerButton.frame.size.width;
    CGFloat buttonHeight = volunteerButton.frame.size.height;
    transformButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [transformButton setFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [transformButton setAttributedTitle:[self attributedText:@"Transform the region >>"] forState:UIControlStateNormal];
    //cascadeWebsite.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    transformButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [transformButton addTarget:self action:@selector(goToCascadeTransformWebsite) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:transformButton];
}

- (void) setSecondTitleLabel {
    //CGFloat buttonX = transformButton.frame.origin.x;
    CGFloat buttonY = transformButton.frame.origin.y + transformButton.frame.size.height + labelDistance * 2;
    //CGFloat buttonWidth = transformButton.frame.size.width;
    //CGFloat buttonHeight = transformButton.frame.size.height;
    secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonY, 0.96 * selfViewWidth, selfViewWidth * 0.1)];
    NSString *title = @"Contact Cascade";
    secondTitleLabel.text = title;
    secondTitleLabel.textColor = [UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1];
    secondTitleLabel.font = [UIFont boldSystemFontOfSize:30.0f * selfViewHeight/iPhone5Height];
    //titleLabel.backgroundColor = [UIColor grayColor];
    [secondTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [secondTitleLabel sizeToFit];
    [scrollView addSubview:secondTitleLabel];
}

- (void) setContactContent {
    CGFloat buttonY = secondTitleLabel.frame.origin.y + secondTitleLabel.frame.size.height + labelDistance * 1.5;
    UITextView *emailInfo = [[UITextView alloc] initWithFrame:CGRectMake(originX, buttonY, labelWidth, clubSecondParaLabel.frame.size.height*2)];
    //emailInfo.text = @"info@cascade.org";
    [emailInfo setAttributedText:[self attributedText:@"info@cascade.org"]];
    emailInfo.editable = NO;
    emailInfo.dataDetectorTypes = UIDataDetectorTypeAll;
    [emailInfo setTintColor:[UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1]];
    emailInfo.font = [UIFont systemFontOfSize:18.0f * selfViewHeight/iPhone5Height];
    [scrollView addSubview:emailInfo];
    
    buttonY = emailInfo.frame.origin.y + emailInfo.frame.size.height + labelDistance * 0.2;
    UITextView *phoneNumInfo = [[UITextView alloc] initWithFrame:CGRectMake(originX, buttonY, labelWidth, 0.2 * selfViewWidth)];
    //phoneNumInfo.text = @"206-522-3222";
    [phoneNumInfo setAttributedText:[self attributedText:@"206-522-3222"]];
    phoneNumInfo.editable = NO;
    phoneNumInfo.dataDetectorTypes = UIDataDetectorTypeAll;
    [phoneNumInfo setTintColor:[UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1]];
    phoneNumInfo.font = [UIFont systemFontOfSize:18.0f * selfViewHeight/iPhone5Height];
    [scrollView addSubview:phoneNumInfo];
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

- (void) goToCascadeExploreWebsite {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://cascade.org/grouprides" ];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) goToCascadeClassWebsite {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://cascade.org/learn" ];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) goToCascadeVolunteerWebsite {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://cascade.org/volunteer" ];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) goToCascadeTransformWebsite {
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.cascade.org/get-involved" ];
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
