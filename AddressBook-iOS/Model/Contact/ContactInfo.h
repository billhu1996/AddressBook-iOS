//
//  ContactInfo.h
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/6.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInfo : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSInteger ordinal;
@property (nonatomic) NSInteger contact_id;
@property (nonatomic, copy) NSString *infoType;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *country;

+(void)fetchContactInfo:(NSInteger)page
                success:(void (^)(id))success
                failure:(void (^)(NSString *))failure;

+(void)fetchContactInfoWithID:(NSInteger)ID
                      success:(void (^)(id))success
                      failure:(void (^)(NSString *))failure;

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
               failure:(void (^)(NSString *))failure;

+(void)createNewContactInfo:(NSInteger)contactID
                   infoType:(NSString *)infoType
                      phone:(NSString *)phone
                      email:(NSString *)email
                    address:(NSString *)address
                       city:(NSString *)city
                      state:(NSString *)state
                        zip:(NSString *)zip
                    country:(NSString *)country
                    success:(void (^)(id))success
                    failure:(void (^)(NSString *))failure;

@end
