//
//  ViewController.m
//  WJOAuthSDKDemo
//
//  Created by dn4 on 2018/5/18.
//  Copyright © 2018年 zml. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
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

- (void)clickLogin:(id)sender
{
    WJOAuthRequest *request = [WJOAuthRequest request];
    request.state = @"Verification";
    request.scope = @"user_info";
    request.redirectURI = kRedirectURI;
    [WJOAuthSDK sendRequest:request];
}

@end
