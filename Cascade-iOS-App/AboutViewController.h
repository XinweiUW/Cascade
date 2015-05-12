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
    UILabel *titleLabel;
    UILabel *firstParaLabel;
    UILabel *secondParaLabel;
    UILabel *secondTitleLabel;
    
    UIButton *cascadeWebsite;
    UIButton *EventsButton;
    UIButton *exploreButton;
    UIButton *classButton;
    UIButton *volunteerButton;
    UIButton *transformButton;
    
}

@end
