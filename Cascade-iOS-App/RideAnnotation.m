//
//  RideAnnotation.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/19/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "RideAnnotation.h"

@implementation RideAnnotation

- (id)initWithVariable:(NSString *)title :(CLLocationCoordinate2D)coordinate;{
    
    self = [super init];
    if (self){
        self.title = title;
        self.coordinate = coordinate;
    }
    return self;
}

@end
