//
//  TestBasicProperties.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/24/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BasicPropertiesModel.h"


@interface TestBasicProperties : XCTestCase

@end



@implementation TestBasicProperties


-(void)setUp
{
    [super setUp];
}


-(void)tearDown
{
    [super tearDown];
}


-(void)testInt
{
    BasicPropertiesModel *model = [[BasicPropertiesModel alloc] init];
    
    XCTAssertTrue((model.intProp == 0), @"intProp default value failed");

    // Test int no conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"intProp": @(42)}];
    XCTAssertTrue((model.intProp == 42), @"intProp identity failed");

    // test int from float
    
    model = [BasicPropertiesModel modelWithJson:@{@"intProp": @(42.0)}];
    XCTAssertTrue((model.intProp == 42), @"intProp from float conversion failed");
    
    model = [BasicPropertiesModel modelWithJson:@{@"intProp": @"42"}];
    XCTAssertTrue((model.intProp == 42), @"intProp from string conversion failed");
}


-(void)testFloat
{
    BasicPropertiesModel *model = [[BasicPropertiesModel alloc] init];
    
    XCTAssertTrue((model.floatProp == 0.0f), @"floatProp default value failed");
    
    // Test int no conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"floatProp": @(4.2f)}];
    XCTAssertTrue((model.floatProp == 4.2f), @"floatProp identity failed");
    
    // test float from int
    
    model = [BasicPropertiesModel modelWithJson:@{@"floatProp": @(4)}];
    XCTAssertTrue((model.floatProp == 4), @"floatProp from float conversion failed");
    
    // test string conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"floatProp": @"4.2"}];
    XCTAssertTrue((model.floatProp == 4.2f), @"floatProp from string conversion failed");
}


-(void)testDouble
{
    BasicPropertiesModel *model = [[BasicPropertiesModel alloc] init];
    
    XCTAssertTrue((model.doubleProp == 0.0), @"doubleProp default value failed");
    
    // Test int no conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"doubleProp": @(4.2)}];
    XCTAssertTrue((model.doubleProp == 4.2), @"doubleProp identity failed");
    
    // test float from int
    
    model = [BasicPropertiesModel modelWithJson:@{@"doubleProp": @(4)}];
    XCTAssertTrue((model.doubleProp == 4), @"doubleProp from float conversion failed");
    
    // test string conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"doubleProp": @"4.2"}];
    XCTAssertTrue((model.doubleProp == 4.2), @"doubleProp from string conversion failed");
}


-(void)testString
{
    BasicPropertiesModel *model = [[BasicPropertiesModel alloc] init];
    
    XCTAssertTrue((model.stringProp == nil), @"stringProp default value failed");
    
    // Test double conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"stringProp": @(4.2)}];
    XCTAssertTrue([model.stringProp isEqualToString:@"4.2"], @"stringProp identity failed");
    
    // test int conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"stringProp": @(4)}];
    XCTAssertTrue([model.stringProp isEqualToString:@"4"], @"stringProp from float conversion failed");
    
    // test string conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"stringProp": @(YES)}];
    XCTAssertTrue([model.stringProp isEqualToString:@"1"], @"stringProp from string conversion failed");
}


-(void)testBool
{
    BasicPropertiesModel *model = [[BasicPropertiesModel alloc] init];
    
    XCTAssertTrue((model.boolProp == NO), @"boolProp default value failed");
    
    // Test int no conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"boolProp": @(1.0f)}];
    XCTAssertTrue((model.boolProp == YES), @"boolProp identity failed");
    
    // test float from int
    
    model = [BasicPropertiesModel modelWithJson:@{@"boolProp": @(1)}];
    XCTAssertTrue((model.boolProp == YES), @"boolProp from float conversion failed");
    
    // test string conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"boolProp": @"true"}];
    XCTAssertTrue((model.boolProp == YES), @"boolProp from string conversion failed");
}


@end
