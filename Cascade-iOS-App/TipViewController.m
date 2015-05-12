//
//  TipViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/6/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "TipViewController.h"
#define iPhone5Height 568

@interface TipViewController ()

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

    [self setBackButton];
    [self setTitleLabel];
    [self setFirstParagraph];
    [self setSecondParagraph];
    [self setThirdParagraph];
    [self setFourthParagraph];
    [self setFifthParagraph];
    [self setSixthParagraph];
    // Do any additional setup after loading the view.
}

- (void) setTitleLabel {
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.02 * selfViewHeight, 0.96 * selfViewWidth, selfViewWidth * 0.1)];
    NSString *title = @"Safety Tips";
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
    //firstParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //firstParaLabel.numberOfLines = 0;
    //firstParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"We encourage all riders to Ride SMART.";
    [firstParaLabel setAttributedText:[self attributedText:labelText withRange:NSMakeRange(26, 11)]];
    [firstParaLabel sizeToFit];
    [scrollView addSubview:firstParaLabel];
}


- (void) setSecondParagraph {
    CGFloat labelY = firstParaLabel.frame.origin.y + firstParaLabel.frame.size.height + labelDistance;
    secondParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    secondParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    secondParaLabel.numberOfLines = 0;
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Stay alert - watch for cars, other riders, and hazards. Don’t ride with earphones or earbuds. Pull off the road and stop when using a cell phone.";
    [secondParaLabel setAttributedText:[self attributedText:labelText withRange:NSMakeRange(0, 1)]];
    [secondParaLabel sizeToFit];
    [scrollView addSubview:secondParaLabel];
}

- (void) setThirdParagraph {
    CGFloat labelY = secondParaLabel.frame.origin.y + secondParaLabel.frame.size.height + labelDistance;
    thirdParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    thirdParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    thirdParaLabel.numberOfLines = 0;
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Move off the road if stopping. Pull completely off the road or trail to let cars and others pass. Don’t block driveways or intersections.";
    [thirdParaLabel setAttributedText:[self attributedText:labelText withRange:NSMakeRange(0, 1)]];
    [thirdParaLabel sizeToFit];
    [scrollView addSubview:thirdParaLabel];
}

- (void) setFourthParagraph {
    CGFloat labelY = thirdParaLabel.frame.origin.y + thirdParaLabel.frame.size.height + labelDistance;
    fourthParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    fourthParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    fourthParaLabel.numberOfLines = 0;
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Act responsibly and obey all traffic laws. Stop at stop signs and use hand signals. Yield to pedestrians and bicycle in a straight line.";
    [fourthParaLabel setAttributedText:[self attributedText:labelText withRange:NSMakeRange(0, 1)]];
    [fourthParaLabel sizeToFit];
    [scrollView addSubview:fourthParaLabel];
}

- (void) setFifthParagraph {
    CGFloat labelY = fourthParaLabel.frame.origin.y + fourthParaLabel.frame.size.height + labelDistance;
    fifthParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    fifthParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    fifthParaLabel.numberOfLines = 0;
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Retain space between yourself and others. Leave enough room to dodge obstacles.";
    [fifthParaLabel setAttributedText:[self attributedText:labelText withRange:NSMakeRange(0, 1)]];
    [fifthParaLabel sizeToFit];
    [scrollView addSubview:fifthParaLabel];
}

- (void) setSixthParagraph {
    CGFloat labelY = fifthParaLabel.frame.origin.y + fifthParaLabel.frame.size.height + labelDistance;
    sixthParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, labelY, labelWidth, 0.2 * selfViewWidth)];
    sixthParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    sixthParaLabel.numberOfLines = 0;
    //secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Tell others when passing, and pass on the left.";
    [sixthParaLabel setAttributedText:[self attributedText:labelText withRange:NSMakeRange(0, 1)]];
    [sixthParaLabel sizeToFit];
    [scrollView addSubview:sixthParaLabel];
}



- (NSMutableAttributedString *)attributedText: (NSString *)originalText withRange: (NSRange) range {
    //NSString *labelText = @"We encourage all riders to Ride SMART.";
    const CGFloat fontSize = 16.0f * selfViewHeight/iPhone5Height;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:fontSize];
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    UIColor *regularColor = [UIColor blackColor];
    UIColor *boldColor = [UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1];
    
    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldFont, NSFontAttributeName,
                           boldColor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName,
                              regularColor, NSForegroundColorAttributeName, nil];
    //const NSRange range = NSMakeRange(26, 11); // range of " 2012/10/14 ". Ideally this should not be hardcoded
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:originalText
                                           attributes:subAttrs];
    [attributedText setAttributes:attrs range:range];
    return attributedText;
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
