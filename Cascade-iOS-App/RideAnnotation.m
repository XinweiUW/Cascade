//
//  RideAnnotation.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/19/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "RideAnnotation.h"

@implementation RideAnnotation

- (id)initWithVariable:(NSInteger)index :(NSString *)title :(CLLocationCoordinate2D)coordinate;{
    
    self = [super init];
    if (self){
        self.index = index;
        self.title = title;
        self.coordinate = coordinate;
    }
    return self;
}


@end
