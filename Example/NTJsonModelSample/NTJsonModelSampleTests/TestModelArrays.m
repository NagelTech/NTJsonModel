//
//  TestModelArrays.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/25/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel+Private.h"
#import "BasicPropertiesModel.h"

#import <XCTest/XCTest.h>

@interface TestModelArrays : XCTestCase

@end


@implementation TestModelArrays

- (void)setUp
{
    [super setUp];
}


- (void)tearDown
{
    [super tearDown];
}



-(void)testStandaloneArrays
{
    NSArray *jsonArray =
    @[
      @{@"intProp": @(0)},
      @{@"intProp": @(1)},
      @{@"intProp": @(2)},
      @{@"intProp": @(3)},
      @{@"intProp": @(4)},
      ];
    
    NTJsonModelArray *array = [[NTJsonModelArray alloc] initWithModelClass:[BasicPropertiesModel class] json:jsonArray];
    
    // count
    
    XCTAssert(array.count == 5, @"count failed");
    
    // get object
    
    BasicPropertiesModel *item = array[2];
    
    XCTAssert(item.intProp == 2, @"get object failed");
    XCTAssert(item == array[2], @"cache failed");
    XCTAssert(!item.isMutable, "should not be mutable");
}


@end
