//
//  User.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "User.h"
#import "Account.h"

@implementation User


@dynamic id;
@dynamic firstName;
@dynamic lastName;
@dynamic age;
@dynamic account;
@dynamic accounts;


+(NSArray *)propertyInfo
{
    return [[super propertyInfo] arrayByAddingObjectsFromArray:@
            [
             [NTJsonProperty stringProperty:@"id"],
             [NTJsonProperty stringProperty:@"firstName" jsonKeyPath:@"first_name"],
             [NTJsonProperty stringProperty:@"lastName" jsonKeyPath:@"last_name"],
             [NTJsonProperty intProperty:@"age"],
             [NTJsonProperty modelProperty:@"account" class:[Account class]],
             [NTJsonProperty modelArrayProperty:@"accounts" class:[Account class]],
            ]];
}


@end