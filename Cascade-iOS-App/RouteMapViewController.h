//
//  RouteMapViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "DescriptionsViewController.h"

@interface RouteMapViewController : UINavigationController {
    CGFloat selfViewWidth;
    CGFloat selfViewHeight;
}

@property (strong, nonatomic) DataManager *dm;
@property (strong) NSManagedObject *routedb;


@end
