//
//  Group.m
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/6.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

#import "Group.h"
#import "NetworkManager.h"

@implementation Group

+(void)fetchGroup:(NSInteger)page
          success:(void (^)(id))success
          failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] GET:@"Contact Group"
                              parameters:@{
                                           @"limit": @20,
                                           @"offset": @(page * 20),
                                           @"order": @"name"
                                           }
                                 success:^(NSDictionary *dic) {
                                     NSArray *data = dic[@"resource"];
                                     NSMutableArray *array = [[NSMutableArray alloc] init];
                                     for (NSDictionary *element in data) {
                                         Group *group = [[Group alloc] init];
                                         group.ID = [element[@"id"] integerValue];
                                         group.name = element[@"name"];
                                         [array addObject:group];
                                     }
                                     success(array);
                                 }
                                 failure:^(NSError *error) {
                                 }];
}

+(void)editGroup:(NSInteger)ID
            name:(NSString *)name
         success:(void (^)(id))success
         failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] PUT:@"Contact Group"
                              parameters:@{
                                           @"resource": @{
                                                   @"id": @(ID),
                                                   @"name": name
                                                   }
                                           }
                                 success:^(NSDictionary *data) {
                                     success(data[@"resource"][0][@"id"]);
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                     }
                                 }];
}

+(void)createNewGroup:(NSString *)name
              success:(void (^)(id))success
              failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] POST:@"Contact Group"
                            GETParameters: nil
                           POSTParameters:@{
                                            @"resource": @{
                                                    @"name": name
                                                    }
                                            }
                                  success:^(NSDictionary *data) {
                                      success(data[@"resource"][0][@"id"]);
                                  }
                                  failure:^(NSError *error) {
                                      if (failure) {
                                          failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                      }
                                  }];
}

+(void)deleteGroup:(NSInteger)ID
           success:(void (^)(id))success
           failure:(void (^)(NSString *))failure {
    NSString *filter = [NSString stringWithFormat:@"id=%ld", (long)ID];
    [[NetworkManager defaultManager] DELETE:@"Contact Group"
                                 parameters:@{
                                              @"filter": filter
                                              }
                                    success:^(NSDictionary *data) {
                                        success(data[@"resource"] );
                                    }
                                    failure:^(NSError *error) {
                                        if (failure) {
                                            failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                        }
                                    }];
}

@end
