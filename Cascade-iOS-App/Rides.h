//
//  Rides.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/12/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Rides : NSManagedObject

@property() NSInteger id;
@property() NSString *title;
@property() NSString *distance;
@property() NSString *duration;
@property() NSString *terrain;
@property() NSString *keyWords;
@property() NSString *shortOverview;
@property() NSString *start;
@property() NSString *finish;
@property() NSString *mapURL;
@property() NSString *roadCondition;
@property() NSString *imgURL;
@property() NSString *attractions;
@property() NSString *descriptions;
@property() NSString *turnByTurn;
@property() NSString *difficulties;

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
