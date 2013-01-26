//
//  MainViewController.m
//  WhatIsMyAddress
//
//  Created by Peter Fekke on 10/27/12.
//  Copyright (c) 2012 David Fekke L.L.C. All rights reserved.
//

#import "MainViewController.h"

#define METERS_PER_MILE 1609.344

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize locationManager, currentLocation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    
    float latitude = self.currentLocation.coordinate.latitude;
    float longitude = self.currentLocation.coordinate.longitude;
    
    float horAccur = self.currentLocation.horizontalAccuracy;
    
    
    self.AddressLabel.text = [[NSString alloc] initWithFormat:@"latlng=%f,%f", latitude, longitude];;
    self.AccuracyLabel.text = [[NSString alloc] initWithFormat:@"Accuracy: %f", horAccur]; 
    
    @try {
        if(newLocation.horizontalAccuracy <= 100.0f)
        {
            [locationManager stopUpdatingLocation];
            
            CLLocationCoordinate2D zoomLocation;
            zoomLocation.latitude = latitude;
            zoomLocation.longitude= longitude;
            
            // 2
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
            
            // 3
            [self.MapView setRegion:viewRegion animated:YES];
            
            NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", latitude, longitude];
            
            NSURL *myUrl = [[NSURL alloc] initWithString:urlString];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myUrl];
            //[request setHTTPMethod:@"GET"];
            //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            NSURLResponse *response = nil;
            NSError *myErr;
            NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&myErr];
            
            //NSData *myData = [[NSData alloc] initWithContentsOfURL:myUrl];
            NSError *myError;
            NSDictionary *myDict = [NSJSONSerialization JSONObjectWithData:myData options:kNilOptions error:&myError];
            
            if ([myDict valueForKey:@"results"] != nil)
            {
                NSArray *myArray = [myDict objectForKey:@"results"];
                
                if ([myArray objectAtIndex:0] != nil)
                {
                    NSDictionary *myDict2 = myArray[0];
                    
                    NSString *myAddress = [myDict2 objectForKey:@"formatted_address"];
                    self.AddressLabel.text = myAddress;
                    
                    MapPin *myPin = [[MapPin alloc] initWithCoordinates:zoomLocation placeName:@"Current Location" description:myAddress];
                    [self.MapView addAnnotation:myPin];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception description]);
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorDenied) {
        [locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
