//
//  LoginManager.h
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/10/29.
//  Copyright © 2016年 BISTU. All rights reserved.
//

#import "NetworkManager.h"

@interface LoginManager : NetworkManager

+(void)login:(NSString *)email
    password:(NSString *)password
     success:(void (^)(NSDictionary *))success
     failure:(void (^)(NSString *))failure;
+(void)signUp:(NSString *)email
     password:(NSString *)password
        phone:(NSString *)phone
    verfyCode:(NSString *)verfyCode
      success:(void (^)(NSDictionary *))success
      failure:(void (^)(NSString *))failure;
+(void)resetPassword:(NSString *)email
             success:(void (^)(NSString *))success
             failure:(void (^)(NSString *))failure;
+(void)fetchVerfyCode:(NSString *)phone
              success:(void (^)())success
              failure:(void (^)(NSString *))failure;
+(void)refreshToken;
@end
