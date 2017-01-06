//
//  GroupRelationship.m
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/6.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

#import "GroupRelationship.h"
#import "NetworkManager.h"
#import "Contact.h"

@implementation GroupRelationship

+(void)fetchContactWith:(NSInteger)groupID
                   page:(NSInteger)page
                success:(void (^)(id))success
                failure:(void (^)(NSString *))failure {
    NSString *filter = [NSString stringWithFormat:@"contact_group_id=%ld", (long)groupID];
    [[NetworkManager defaultManager] GET:@"Contact In Group"
                              parameters:@{
                                           @"limit": @20,
                                           @"offset": @(page * 20),
                                           @"filter": filter,
                                           @"order": @"last_name"
                                           }
                                 success:^(NSDictionary *dic) {
                                     NSArray *data = dic[@"resource"];
                                     NSMutableArray *array = [[NSMutableArray alloc] init];
                                     for (NSDictionary *element in data) {
                                         Contact *contact = [[Contact alloc] init];
                                         contact.ID = [element[@"contact_id"] integerValue];
                                         contact.firstName = element[@"first_name"];
                                         contact.lastName = element[@"last_name"];
                                         contact.imageUrl = element[@"image_url"];
                                         contact.twitter = element[@"twitter"];
                                         contact.notes = element[@"notes"];
                                         contact.skype = element[@"skype"];
                                         [array addObject:contact];
                                     }
                                     success(array);
                                 }
                                 failure:^(NSError *error) {
                                     if (failure) {
                                         failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                     }
                                 }];
}

+(void)addContactWith:(NSInteger)groupID
            contactID:(NSInteger)contactID
              success:(void (^)(id))success
              failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] POST:@"Contact Group Relationship"
                            GETParameters: nil
                           POSTParameters:@{
                                            @"resource": @{
                                                    @"contact_id": @(contactID),
                                                    @"contact_group_id": @(groupID)
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

+(void)deleteContectWith:(NSInteger)groupID
               contactID:(NSInteger)contactID
                 success:(void (^)(id))success
                 failure:(void (^)(NSString *))failure {
    NSString *filter = [NSString stringWithFormat:@"(contact_group_id=%ld) and (contact_id=%ld)", (long)groupID, (long)contactID];
    [[NetworkManager defaultManager] DELETE:@"Contact Group Relationship"
                                 parameters:@{
                                              @"filter": filter
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

@end
