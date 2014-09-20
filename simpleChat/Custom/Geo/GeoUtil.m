//
//  GeoUtil.m
//  CommonUtils
//
//  Created by twiedow on 13.03.14.
//  Copyright (c) 2014 twiedow. All rights reserved.
//

#import "GeoUtil.h"

@implementation GeoUtil


+ (double)toRadians:(double)degree {
	return degree * M_PI / 180.0;
}


+ (double)distanceBetweenPositionWithLatitude:(double)latitude1 withLongitude:(double)longitude1 andPositionWithLatitude:(double)latitude2 withLongitude:(double)longitude2 {
	double radLat1=[GeoUtil toRadians:latitude1];
	double radLon1=[GeoUtil toRadians:longitude1];
	double radLat2=[GeoUtil toRadians:latitude2];
	double radLon2=[GeoUtil toRadians:longitude2];

	double result=cos(radLat1)*cos(radLat2)*cos(radLon2-radLon1)+sin(radLat1)*sin(radLat2);
	return result>1?0:6371000*acos(result);
}

@end
