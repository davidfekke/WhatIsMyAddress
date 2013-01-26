//
//  MainViewController.h
//  WhatIsMyAddress
//
//  Created by Peter Fekke on 10/27/12.
//  Copyright (c) 2012 David Fekke L.L.C. All rights reserved.
//

#import "FlipsideViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapPin.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (weak, nonatomic) IBOutlet UILabel *AccuracyLabel;

@end
