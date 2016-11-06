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
    [[NetworkManager defaultManager] GET:@"Group"
                              parameters:@{
                                           @"limit": @20,
                                           @"offset": @(page)
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
                                     failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                 }];
}

+(void)editGroup:(NSInteger)ID
            name:(NSString *)name
           success:(void (^)(id))success
           failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] PUT:@"Group"
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
                                     failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                 }];
}

+(void)createNewGroup:(NSString *)name
                success:(void (^)(id))success
                failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] POST:@"Group"
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
                                      failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                  }];
}

@end
