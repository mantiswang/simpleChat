//
//  G4ViewController.m
//  simpleChat
//
//  Created by wangyue on 14-8-28.
//  Copyright (c) 2014年 wangyue. All rights reserved.
//

#import "G4ViewController.h"

#import "EaseMob.h"

#import "UMSocialSnsPlatformManager.h"

#import "LocationUtil.h"

@interface G4ViewController ()

@property (nonatomic, strong)        CLLocation  *location;

@end

@implementation G4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange:) name:KNOTIFICATION_LOCATIONCHANGE object:nil];
    
    [[LocationUtil sharedLocationUtil] startLocationUpdates];
}

-(void)locationChange:(NSNotification*) notification
{
    _location = nil;
    _location = notification.object;
    [[LocationUtil sharedLocationUtil] stopLocationUpdates];
    NSLog(@"location is %f, %f", _location.coordinate.latitude, _location.coordinate.longitude);
}

- (IBAction)qqLogin:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
    });
}

- (IBAction)sinaLogin:(id)sender {
    
    __unsafe_unretained typeof (self) this = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if(!response.error)
        {
            //            NSLog(@"UMSocial %@", [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToSina]);
            UMSocialCustomAccount* account = [[UMSocialAccountManager socialAccountDictionary] objectForKey:UMShareToSina];
            
            //FIXME:ywang 2014/09/13
            //检查本地是否保存了用户名（用户注册成功保存本地）
            [this registerEaseMobWithUname:account.usid PWD:@"G4SimpleChat"];
        }
    });
}





-(void)registerEaseMobWithUname:(NSString*)uName PWD:(NSString*) pwd
{
    __unsafe_unretained typeof (self) this = self;
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:uName password:pwd withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
            [this loginEaseMob:username password:password];
            return ;
        }
        
        [this handleRegisterEaseMobError:error uname:username pwd:password];
        
    } onQueue:nil];
    
}


-(void)loginEaseMob:(NSString*)username password:(NSString*)password
{
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         if (loginInfo && !error) {
             NSLog(@"登录成功");
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
         }else{
             NSString *message = nil;
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     message = @"连接服务器失败!";
                     break;
                 case EMErrorServerAuthenticationFailure:
                     message = @"用户名或密码错误";
                     break;
                 case EMErrorServerTimeout:
                     message = @"连接服务器超时!";
                     break;
                 default:
                     message = @"登录失败";
                     break;
             }

             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:message
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }
             
             
     } onQueue:nil];
    
}

//处理注册失败
-(void)handleRegisterEaseMobError:(EMError*)error uname:(NSString*)username pwd:(NSString*)password
{
    NSString *message = nil;
    switch (error.errorCode) {
        case EMErrorServerDuplicatedAccount:              // 注册失败(Ex. 注册时, 如果用户存在, 会返回的error)
        {
            [self loginEaseMob:username password:password];
            return;
        }
        case EMErrorInvalidUsername:                      // 无效的username
        case EMErrorInvalidUsername_NULL:                 // 无效的用户名(用户名为空)
        case EMErrorInvalidUsername_Chinese:              // 无效的用户名(用户名是中文)
        {
            
            break;
        }
        case EMErrorServerNotReachable:
            message = @"连接服务器失败!";
            break;

        case EMErrorServerTimeout:
            message = @"连接服务器超时!";
            break;
        default:
            message = @"注册失败";
            break;

    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
