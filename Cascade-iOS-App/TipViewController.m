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
    originX = 0.08 * selfViewWidth;
    originY = 0.2 * selfViewHeight;
    labelWidth = 0.84 * selfViewWidth;
    scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0.02 * selfViewWidth, originY, 0.96 * selfViewWidth, 0.78 * selfViewHeight)];
    scrollView.contentSize = CGSizeMake(0.96 * selfViewWidth, 0.78 * selfViewHeight);
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];

    [self setBackButton];
    [self setTitleLabel];
    [self setFirstParagraph];
    [self setSecondParagraph];
    // Do any additional setup after loading the view.
}

- (void) setFirstParagraph {
    firstParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY, labelWidth, 0.2 * selfViewWidth)];
    firstParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    firstParaLabel.numberOfLines = 0;
    //firstParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"We encourage all riders to Ride SMART.";
    [firstParaLabel setAttributedText:[self attributedText:labelText withRange:NSMakeRange(26, 11)]];
    [firstParaLabel sizeToFit];
    [scrollView addSubview:firstParaLabel];
}

- (void) setSecondParagraph {
    secondParaLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY + firstParaLabel.frame.size.height, labelWidth, 0.2 * selfViewWidth)];
    secondParaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    secondParaLabel.numberOfLines = 0;
    secondParaLabel.backgroundColor = [UIColor greenColor];
    NSString *labelText = @"Stay alert - watch for cars, other riders, and hazards. Don’t ride with earphones or earbuds. Pull off the road and stop when using a cell phone.";
    [secondParaLabel setAttributedText:[self attributedText:labelText withRange:NSMakeRange(0, 1)]];
    [secondParaLabel sizeToFit];
    [scrollView addSubview:secondParaLabel];
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

- (void) setTitleLabel {
    CGFloat labelX = 0.3 * selfViewWidth;
    CGFloat labelY = 0.1 * selfViewHeight;
    CGFloat labelWidth = 0.4 * selfViewWidth;
    CGFloat labelHeight = labelWidth/4;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
    NSString *title = @"Safety Tip";
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:67/255.0 green:176/255.0 blue:42/255.0 alpha:1];
    titleLabel.font = [UIFont boldSystemFontOfSize:24.0f * selfViewHeight/iPhone5Height];
    //titleLabel.backgroundColor = [UIColor grayColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
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
