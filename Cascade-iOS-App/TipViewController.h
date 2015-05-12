//
//  TipViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/6/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipViewController : UIViewController {
    CGFloat selfViewWidth;
    CGFloat selfViewHeight;
    CGFloat originX;
    CGFloat originY;
    CGFloat labelWidth;

    UIScrollView *scrollView;
    UILabel *titleLabel;
    UILabel *firstParaLabel;
    UILabel *secondParaLabel;
    UILabel *thirdParaLabel;
    UILabel *fourthParaLabel;
    UILabel *fifthParaLabel;
    UILabel *sixthParaLabel;
    
}

@end
