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


JsonProperty(id)
JsonProperty(firstName, jsonPath="first_name")
JsonProperty(lastName, jsonPath="last_name")
JsonProperty(age)
JsonProperty(account)
JsonProperty(accounts)

/*
 
@dynamic id;
@dynamic firstName;
@dynamic lastName;
@dynamic age;
@dynamic account;
@dynamic accounts;


+(NSArray *)jsonPropertyInfo
{
    return @[
             [NTJsonProperty stringProperty:@"id"],
             [NTJsonProperty stringProperty:@"firstName" jsonKeyPath:@"first_name"],
             [NTJsonProperty stringProperty:@"lastName" jsonKeyPath:@"last_name"],
             [NTJsonProperty intProperty:@"age"],
             [NTJsonProperty modelProperty:@"account" class:[Account class]],
             [NTJsonProperty modelArrayProperty:@"accounts" class:[Account class]],
            ];
}
 
*/


@end
