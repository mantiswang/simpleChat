//
//  LocationUtil.m
//  CommonUtils
//
//  Created by twiedow on 14.03.14.
//  Copyright (c) 2014 twiedow. All rights reserved.
//

#import "LocationUtil.h"


@interface LocationUtil () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastCurrentLocation;

@end


@implementation LocationUtil


+ (instancetype)sharedLocationUtil {
	static dispatch_once_t onceToken;
	static LocationUtil *sharedLocationUtil;

	dispatch_once(&onceToken, ^{
		sharedLocationUtil = [[LocationUtil alloc] init];
	});

	return sharedLocationUtil;
}


- (void)startLocationUpdates {
    
    NSLog(@" authorizationStatus %i， locationServicesEnabled %i ", [CLLocationManager authorizationStatus], [CLLocationManager locationServicesEnabled]);
    
	if (self.locationManager == nil && [CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized )) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.pausesLocationUpdatesAutomatically = YES;
		self.locationManager.distanceFilter = 100.0;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
		self.locationManager.delegate = self;
        
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        
		[self.locationManager startUpdatingLocation];
	}
}


- (void)stopLocationUpdates {
	if (self.locationManager != nil) {
		[self.locationManager stopUpdatingLocation];
		self.locationManager = nil;
	}
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *location = locations.lastObject;

	if (location.horizontalAccuracy >= 0)
    {
		self.lastCurrentLocation = location;
//        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOCATIONCHANGE object:self.lastCurrentLocation];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	[self stopLocationUpdates];
}

@end
