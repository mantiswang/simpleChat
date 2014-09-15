//
//  CustomAnnotationView.h
//  simpleChat
//
//  Created by apple on 14-9-13.
//  Copyright (c) 2014年 wangyue. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;
@end
