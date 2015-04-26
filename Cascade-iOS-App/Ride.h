//
//  Rides.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/12/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Ride : NSManagedObject

@property (nonatomic) NSInteger id;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *distance;
@property(strong, nonatomic) NSString *duration;
@property(strong, nonatomic) NSString *terrain;
@property(strong, nonatomic) NSString *keyWords;
@property(strong, nonatomic) NSString *shortOverview;
@property(strong, nonatomic) NSString *start;
@property(strong, nonatomic) NSString *finish;
@property(strong, nonatomic) NSString *mapURL;
@property(strong, nonatomic) NSString *roadCondition;
@property(strong, nonatomic) NSString *imgURL;
//@property(strong, nonatomic) NSData *imgData;
@property(strong, nonatomic) NSString *attractions;
@property(strong, nonatomic) NSString *descriptions;
@property(strong, nonatomic) NSString *turnByTurn;
@property(strong, nonatomic) NSString *difficulties;
@property(nonatomic) NSInteger complete;
@property(nonatomic) NSString *latitude;
@property(nonatomic) NSString *longitude;


//@property(strong, nonatomic) NSData *imgURL;

//@property (nonatomic) UIImage *imgURL;

/*
 [newDevice setValue:number forKey:@"id"];
 [newDevice setValue:title forKey:@"title"];
 [newDevice setValue:distance forKey:@"distance"];
 [newDevice setValue:duration forKey:@"duration"];
 [newDevice setValue:terrain forKey:@"terrain"];
 [newDevice setValue:keyWords forKey:@"keyWords"];
 [newDevice setValue:shortOverview forKey:@"shortOverview"];
 [newDevice setValue:start forKey:@"start"];
 [newDevice setValue:finish forKey:@"finish"];
 [newDevice setValue:mapURL forKey:@"mapURL"];
 [newDevice setValue:roadCondition forKey:@"roadCondition"];
 [newDevice setValue:imgURL forKey:@"imgURL"];
 [newDevice setValue:attractions forKey:@"attractions"];
 [newDevice setValue:descriptions forKey:@"descriptions"];
 [newDevice setValue:turnByTurn forKey:@"turnByTurn"];
 [newDevice setValue:difficulties forKey:@"difficulties"];
 
 
 */


@end
