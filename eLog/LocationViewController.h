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

@interface LocationViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

-(void)stopTimer;
@end
