//
//  TurnByTurnTableViewCell.h
//  Cascade-iOS-App
//
//  Created by iGuest on 5/2/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface TurnByTurnTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *direction;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UIImageView *arrowView;



@end
