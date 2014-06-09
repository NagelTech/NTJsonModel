//
//  Account.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/9/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "Account.h"


@implementation Account

NTJsonProperty(id)
NTJsonProperty(service)
NTJsonProperty(username, jsonPath="user_name")

@end
