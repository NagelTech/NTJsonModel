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


NTJsonProperty(id)
NTJsonProperty(firstName, jsonPath="first_name")
NTJsonProperty(lastName, jsonPath="last_name")
NTJsonProperty(age)
NTJsonProperty(account)
NTJsonProperty(accounts)


@end
