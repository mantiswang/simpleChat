//
//  G4AppDelegate.m
//  simpleChat
//
//  Created by wangyue on 14-8-28.
//  Copyright (c) 2014年 wangyue. All rights reserved.
//

#import "G4AppDelegate.h"

//环信
#import "EaseMob.h"

//友盟
#import "UMSocial.h"
#import "MobClick.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"


//高德地图
#import <MAMapKit/MAMapKit.h>

#import "APIKey.h"


#import "MainViewController.h"

@implementation G4AppDelegate

+(id)shareAppDelegate
{
    static G4AppDelegate *_shareG4AppDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareG4AppDelegate = [UIApplication sharedApplication].delegate;
    });
    
    return _shareG4AppDelegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];
    
    [self registerNotification];
    //设置AESKey
    [[NSUserDefaults standardUserDefaults] setAESKey:(NSString*)AESKeyString];
    
    //UMeng config
    [self umengConfig];
    
    //高德地图
    [self aMapConfig];

    
#if !TARGET_IPHONE_SIMULATOR
    UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
    UIRemoteNotificationTypeSound |
    UIRemoteNotificationTypeAlert;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
#endif
    


    
    //环信config
	[self easeMobConfig:application launchOptions:launchOptions];
    

    //以下一行代码的方法里实现了自动登录，异步登录，需要监听[didLoginWithInfo: error:]
    //demo中此监听方法在MainViewController中
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
//#warning 注册为SDK的ChatManager的delegate (及时监听到申请和通知)
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
#warning 如果使用MagicalRecord, 要加上这句初始化MagicalRecord
    //demo coredata, .pch中有相关头文件引用
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite", @"UIDemo"]];
    
    
    [self checkLogin];
    
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


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
}

-(void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    if(loginSuccess)
    {
        MainViewController* _mainController = [[MainViewController alloc] init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
        self.window.rootViewController = nav;
        
        [nav setNavigationBarHidden:YES];
        [nav setNavigationBarHidden:NO];
    }
    else
    {
        
    }
}

-(void)easeMobConfig:(UIApplication*)application launchOptions:(NSDictionary *)launchOptions
{
    // 真机的情况下,notification提醒设置
	UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
	UIRemoteNotificationTypeSound |
	UIRemoteNotificationTypeAlert;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    
	//注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"chatdemoui_dev";
#else
    apnsCertName = @"chatdemoui";
#endif
    
	[[EaseMob sharedInstance] registerSDKWithAppKey:@"ywang#sandbox" apnsCertName:apnsCertName];
	[[EaseMob sharedInstance] enableBackgroundReceiveMessage];
	[[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
}

/**
 *
 *  友盟配置
 *
 */
-(void)umengConfig
{
    //UMeng 统计
    [MobClick startWithAppkey:(NSString *)UMengAPIKey reportPolicy:BATCH channelId:@"ywang"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:(NSString *)UMengAPIKey];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    //    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"101124860" appKey:@"9b482ce0adc63f78e94b5c3f0d3af33d" url:@"http://www.umeng.com/social"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    //    [UMSocialQQHandler setQQWithAppId:@"101124860" appKey:@"9b482ce0adc63f78e94b5c3f0d3af33d" url:@"http://www.umeng.com/social"];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
}

/**
 *
 * 高德配置
 *
 */
-(void)aMapConfig
{
    [MAMapServices sharedServices].apiKey = (NSString *)AMapAPIKey;
}


-(void)checkLogin
{
    NSString* uname = [[NSUserDefaults standardUserDefaults] decryptedValueForKey:kSDKUsername];
    NSString* pwd = [[NSUserDefaults standardUserDefaults] decryptedValueForKey:kSDKPassword];

    if(uname != nil && pwd != nil)//登录
    {
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uname
                                                            password:pwd
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *error) {
             if (!error) {
                 MainViewController* _mainController = [[MainViewController alloc] init];
                 UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:_mainController];
                 self.window.rootViewController = nav;
                 
                 [nav setNavigationBarHidden:YES];
                 [nav setNavigationBarHidden:NO];
             }
             else //登陆失败
             {
                 [self showLogin];
             }
         } onQueue:nil];
    }
    else
    {
        [self showLogin];
    }
    
}

-(void)showLogin
{
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
}


@end
