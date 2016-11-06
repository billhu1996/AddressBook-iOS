//
//  ContactInfo.m
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/6.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

#import "ContactInfo.h"
#import "NetworkManager.h"

@implementation ContactInfo

+(void)fetchContactInfo:(NSInteger)page
                success:(void (^)(id))success
                failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] GET:@"Contact Info"
                              parameters:@{
                                           @"limit": @20,
                                           @"offset": @(page)
                                           }
                                 success:^(NSDictionary *dic) {
                                     NSArray *data = dic[@"resource"];
                                     NSMutableArray *array = [[NSMutableArray alloc] init];
                                     for (NSDictionary *element in data) {
                                         ContactInfo *contactInfo = [[ContactInfo alloc] init];
                                         contactInfo.ID = [element[@"id"] integerValue];
                                         contactInfo.infoType = element[@"info_type"];
                                         contactInfo.phone = element[@"phone"];
                                         contactInfo.email = element[@"email"];
                                         contactInfo.address = element[@"address"];
                                         contactInfo.city = element[@"city"];
                                         contactInfo.state = element[@"state"];
                                         contactInfo.zip = element[@"zip"];
                                         contactInfo.country = element[@"country"];
                                         [array addObject:contactInfo];
                                     }
                                     success(array);
                                 }
                                 failure:^(NSError *error) {
                                     failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                 }];
}

+(void)editContactInfo:(NSInteger)ID
              infoType:(NSString *)infoType
                 phone:(NSString *)phone
                 email:(NSString *)email
               address:(NSString *)address
                  city:(NSString *)city
                 state:(NSString *)state
                   zip:(NSString *)zip
               country:(NSString *)country
               success:(void (^)(id))success
               failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] PUT:@"Contact Info"
                              parameters:@{
                                           @"resource": @{
                                                   @"info_type": infoType,
                                                   @"phone": phone,
                                                   @"email": email,
                                                   @"address": address,
                                                   @"city": city,
                                                   @"state": state,
                                                   @"zip": zip,
                                                   @"country": country
                                                   }
                                           }
                                 success:^(NSDictionary *data) {
                                     success(data[@"resource"][0][@"id"]);
                                 }
                                 failure:^(NSError *error) {
                                     failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                 }];
}

+(void)createNewContactInfo:(NSString *)infoType
                      phone:(NSString *)phone
                      email:(NSString *)email
                    address:(NSString *)address
                       city:(NSString *)city
                      state:(NSString *)state
                        zip:(NSString *)zip
                    country:(NSString *)country
                    success:(void (^)(id))success
                    failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] POST:@"Contact"
                            GETParameters: nil
                           POSTParameters:@{
                                            @"resource": @{
                                                    @"info_type": infoType,
                                                    @"phone": phone,
                                                    @"email": email,
                                                    @"address": address,
                                                    @"city": city,
                                                    @"state": state,
                                                    @"zip": zip,
                                                    @"country": country
                                                    }
                                            }
                                  success:^(NSDictionary *data) {
                                      success(data[@"resource"][0][@"id"]);
                                  }
                                  failure:^(NSError *error) {
                                      failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                  }];
}

@end
