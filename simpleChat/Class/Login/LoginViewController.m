//
//  LoginViewController.m
//  simpleChat
//
//  Created by wangyue on 14-8-28.
//  Copyright (c) 2014年 wangyue. All rights reserved.
//

#import "LoginViewController.h"

#import "EaseMob.h"

#import "UMSocialSnsPlatformManager.h"


@interface LoginViewController ()


@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setupViews];
    
}

-(void)setupViews
{
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImgView.image = [UIImage imageNamed:@"LoginBg"];
    [self.view addSubview:bgImgView];
    
    UIButton* sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaBtn.frame = CGRectMake(SCREEN_WIDTH / 2 - 58 - 30, SCREEN_HEIGHT * 0.618, 58, 58);
    [sinaBtn setImage:[UIImage imageNamed:@"SinaLogo"] forState:UIControlStateNormal];
    [sinaBtn addTarget:self action:@selector(sinaLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinaBtn];
    
    UIButton* qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqBtn.frame = CGRectMake(SCREEN_WIDTH / 2 + 30, SCREEN_HEIGHT * 0.618, 58, 58);
    [qqBtn setImage:[UIImage imageNamed:@"QQLogo"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(qqLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqBtn];
    
}

- (void)qqLogin {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
    });
}

- (void)sinaLogin {
    
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
             [[NSUserDefaults standardUserDefaults] encryptValue:username withKey:kUsername];
             [[NSUserDefaults standardUserDefaults] encryptValue:password withKey:kPassword];
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
