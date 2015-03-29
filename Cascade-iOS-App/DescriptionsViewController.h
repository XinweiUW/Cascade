//
//  DescriptionsViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 3/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DescriptionsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *routeTitle;
@property (weak, nonatomic) IBOutlet UILabel *routeDescription;

@property (strong) NSManagedObject *routedb;

@end
