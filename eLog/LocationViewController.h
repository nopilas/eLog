//
//  BoatInfo.h
//  eLog
//
//  Created by nopilas on 2014-08-26.
//  Copyright (c) 2014 nopilas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Mapkit/MKAnnotation.h>

@interface LocationViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property (weak, nonatomic) IBOutlet UILabel *licenceHolderName;
@property (weak, nonatomic) IBOutlet UILabel *lobsterLicenceNo;
@property (weak, nonatomic) IBOutlet UILabel *vesselName;
@property (weak, nonatomic) IBOutlet UILabel *vesselNumber;
@property (weak, nonatomic) IBOutlet UILabel *zone;

-(void)stopTimer;
@end
