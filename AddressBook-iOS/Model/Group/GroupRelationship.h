//
//  GroupRelationship.h
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/6.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupRelationship : NSObject

+(void)fetchContactWith:(NSInteger)groupID
                   page:(NSInteger)page
                success:(void (^)(id))success
                failure:(void (^)(NSString *))failure;

+(void)addContactWith:(NSInteger)groupID
            contactID:(NSInteger)contactID
              success:(void (^)(id))success
              failure:(void (^)(NSString *))failure;

+(void)deleteContectWith:(NSInteger)groupID
               contactID:(NSInteger)contactID
                 success:(void (^)(id))success
                 failure:(void (^)(NSString *))failure;

@end
