//
//  AppDelegate.m
//  WJOAuthSDKDemo
//
//  Created by dn4 on 2018/5/18.
//  Copyright © 2018年 zml. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WJOAuthSDK setLanguageType:WJLanguageTypeChinese];
    
    [WJOAuthSDK registerApp:kAppKey];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController *vc = [[ViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark -
- (void)didReceiveWJOAuthResponse:(WJBaseResponse *)response responseStatusCode:(WJOAuthSDKResponseStatusCode)responseStatusCode {
    
    if (responseStatusCode == WJOAuthSDKResponseStatusCodeSuccess) {
        WJOAuthSuccessedResponse *authorizeResponse = (WJOAuthSuccessedResponse *)response;
        NSString *requestState = authorizeResponse.requestState;
        NSString *accessToken = authorizeResponse.accessToken;
        NSString *message = [NSString stringWithFormat:@"response.requestState:%@\nresponse.accessToken:%@",requestState,accessToken];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"授权成功" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alertController addAction:actionCancel];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    else if (responseStatusCode == WJOAuthSDKResponseStatusCodeAuthDeny) {
        WJOAuthFailedResponse *authorizeResponse = (WJOAuthFailedResponse *)response;
        NSString *errorCode = authorizeResponse.errorCode;
        NSString *errorCodeDescription = authorizeResponse.errorCodeDescription;
        NSString *message = [NSString stringWithFormat:@"response.errorCode:%@\nresponse.errorCodeDescription:%@",errorCode,errorCodeDescription];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"授权失败" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alertController addAction:actionCancel];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    else if (responseStatusCode == WJOAuthSDKResponseStatusCodeUserCancel) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户点击取消" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alertController addAction:actionCancel];
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WJOAuthSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WJOAuthSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WJOAuthSDK handleOpenURL:url delegate:self ];
}
@end
