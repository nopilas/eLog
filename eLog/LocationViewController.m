//
//  BoatInfo.m
//  eLog
//
//  Created by nopilas on 2014-08-26.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import "LocationViewController.h"
#import "KeychainItemWrapper.h"
#import "Boat.h"
#import "DBManager.h"

@interface LocationViewController ()

@end

@implementation LocationViewController
CLLocationManager *locationManager;
NSString* userId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)saisieReturn:(id)sender
{
    [sender resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    locationManager = [[CLLocationManager alloc] init];
  
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    

    _mapView.showsUserLocation = YES;
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    MKCoordinateRegion region = {{0.0, 0.0},{0.0,0.0}};
    region.center.latitude = locationManager.location.coordinate.latitude;
    region.center.longitude = locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.latitudeDelta = 0.005f;
    [_mapView setRegion:region animated:YES];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    CLLocation *newLocation = [locations lastObject];
    CLLocation *oldLocation;
    if (locations.count > 1)
    {
        oldLocation = [locations objectAtIndex:locations.count-2];
    }
    else
    {
        oldLocation = nil;
    }
    
    if (newLocation != nil)
    {
        _longitudeLabel.text = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.longitude];
        _latitudeLabel.text = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.latitude];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 800, 800);
        [_mapView setRegion:[_mapView regionThatFits:region] animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

@end
