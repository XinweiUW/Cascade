//
//  TurnByTurnTableViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 5/2/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TurnByTurnTableViewController : UITableViewController/*{
    CGFloat selfViewWidth;
    CGFloat selfViewHeight;
}*/


@property (strong) NSManagedObject *routedb;

@end
