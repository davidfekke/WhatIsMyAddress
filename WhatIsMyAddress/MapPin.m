//
//  MapPin.m
//  WhatIsMyAddress
//
//  Created by David Fekke on 10/28/12.
//  Copyright (c) 2012 David Fekke L.L.C. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        _coordinate = location;
        _title = placeName;
        _subtitle = description;
    }
    return self;
}


@end
