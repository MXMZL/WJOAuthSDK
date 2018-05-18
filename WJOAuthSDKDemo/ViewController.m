//
//  ViewController.m
//  WJOAuthSDKDemo
//
//  Created by dn4 on 2018/5/18.
//  Copyright © 2018年 zml. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<WJOAuthSDKDelegate>
@property (nonatomic,strong) UIButton* button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.button];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton *)button{
    if (!_button) {
        _button  = [[UIButton alloc]initWithFrame:CGRectMake(0,0,200,50)];
        _button.center = self.view.center;
        _button.backgroundColor = [UIColor redColor];
        [_button setTitle:@"OAuth授权登录" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)clickLogin:(id)sender {
    
    WJOAuthRequest *request = [WJOAuthRequest request];
    request.state = @"Verification";
    request.redirectURI = kRedirectURI;
    [WJOAuthSDK sendRequest:request delegate:self];
    
}

- (void)didReceiveWJOAuthSuccessedResponse:(WJBaseResponse *)response {
    
    WJOAuthSuccessedResponse *authorizeResponse = (WJOAuthSuccessedResponse *)response;
    NSString *requestState = authorizeResponse.requestState;
    NSString *accessToken = authorizeResponse.accessToken;
    NSString *message = [NSString stringWithFormat:@"response.requestState:%@/nresponse.accessToken:%@",requestState,accessToken];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"认证结果" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveWJOAuthFailedResponse:(WJBaseResponse *)response {
    
    WJOAuthFailedResponse *authorizeResponse = (WJOAuthFailedResponse *)response;
    NSString *errorCode = authorizeResponse.errorCode;
    NSString *errorCodeDescription = authorizeResponse.errorCodeDescription;
    NSString *message = [NSString stringWithFormat:@"response.errorCode:%@/nresponse.errorCodeDescription:%@",errorCode,errorCodeDescription];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"认证结果" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveWJOAuthClickedCancelResponse {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户点击取消" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:actionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
