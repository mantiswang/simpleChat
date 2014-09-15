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

@interface G4ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *UserName;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation G4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
         if (!error) {
             NSLog(@"登录成功");
         }
         NSLog(@"%@", error.debugDescription);
     } onQueue:nil];
    
}

//处理注册失败
-(void)handleRegisterEaseMobError:(EMError*)error uname:(NSString*)username pwd:(NSString*)password
{
    switch (error.errorCode) {
        case EMErrorServerDuplicatedAccount:              // 注册失败(Ex. 注册时, 如果用户存在, 会返回的error)
        {
            [self loginEaseMob:username password:password];
            break;
        }
        case EMErrorInvalidUsername:                      // 无效的username
        case EMErrorInvalidUsername_NULL:                 // 无效的用户名(用户名为空)
        case EMErrorInvalidUsername_Chinese:              // 无效的用户名(用户名是中文)
        {
            
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
