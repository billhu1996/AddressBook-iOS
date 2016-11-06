//
//  Contact.h
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/6.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *twitter;
@property (nonatomic, copy) NSString *skype;
@property (nonatomic, copy) NSString *notes;

+(void)fetchContact:(NSInteger)page
            success:(void (^)(id))success
            failure:(void (^)(NSString *))failure;

+(void)editContact:(NSInteger)ID
         firstName:(NSString *)firstName
          lastName:(NSString *)lastName
          imageUrl:(NSString *)imageUrl
           twitter:(NSString *)twitter
             skype:(NSString *)skype
             notes:(NSString *)notes
           success:(void (^)(id))success
           failure:(void (^)(NSString *))failure;

+(void)createNewContact:(NSString *)firstName
               lastName:(NSString *)lastName
               imageUrl:(NSString *)imageUrl
                twitter:(NSString *)twitter
                  skype:(NSString *)skype
                  notes:(NSString *)notes
                success:(void (^)(id))success
                failure:(void (^)(NSString *))failure;

@end
