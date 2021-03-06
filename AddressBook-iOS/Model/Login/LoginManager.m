 //
//  LoginManager.m
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/10/29.
//  Copyright © 2016年 BISTU. All rights reserved.
//

#import "LoginManager.h"
#import "NetworkManager.h"
#import <SMS_SDK/SMSSDK.h>
#import "AddressBook_iOS-Swift.h"

@implementation LoginManager

+(void)login:(NSString *)email
    password:(NSString *)password
     success:(void (^)(NSDictionary *))success
     failure:(void (^)(NSString *))failure
{
    [[NetworkManager defaultManager] POST:@"Login"
                              GETParameters:nil
                             POSTParameters:@{
                                              @"email": email,
                                              @"password": password
                                              }
                                    success:^(NSDictionary *data) {
                                        NSString *session = data[@"session_token"];
                                        [NetworkManager defaultManager].token = session;
                                        success(data);
                                    }
                                    failure:^(NSError *error) {
                                        failure(error.userInfo[NSLocalizedDescriptionKey]);
                                    }];
}

+(void)fetchVerfyCode:(NSString *)phone
              success:(void (^)())success
              failure:(void (^)(NSString *))failure
{
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:phone zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error) {
                                     if (error) {
                                         failure(error.userInfo[@"getVerificationCode"]);
                                     } else {
                                         success();
                                     }
                                 }];
}

+(void)signUp:(NSString *)email
     password:(NSString *)password
        phone:(NSString *)phone
    verfyCode:(NSString *)verfyCode
      success:(void (^)(NSDictionary *))success
      failure:(void (^)(NSString *))failure
{
    [SMSSDK commitVerificationCode:verfyCode
                       phoneNumber:phone
                              zone:@"86"
                            result:^(SMSSDKUserInfo *userInfo, NSError *error) {
                                if (error) {
                                    failure(error.userInfo[@"commitVerificationCode"]);
                                } else {
                                    [[NetworkManager defaultManager] POST:@"Register"
                                                              GETParameters:nil
                                                             POSTParameters:@{
                                                                              @"email": email,
                                                                              @"password": password,
                                                                              @"phone": phone
                                                                              }
                                                                    success:^(NSDictionary *data) {
                                                                        success(data);
                                                                    }
                                                                    failure:^(NSError *error) {
                                                                        failure(error.userInfo[NSLocalizedDescriptionKey]);
                                                                    }];
                                }
                            }];
}

+(void)resetPassword:(NSString *)email
             success:(void (^)(NSString *))success
             failure:(void (^)(NSString *))failure
{
    [[NetworkManager defaultManager] POST:@"Change Password"
                              GETParameters:@{
                                              @"reset":@"true"
                                              }
                             POSTParameters:@{
                                              @"email": email
                                              }
                                  success:^(NSDictionary *data) {
                                      success(@"success");
                                  }
                                  failure:^(NSError *error) {
                                      if (failure) {
                                          failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                      }
                                  }];
}

+(void)refreshToken
{
    [[NetworkManager defaultManager] PUT:@"Login" parameters:nil success:^(NSDictionary *data) {
        NSString *session = data[@"session_token"];
        [NetworkManager defaultManager].token = session;
    } failure:^(NSError *error) {
        [AppDelegate appDelegate].rootVC = [[NSBundle mainBundle] loadNibNamed:@"LoginViewController" owner:nil options:nil].firstObject;
        [AppDelegate appDelegate].window.rootViewController = [AppDelegate appDelegate].rootVC;
        [[AppDelegate appDelegate].window makeKeyAndVisible];
    }];
}

@end
