//
//  MapListViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 4/19/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "MapListViewController.h"
#import "DataManager.h"
#import "Ride.h"
#import "DescriptionsViewController.h"


@interface MapListViewController ()

@property (assign,nonatomic) CLLocationCoordinate2D coordinate;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) DataManager *dm;
@property (strong, nonatomic) NSMutableArray *rides;
@property (strong, nonatomic) NSMutableDictionary *rideIndices;

@end

@implementation MapListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.coordinate = CLLocationCoordinate2DMake(47.6204, -122.2);
    self.dm = [[DataManager alloc] init];
    self.rideIndices = [[NSMutableDictionary alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = TRUE;
    [self.mapView setCenterCoordinate:self.coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.coordinate, 70000, 60000);
    [self.mapView setRegion:region animated:YES];
    
    self.rides = [self.dm mutableArrayUsingFetchRequest];
    
    for (NSInteger index = 0; index < self.rides.count; index ++) {
        Ride *ride = [self.rides objectAtIndex:index];
        double latitude = [[ride valueForKey:@"latitude"] doubleValue];
        double longitude = [[ride valueForKey:@"longitude"] doubleValue];
        [self.rideIndices setValue:[ride valueForKey:@"id"] forKey:[ride valueForKey:@"title"]];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
        //CLLocationCoordinate2D *loc =
        RideAnnotation *annotation = [[RideAnnotation alloc] initWithVariable:index :[ride valueForKey:@"title"] :location];
        //MKAnnotationView *aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"rideAnnotation"];
        [self.mapView addAnnotation:annotation];
    }
    
    //self.navigationController.navigationBarHidden = TRUE;
    //[self.navigationController.navigationBar setTranslucent:TRUE];
    //[self.locationManager startUpdatingLocation];
    
    /*[self.mapView setShowsUserLocation:YES];
    
    self.coordinate = CLLocationCoordinate2DMake(47.6097, 122.3331);
    RideAnnotation *annotation = [[RideAnnotation alloc] initWithVariable:<#(NSString *)#> :<#(CLLocationCoordinate2D)#>]
    
    [self.mapView addAnnotation:annotation];*/
    [self setBackButton];
}

- (void) setBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setTitle:@"" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(didTapBackButton) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0.0f, 0.0f, 16.0f, 28.0f);
    backBtn.backgroundColor = [UIColor clearColor];
    //[backBtn setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 16.0f, 28.0f)];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    //[backButtonItem setWidth:-5];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void) didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
{
    NSLog(@"%@",locations);
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(47.6097, -122.3331);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"It works");
    NSString *title = [view.annotation title];
    NSNumber *index = [self.rideIndices valueForKey:title];
    NSManagedObject *ride = [self.rides objectAtIndex:[index integerValue] - 1];
    [self performSegueWithIdentifier:@"showDetailFromMap" sender:ride];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetailFromMap"]) {
        DescriptionsViewController *vc = segue.destinationViewController;
        NSManagedObject *ride = sender;
        vc.routedb = ride;
        
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[RideAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView* pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"rideAnnotation"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"rideAnnotation"];
            //pinView.pinColor = MKPinAnnotationColorRed;
            //pinView. = YES;
            pinView.canShowCallout = YES;
            NSString *title = [pinView.annotation title];
            NSInteger index = [[self.rideIndices valueForKey:title] integerValue] - 1;
            NSManagedObject *ride = [self.rides objectAtIndex:index];
            NSInteger complete = [[ride valueForKey:@"complete"] integerValue];
            if (complete == 0) {
                pinView.image = [UIImage imageNamed:@"pin_grey.png"];
            }else{
                pinView.image = [UIImage imageNamed:@"pin.png"];
            }
            //pinView.image = [UIImage imageNamed:@"menu-button.png"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
            //[button setImage:[UIImage new] forState:UIControlStateNormal];
            [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
            pinView.rightCalloutAccessoryView = button;
            
            // If appropriate, customize the callout by adding accessory views (code not shown).
        }
        else
            pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}

@end
