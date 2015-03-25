//
//  TUser.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "TUser.h"



@implementation TUser

NTJsonMutable(MutableTUser)

NTJsonProperty(firstName)
NTJsonProperty(lastName)
NTJsonProperty(age)


-(NSString *)fullName
{
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}


-(void)setFullName:(NSString *)fullName
{
    NSArray *components = [fullName componentsSeparatedByString:@" "];
    
    MutableTUser *mutable = (id)self;
    
    mutable.firstName = (components.count >= 1) ? components[0] : nil;
    mutable.lastName = (components.count >= 2) ? components[1] : nil;
}


@end

