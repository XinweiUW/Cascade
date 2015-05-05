//
//  MapListViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/19/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "ViewController.h"
#import "RideAnnotation.h"

@import MapKit;
@import CoreLocation;

@interface MapListViewController : ViewController<CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation> {
    CGFloat selfViewWidth;
    CGFloat selfViewHeight;
}


@property (strong, nonatomic) CLLocationManager *locationManager;

@end
