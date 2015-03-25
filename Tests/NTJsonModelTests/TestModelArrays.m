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
      @{@"intProp": @(0), @"randomData": @"whatever"},
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
    
    // Mutate - we should get the same Json, including unmaped "randomData"
    
    NSMutableArray *mutableArray = [array mutableCopy];
    
    XCTAssertTrue([[array asJson] isEqual:[mutableArray asJson]], @"mutableCopy json doesn't match");
    
    // Make a change and see validate that it is in the resulting json...
    
    item = mutableArray[0];
    
    XCTAssertTrue(!item.isMutable, @"mutableCopy array's contents are mutable");
    
    item = [item mutableCopy];
    item.intProp = 100;
    
    mutableArray[0] = item;
    
    NSArray *newJsonArray = [mutableArray asJson];
    
    XCTAssertTrue([[newJsonArray[0] valueForKey:@"intProp"] isEqual:@(100)], @"change to mutable array element not reflected in asJson result");
    
    
}


@end
