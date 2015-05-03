//
//  DescriptionsViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 3/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"

@interface DescriptionsViewController : UIViewController {
    CGFloat selfViewWidth;
    CGFloat selfViewHeight;
}

@property (strong, nonatomic) DataManager *dm;
//@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

//@property (weak, nonatomic) IBOutlet UILabel *routeTitleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *routeDescriptionLabel;


@property (strong) NSManagedObject *routedb;

@end
