//
//  Account.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/9/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "Account.h"


@implementation Account

@dynamic id;
@dynamic service;
@dynamic username;

+(NSArray *)propertyInfo
{
    return [[super propertyInfo] arrayByAddingObjectsFromArray:@
            [
             [NTJsonProperty stringProperty:@"id"],
             [NTJsonProperty stringProperty:@"service"],
             [NTJsonProperty stringProperty:@"username" jsonKeyPath:@"user_name"],
            ]];
}


@end
