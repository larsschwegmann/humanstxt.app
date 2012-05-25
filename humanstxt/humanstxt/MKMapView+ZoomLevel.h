//
//  MKMapView+ZoomLevel.h
//  humanstxt
//
//  Created by Lars Schwegmann on 25.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//
#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
