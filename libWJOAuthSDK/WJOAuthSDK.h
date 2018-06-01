//
//  WJOAuthSDK.h
//  WJOAuthSDK
//
//  Created by dn4 on 2018/5/4.
//  Copyright © 2018年 dn4. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WJOAuthSDKDelegate;
@class WJBaseRequest;
@class WJBaseResponse;

typedef NS_ENUM(NSInteger,WJOAuthSDKResponseStatusCode)
{
    WJOAuthSDKResponseStatusCodeSuccess               = 0,//授权成功
    WJOAuthSDKResponseStatusCodeUserCancel            = -1,//用户取消
    WJOAuthSDKResponseStatusCodeAuthDeny              = -2,//授权失败
};

typedef NS_ENUM(NSInteger, WJLanguageType)
{
    WJLanguageTypeChinese               = -1,//中文
    WJLanguageTypeEnglish               = -2,//英文
};

/**
 WJOAuthSDK接口类
 */
@interface WJOAuthSDK : NSObject

/**
 获取当前WJOAuthSDK的版本号
 @return 当前WJOAuthSDK的版本号
 */
+ (NSString *)getSDKVersion;

/**
 授权页语言
 @param languageType 设置授权页语言，默认跟随系统，若系统语言为中文，则为简体中文，否则，为英文
 @return 语言设置成功返回YES，失败返回NO
 */
+ (BOOL)setLanguageType:(WJLanguageType)languageType;

/**
 向WJOAuthSDK注册第三方应用
 @param appKey 第三方应用appKey
 @return 注册成功返回YES，失败返回NO
 */
+ (BOOL)registerApp:(NSString *)appKey;


/**
 处理WJOAuthSDK通过URL启动第三方应用时传递的数据
 
 需要在 application:openURL:sourceApplication:annotation:、application:handleOpenURL或者application:openURL:options:中调用
 @param url 启动第三方应用的URL
 @param delegate WJOAuthSDKDelegate对象，用于接收WJOAuthSDK触发的消息
 @see WJOAuthSDKDelegate
 */
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id<WJOAuthSDKDelegate>)delegate;

/**
 发送请求给WJOAuthSDK，并切换到授权页面
 
 请求发送给WJOAuthSDK之后，WJOAuthSDK会进行相关的处理，处理完成之后一定会调用 [WJOAuthSDKDelegate didReceiveWJOAuthResponse:responseStatusCode:] 方法将处理结果返回给第三方应用
 @param request 具体的发送请求
 @see [WJOAuthSDKDelegate didReceiveWJOAuthResponse:responseStatusCode:]
 @see WJOAuthBaseRequest
 */
+ (BOOL)sendRequest:(WJBaseRequest *)request;

@end

/**
 接收并处理来自WJOAuthSDK的事件消息
 */
@protocol WJOAuthSDKDelegate <NSObject>

/**
 收到一个来自WJOAuthSDK的响应
 
 收到WJOAuthSDK的响应后，第三方应用可以通过响应类型、响应的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWJOAuthResponse:(WJBaseResponse *)response responseStatusCode:(WJOAuthSDKResponseStatusCode)responseStatusCode;

@end

#pragma mark - Base Request/Response
/**
 WJOAuthSDK所有请求类的基类
 */
@interface WJBaseRequest : NSObject

/**
 自定义信息字符串，用于数据传输过程中校验相关的上下文环境数据

 如果未填写，则response.requestState为空；若填写，响应成功时，则 response.requestState 和原 request.state 中的数据保持一致
 */
@property (nonatomic, strong) NSString *state;

/**
 返回一个 WJBaseRequest 对象
 
 @return 返回一个*自动释放的*WJBaseRequest对象
 */
+ (id)request;

@end

/**
WJOAuthSDK所有响应类的基类
 */
@interface WJBaseResponse : NSObject

/**
 返回一个 WJBaseResponse 对象
 
 @return 返回一个*自动释放的*WJBaseResponse对象
 */
+ (id)response;

@end

#pragma mark - OAuth Request/Response
/**
 第三方应用向WJOAuthSDK请求认证的消息结构
 
 第三方应用向WJOAuthSDK申请认证时，需要调用 [WJOAuthSDK sendRequest: delegate:] 函数， 向WJOAuthSDK发送一个 WJBaseRequest 的消息结构。
 WJOAuthSDK处理完后会向第三方应用发送一个结构为 WJBaseResponse 的处理结果。
 */
@interface WJOAuthRequest : WJBaseRequest

/**
 第三方应用授权回调页地址
 
 @warning 不能为空，长度小于1K
 */
@property (nonatomic, strong) NSString *redirectURI;

/**
 以空格分隔的权限列表，若不传递此参数，代表请求用户的默认权限
 参考开放平台权限列表
 @warning 长度小于1K
 */
@property (nonatomic, strong) NSString *scope;

@end

/**
WJOAuthSDK处理完第三方应用的认证申请后向第三方应用回送的处理结果
 
 WJOAuthSuccessedResponse 结构中包含常用的 requestState、accessToken
 */
@interface WJOAuthSuccessedResponse : WJBaseResponse

/**
 对应的 request 中的state
 
 如果当前 response 是由WJOAuthSDK响应给第三方应用的，则 requestState 和原 request.state 中的数据保持一致
 
 @see WJBaseRequest.state
 */
@property (nonatomic, strong) NSString *requestState;

/**
 认证口令
 */
@property (nonatomic, strong) NSString *accessToken;

@end

@interface WJOAuthFailedResponse : WJBaseResponse
/**
 响应状态码
 
 第三方应用可以通过errorCode判断请求的处理结果
 */
@property (nonatomic, strong) NSString *errorCode;

/**
 响应状态码描述
 
 第三方应用可以通过errorCodeDescription判断请求的显示结果
 */
@property (nonatomic, strong) NSString *errorCodeDescription;

@end



