//
//  TurnByTurnViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 5/3/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TurnByTurnViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    CGFloat selfViewWidth;
    CGFloat selfViewHeight;
    UITableView *customTableView;
    
    UIImage *startImage;
    UIImage *leftImage;
    UIImage *rightImage;
    UIImage *upImage;
    UIImage *endImage;
    UIImage *attractionImage;
}

@property (strong) NSManagedObject *routedb;
//@property (strong, nonatomic) UITableView *tableView;

@end
