//
//  MKMapViewUtil.h
//  CommonUtils
//
//  Created by twiedow on 15.03.14.
//  Copyright (c) 2014 twiedow. All rights reserved.
//

@import MapKit;

@interface MKMapViewUtil : NSObject

+ (MKCoordinateRegion)regionThatFitsAnnotations:(NSArray *)annotations;
+ (void)zoomToFitMapAnnotations:(MKMapView *)mapView;

@end
