//
//  GeoUtil.h
//  CommonUtils
//
//  Created by twiedow on 13.03.14.
//  Copyright (c) 2014 twiedow. All rights reserved.
//

@interface GeoUtil : NSObject

+ (double)toRadians:(double)degree;
+ (double)distanceBetweenPositionWithLatitude:(double)latitude1 withLongitude:(double)longitude1 andPositionWithLatitude:(double)latitude2 withLongitude:(double)longitude2;

@end
