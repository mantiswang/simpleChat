//
//  G4AppDelegate.m
//  simpleChat
//
//  Created by wangyue on 14-8-28.
//  Copyright (c) 2014年 wangyue. All rights reserved.
//

#import "G4AppDelegate.h"
#import "UMSocialSinaHandler.h"

@implementation G4AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
    
    [self initUMengConfig];
	
    // 真机的情况下,notification提醒设置
	UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
	UIRemoteNotificationTypeSound |
	UIRemoteNotificationTypeAlert;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    
	//注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
	NSString *apnsCertName = @"chatdemoui";
	[[EaseMob sharedInstance] registerSDKWithAppKey:@"ywang#sandbox" apnsCertName:apnsCertName];
	[[EaseMob sharedInstance] enableBackgroundReceiveMessage];
	[[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    
	[self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initUMengConfig
{
    //打开调试log的开关
    [UMSocialData openLog:YES];
//
//    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
//
//    //设置微信AppId，设置分享url，默认使用友盟的网址
//    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
//    
    //打开新浪微博的SSO开关
//    3897149259
//    2296e9c17967204f9e55780d8291072b
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
//
//    //打开腾讯微博SSO开关，设置回调地址
//    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];
//    
//    //打开人人网SSO开关
//    [UMSocialRenrenHandler openSSO];
//    
//    //设置分享到QQ空间的应用Id，和分享url 链接
//    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
//    //设置支持没有客户端情况下使用SSO授权
//    [UMSocialQQHandler setSupportWebView:YES];
//    
//    //设置易信Appkey和分享url地址
//    [UMSocialYixinHandler setYixinAppKey:@"yx35664bdff4db42c2b7be1e29390c1a06" url:@"http://www.umeng.com/social"];
//    
//    //设置来往AppId，appscret，显示来源名称和url地址
//    [UMSocialLaiwangHandler setLaiwangAppId:@"8112117817424282305" appSecret:@"9996ed5039e641658de7b83345fee6c9" appDescription:@"友盟社会化组件" urlStirng:@"http://www.umeng.com/social"];
//    
//    //使用友盟统计
//    [MobClick startWithAppkey:UmengAppkey];
//    
//    //    设置facebook应用ID，和分享纯文字用到的url地址
//    [UMSocialFacebookHandler setFacebookAppID:@"91136964205" shareFacebookWithURL:@"http://www.umeng.com/social"];
//    
//    //    下面打开Instagram的开关
//    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
//    
//    [UMSocialTwitterHandler openTwitter];
    

}

@end
