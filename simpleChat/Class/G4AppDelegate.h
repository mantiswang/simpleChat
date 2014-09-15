//
//  G4AppDelegate.h
//  simpleChat
//
//  Created by wangyue on 14-8-28.
//  Copyright (c) 2014年 wangyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface G4AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
+(id)shareAppDelegate;

-(void)showLogin;
@end
