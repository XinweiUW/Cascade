//
//  MyCustomTableViewCell.h
//  Cascade-iOS-App
//
//  Created by iGuest on 5/1/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SWTableViewCell.h"

@interface CustomLandingTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *completeView;
@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;
@end
