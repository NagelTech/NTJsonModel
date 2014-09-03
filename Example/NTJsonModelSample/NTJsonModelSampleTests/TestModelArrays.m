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



/***

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
    
    NTJsonModelArray *array = [[NTJsonModelArray alloc] initWithModelClass:[BasicPropertiesModel class] jsonArray:jsonArray];
    
    // count
    
    XCTAssert(array.count == 5, @"count failed");
    
    // get object
    
    BasicPropertiesModel *item = array[2];
    
    XCTAssert(item.intProp == 2, @"get object failed");
    XCTAssert(item == array[2], @"cache failed");
    XCTAssert(!item.isMutable, "should not be mutable");
//    XCTAssert(!array.isMutable, @"should be mutable");
    
    // mutate
    
    item.stringProp = @"Mutated";
    
    XCTAssert([item.stringProp isEqualToString:@"Mutated"], @"becomeMutable failed");
    XCTAssert(item.isMutable, @"becomeMutable failed");
//    XCTAssert(array.isMutable, @"becomeMutable failed");
    XCTAssert(item == array[2], @"becomeMutable (cache persistence) failed");

    // insert
    
    BasicPropertiesModel *newItem = [BasicPropertiesModel modelWithJson:@{@"stringProp": @"newItem"}];
    
//    [array insertObject:newItem atIndex:3];
    
    XCTAssert(array.count == 6, @"count failed after insert");
    XCTAssert(newItem.isMutable, @"newItem is not mutable");
    XCTAssert(array[3] == newItem, @"newItem is not at correct index");

    // replace
    
    BasicPropertiesModel *newItem0 = [BasicPropertiesModel modelWithJson:@{@"stringProp": @"newItem0"}];
    BasicPropertiesModel *oldItem0 = array[0];
    
    [array replaceObjectAtIndex:0 withObject:newItem0];
    
    XCTAssert(array.count == 6, @"count failed after replace");
    XCTAssert(array[0] == newItem0, @"replace failed on cache");
    XCTAssert(newItem0.isMutable, @"replace failed, new item is not mutable");
    XCTAssert(oldItem0.parentJsonContainer == nil, @"replace failed, old item still linked to parent");
    
    // delete
    
    BasicPropertiesModel *delItem = array[2];
    
    [array removeObjectAtIndex:2];
    
    XCTAssert(array.count == 5, @"remove failed, count failed");
    XCTAssert(delItem.parentJsonContainer == nil, @"remove failed, object still linked");
    XCTAssert(delItem.intProp == 2, @"remove failed, removed object has lost it's original value");
}
 
***/


@end
