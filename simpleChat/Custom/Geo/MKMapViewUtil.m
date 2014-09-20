//
//  MKMapViewUtil.m
//  CommonUtils
//
//  Created by twiedow on 15.03.14.
//  Copyright (c) 2014 twiedow. All rights reserved.
//

#import "MKMapViewUtil.h"

@implementation MKMapViewUtil


+ (MKCoordinateRegion)regionThatFitsAnnotations:(NSArray *)annotations {
	CLLocationCoordinate2D topLeftCoord = CLLocationCoordinate2DMake(-90, 180);
	CLLocationCoordinate2D bottomRightCoord = CLLocationCoordinate2DMake(90, -180);

	for (id<MKAnnotation> annotation in annotations) {
		topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);

		bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
		bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
	}

	MKCoordinateRegion region;
	region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
	region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
	region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3;
	region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;

	return region;
}


+ (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
	if ([mapView.annotations count] == 0)
		return;

	MKCoordinateRegion region = [MKMapViewUtil regionThatFitsAnnotations:mapView.annotations];
	region = [mapView regionThatFits:region];

  if (isnan(region.center.latitude) || isnan(region.center.longitude) || isnan(region.span.latitudeDelta) || isnan(region.span.longitudeDelta))
		return;

  [mapView setRegion:region animated:YES];
}

@end
