//
//  LandingTableViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 3/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "SlideNavigationController.h"
@class DataManager;


@interface LandingTableViewController : UITableViewController<SlideNavigationControllerDelegate, SWTableViewCellDelegate>

@property (strong) NSMutableArray *routeArray;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *detailButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *drawerButton;

@end
