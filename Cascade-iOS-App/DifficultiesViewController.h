//
//  DifficultiesViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/24/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "DescriptionsViewController.h"

@interface DifficultiesViewController : UIViewController {
    CGFloat selfViewWidth;
    CGFloat selfViewHeight;
}

@property (strong, nonatomic) DataManager *dm;
@property (strong) NSManagedObject *routedb;

@end
