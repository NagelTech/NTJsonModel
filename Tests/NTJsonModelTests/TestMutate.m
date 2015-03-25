//
//  TestMutate.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TUser.h"


@interface TestMutate : XCTestCase

@end


@implementation TestMutate

- (void)testMutate
{
    TUser *user = [TUser modelWithJson:@{@"firstName": @"Ethan", @"lastName": @"Nagel"}];
    
    user = [user mutate:^(MutableTUser *mutable) {
        mutable.firstName = @"Caleb";
    }];
    
    NSAssert([user.fullName isEqualToString:@"Caleb Nagel"], @"Failed");
}

@end
