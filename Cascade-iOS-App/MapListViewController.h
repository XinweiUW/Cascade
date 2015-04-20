//
//  MapListViewController.h
//  Cascade-iOS-App
//
//  Created by iGuest on 4/19/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;
@import MapKit;

@interface MapListViewController : ViewController<CLLocationManagerDelegate, MKMapViewDelegate, MKAnnotation>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
