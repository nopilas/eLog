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
#import "GlobalView.h"

@interface LocationViewController ()

@end

@implementation LocationViewController
CLLocationManager *locationManager;
NSString* userId;

BOOL update = YES;

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
    _mapView.delegate = self;
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:100
                                                        target:self
                                                      selector:@selector(updateNextPosition)
                                                      userInfo:nil
                                                       repeats:YES];
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background handler called. Not running background tasks anymore.");
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
        self.backgroundTask = UIBackgroundTaskInvalid;
    }];
    
    
    locationUIView = self;
    
    NSDictionary *dic = [[DBManager getSharedInstance ] SelectDataUser:idUserGlobal];
 
    _licenceHolderName.text = [dic valueForKey:@"licenceHolder"];
    _lobsterLicenceNo.text = [dic valueForKey:@"lobsterLicence"];
    _vesselName.text = [dic valueForKey:@"vesselName"];
    _vesselNumber.text = [dic valueForKey:@"vesselNumber"];
    _zone.text = [dic valueForKey:@"zone"];
    
    // Do any additional setup after loading the view.
}



-(void)stopTimer
{
    [self.updateTimer invalidate ];
    update = NO;
    [longitudeGlobal removeAllObjects];
    [latitudeGlobal removeAllObjects];
}

-(void)updateNextPosition{
    @autoreleasepool
    {
        update = YES;
        
        // this will be executed no matter app is in foreground or background
    }
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

- (void)drawRangeRings: (CLLocationCoordinate2D) where {
    // first, I clear out any previous overlays:
    [_mapView removeOverlays: [_mapView overlays]];

    MKCircle* outerCircle = [MKCircle circleWithCenterCoordinate: where radius: 100];
    outerCircle.title = @"Stretch Range";
    MKCircle* innerCircle = [MKCircle circleWithCenterCoordinate: where radius: (100 / 1.425f)];
    innerCircle.title = @"Safe Range";
    
    [_mapView addOverlay: outerCircle];
    [_mapView addOverlay: innerCircle];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKCircle* circle = overlay;
    MKCircleView* circleView = [[MKCircleView alloc] initWithCircle: circle];
    if ([circle.title compare: @"Safe Range"] == NSOrderedSame) {
        circleView.fillColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25];
        circleView.strokeColor = [UIColor whiteColor];
    } else {
        circleView.fillColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.25];
        circleView.strokeColor = [UIColor grayColor];
        
    }
    circleView.lineWidth = 2.0;
    
    return circleView;
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
    
    if (update == YES)
    {
        NSNumber *num = [NSNumber numberWithFloat:newLocation.coordinate.longitude];
        [longitudeGlobal addObject:num];
        
        num = [NSNumber numberWithFloat:newLocation.coordinate.latitude];
        [latitudeGlobal addObject:num];
        
        update = NO;
        
        [self drawRangeRings:CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)];
         
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Failed to Get Your Location", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

@end
