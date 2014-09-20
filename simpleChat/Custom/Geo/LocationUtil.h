//
//  LocationUtil.h
//  CommonUtils
//
//  Created by twiedow on 14.03.14.
//  Copyright (c) 2014 twiedow. All rights reserved.
//

#import <Foundation/Foundation.h>


@import CoreLocation;

@interface LocationUtil : NSObject

@property (strong, nonatomic, readonly) CLLocation *lastCurrentLocation;

+ (instancetype)sharedLocationUtil;

- (void)startLocationUpdates;
- (void)stopLocationUpdates;

@end
