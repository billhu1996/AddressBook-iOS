//
//  Contact.m
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/6.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

#import "Contact.h"
#import "NetworkManager.h"

@implementation Contact

+(void)fetchContact:(NSInteger)page
            success:(void (^)(id))success
            failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] GET:@"Contact"
                              parameters:@{
                                           @"limit": @20,
                                           @"offset": @(page)
                                           }
                                 success:^(NSDictionary *dic) {
                                     NSArray *data = dic[@"resource"];
                                     NSMutableArray *array = [[NSMutableArray alloc] init];
                                     for (NSDictionary *element in data) {
                                         Contact *contact = [[Contact alloc] init];
                                         contact.ID = [element[@"id"] integerValue];
                                         contact.firstName = element[@"first_name"];
                                         contact.lastName = element[@"last_name"];
                                         contact.imageUrl = element[@"image_url"];
                                         contact.twitter = element[@"twitter"];
                                         contact.skype = element[@"skype"];
                                         contact.notes = element[@"notes"];
                                         [array addObject:contact];
                                     }
                                     success(array);
                                 }
                                 failure:^(NSError *error) {
                                     failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                 }];
}

+(void)editContact:(NSInteger)ID
         firstName:(NSString *)firstName
          lastName:(NSString *)lastName
          imageUrl:(NSString *)imageUrl
           twitter:(NSString *)twitter
             skype:(NSString *)skype
             notes:(NSString *)notes
           success:(void (^)(id))success
           failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] PUT:@"Contact"
                              parameters:@{
                                           @"resource": @{
                                                   @"id": @(ID),
                                                   @"first_name": firstName,
                                                   @"last_name": lastName,
                                                   @"image_url": imageUrl,
                                                   @"twitter": twitter,
                                                   @"skype": skype,
                                                   @"notes": notes
                                                   }
                                           }
                                 success:^(NSDictionary *data) {
                                     success(data[@"resource"][0][@"id"]);
                                 }
                                 failure:^(NSError *error) {
                                     failure(error.userInfo[NSLocalizedFailureReasonErrorKey]);
                                 }];
}
+(void)createNewContact:(NSString *)firstName
               lastName:(NSString *)lastName
               imageUrl:(NSString *)imageUrl
                twitter:(NSString *)twitter
                  skype:(NSString *)skype
                  notes:(NSString *)notes
                success:(void (^)(id))success
                failure:(void (^)(NSString *))failure {
    [[NetworkManager defaultManager] POST:@"Contact"
                            GETParameters: nil
                           POSTParameters:@{
                                            @"resource": @{
                                                    @"first_name": firstName,
                                                    @"last_name": lastName,
                                                    @"image_url": imageUrl,
                                                    @"twitter": twitter,
                                                    @"skype": skype,
                                                    @"notes": notes
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
