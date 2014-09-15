//
//  G4BaseMapViewController.h
//  simpleChat
//
//  Created by apple on 14-9-13.
//  Copyright (c) 2014年 wangyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface G4BaseMapViewController : UIViewController<MAMapViewDelegate, AMapSearchDelegate>


@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) AMapSearchAPI *search;

- (void)returnAction;

@end
