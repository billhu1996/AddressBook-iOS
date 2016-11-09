//
//  Group.h
//  AddressBook-iOS
//
//  Created by Bill Hu on 16/11/6.
//  Copyright © 2016年 Bill Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Group : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic, copy) NSString *name;

+(void)fetchGroup:(NSInteger)page
          success:(void (^)(id))success
          failure:(void (^)(NSString *))failure;

+(void)editGroup:(NSInteger)ID
            name:(NSString *)name
         success:(void (^)(id))success
         failure:(void (^)(NSString *))failure;

+(void)createNewGroup:(NSString *)name
              success:(void (^)(id))success
              failure:(void (^)(NSString *))failure;

+(void)deleteGroup:(NSInteger)ID
           success:(void (^)(id))success
           failure:(void (^)(NSString *))failure;

@end
