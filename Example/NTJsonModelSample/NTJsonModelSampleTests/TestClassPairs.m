//
//  TestClassPairs.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TUser.h"


@interface TestClassPairs : XCTestCase

@end

@implementation TestClassPairs


- (void)setUp
{
    [super setUp];
}


- (void)tearDown
{
    [super tearDown];
}


- (void)testClassPairs
{
    TUser *user = [TUser modelWithJson:@{@"firstName": @"Ethan", @"lastName": @"Nagel", @"age": @(21)}];
    
    NSAssert([user.fullName isEqualToString:@"Ethan Nagel"], @"Failed");

    user = [user mutate:^(MutableTUser *mutable) {
        mutable.age = 12;
    }];
    
    NSAssert(user.age == 12, @"Failed");
    
    MutableTUser *mutableUser = [user mutableCopy];
    
    mutableUser.firstName = @"Caleb";
    
    NSAssert([mutableUser.fullName isEqualToString:@"Caleb Nagel"], @"Failed");
    
    user = [mutableUser copy];
    
    NSAssert([user.fullName isEqualToString:@"Caleb Nagel"], @"Failed");
}


@end
