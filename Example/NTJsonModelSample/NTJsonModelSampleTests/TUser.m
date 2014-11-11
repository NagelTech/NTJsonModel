//
//  TUser.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "TUser.h"


@implementation TUser

NTJsonProperty(firstName)
NTJsonProperty(lastName)
NTJsonProperty(age)


-(NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}


@end


@implementation MutableTUser

@dynamic firstName;
@dynamic lastName;
@dynamic age;


-(void)setFullName:(NSString *)fullName
{
    NSArray *components = [fullName componentsSeparatedByString:@" "];

    self.firstName = (components.count >= 1) ? components[0] : nil;
    self.lastName = (components.count >= 2) ? components[1] : nil;
}


@end


