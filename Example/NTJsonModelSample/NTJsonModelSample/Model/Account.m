//
//  Account.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/9/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "Account.h"


@implementation Account

JsonProperty(id)
JsonProperty(service)
JsonProperty(username, jsonPath="user_name")

/*
@dynamic id;
@dynamic service;
@dynamic username;


+(NSArray *)jsonPropertyInfo
{
    return @[
             [NTJsonProperty stringProperty:@"id"],
             [NTJsonProperty stringProperty:@"service"],
             [NTJsonProperty stringProperty:@"username" jsonKeyPath:@"user_name"],
            ];
}
 
*/


@end
