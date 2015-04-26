//
//  RideAnnotation.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/19/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RideAnnotation : NSObject <MKAnnotation>

@property (nonatomic) NSInteger index;
@property (copy, nonatomic) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithVariable:(NSInteger )index :(NSString *)title :(CLLocationCoordinate2D)coordinate;

@end
