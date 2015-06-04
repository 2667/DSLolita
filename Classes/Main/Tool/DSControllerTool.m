//
//  DSControllerTool.m
//  DSLolita
//
//  Created by 赛 丁 on 15/5/25.
//  Copyright (c) 2015年 samDing. All rights reserved.
//

#import "DSControllerTool.h"
#import "DSTabBarController.h"
#import "ConversationStore.h"
//#import "DSNewfeatureViewController.h"

@implementation DSControllerTool

+ (void)chooseRootViewController {
    
    //比较上次使用的版本情况
    NSString *versionKey = (__bridge NSString *)kCFBundleVersionKey;
    
    //从沙盒中取出上次存储的软件版本号（取出用户上次的使用记录）
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    //获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [UIApplication sharedApplication].statusBarHidden = NO;
//    if ([currentVersion isEqualToString:lastVersion]){
//        //当前是最新版本
//        [UIApplication sharedApplication].statusBarHidden = NO;
//        window.rootViewController = [[DSTabBarController alloc] init];
//    }else{
//        //当前不是最新版本，显示版本新特性
//        window.rootViewController = [[DSNewfeatureViewController alloc] init];
//        
//        //存储这次使用的版本信息
//        [defaults setObject:currentVersion forKey:versionKey];
//        [defaults synchronize];
//    }
            DSTabBarController *vc = [[DSTabBarController alloc] init];
            AVUser *currentUser = [AVUser currentUser];
            AVIMClient *imclient = [[AVIMClient alloc] init];
            imclient.delegate = vc;
    
            NSLog(@"open avimclient!");
            [imclient openWithClientId:[currentUser objectId] callback:^(BOOL succeeded , NSError *error){
            if (error){
                NSLog(@"聊天不可用");
            }else{
            ConversationStore *store = [ConversationStore sharedInstance];
            store.imClient = imclient;
            [store reviveFromLocal:currentUser];
            
            window.rootViewController = vc;
        }
    }];

    
}

@end
