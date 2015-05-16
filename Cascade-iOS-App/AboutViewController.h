//
//  AboutViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/6/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController {
    CGFloat selfViewWidth;
    CGFloat selfViewHeight;
    CGFloat originX;
    CGFloat originY;
    CGFloat labelWidth;
    CGFloat labelDistance;
    
    UIScrollView *scrollView;
    UILabel *clubTitleLabel;
    UILabel *clubFirstParaLabel;
    UILabel *clubSecondParaLabel;
    UILabel *secondTitleLabel;
    
    UIButton *clubWebsiteButton;
    UIButton *EventsButton;
    UIButton *exploreButton;
    UIButton *classButton;
    UIButton *volunteerButton;
    UIButton *transformButton;
    
}

@end
