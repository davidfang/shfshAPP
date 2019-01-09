/**
 * Copyright (c) 2015-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "RNSplashScreen.h"  // 导入启动页插件
#import <UMCommon/UMCommon.h>           // 公共组件是所有友盟产品的基础组件，必选
#import <UMAnalytics/MobClick.h>        // 统计组件
#import <UMShare/UMShare.h>    // 分享组件
#import <UMPush/UMessage.h>             // Push组件
#import <UserNotifications/UserNotifications.h>  // Push组件必须的系统库


/* 开发者可根据功能需要引入相应组件头文件，并导入相应组件库*/
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // 配置友盟SDK产品并并统一初始化
  // [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO.
  [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
  [UMConfigure initWithAppkey:@"5c25bfa6f1f55668e00002c8" channel:@"App Store"];
  /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
  
  // 统计组件配置
  [MobClick setScenarioType:E_UM_NORMAL];
  // [MobClick setScenarioType:E_UM_GAME];  // optional: 游戏场景设置
  
  // Push组件基本功能配置
  [UNUserNotificationCenter currentNotificationCenter].delegate = self;
  UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
  //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标等
  entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionAlert;
  [UNUserNotificationCenter currentNotificationCenter].delegate = self;
  //关闭友盟自带的弹出框
  //[UMessage setAutoAlert:NO];
  [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError * _Nullable error) {
    if (granted) {
      // 用户选择了接收Push消息
    }else{
      // 用户拒绝接收Push消息
    }
  }];
  
  /*
  // 请参考「Share详细介绍-初始化第三方平台」
  // 分享组件配置，因为share模块配置可选三方平台较多，代码基本跟原版一样，也可下载demo查看
  [self configUSharePlatforms];   // required: setting platforms on demand
  */
  
  NSURL *jsCodeLocation;

  jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];

  RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                      moduleName:@"shuafenshou"
                                               initialProperties:nil
                                                   launchOptions:launchOptions];
  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];

  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  [RNSplashScreen show];  // 显示启动页
  return YES;
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                stringByReplacingOccurrencesOfString: @">" withString: @""]
               stringByReplacingOccurrencesOfString: @" " withString: @""]);
}
//iOS10以下使用这两个方法接收通知，
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  [UMessage setAutoAlert:NO];
  if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
    completionHandler(UIBackgroundFetchResultNewData);
  }
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//    //关闭友盟自带的弹出框
//    [UMessage setAutoAlert:NO];
//    [UMessage didReceiveRemoteNotification:userInfo];
//
//    //    self.userInfo = userInfo;
//    //    //定制自定的的弹出框
//    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
//    //    {
//    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
//    //                                                            message:@"Test On ApplicationStateActive"
//    //                                                           delegate:self
//    //                                                  cancelButtonTitle:@"确定"
//    //                                                  otherButtonTitles:nil];
//    //
//    //        [alertView show];
//    //
//    //    }
//
//}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //应用处于前台时的远程推送接受
    //关闭U-Push自带的弹出框
    [UMessage setAutoAlert:NO];
    //必须加这句代码
    [UMessage didReceiveRemoteNotification:userInfo];
    
  }else{
    //应用处于前台时的本地推送接受
  }
  //当应用处于前台时提示设置，需要哪个可以设置哪一个
  completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    //应用处于后台时的远程推送接受
    //必须加这句代码
    [UMessage didReceiveRemoteNotification:userInfo];
    
  }else{
    //应用处于后台时的本地推送接受
  }
}
@end
