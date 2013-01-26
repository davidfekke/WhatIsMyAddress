//
//  MapPin.h
//  WhatIsMyAddress
//
//  Created by David Fekke on 10/28/12.
//  Copyright (c) 2012 David Fekke L.L.C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject <MKAnnotation> {
    //CLLocationCoordinate2D coordinate;
    //NSString *title;
    //NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description;


@end
