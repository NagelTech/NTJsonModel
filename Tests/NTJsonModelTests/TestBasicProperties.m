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
    BasicPropertiesModel *model;
    BasicPropertiesModel *mutable;
    
    // Test default value
    
    model = [[BasicPropertiesModel alloc] init];
    XCTAssertTrue(model.intProp == 0, @"intProp default value failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.intProp = 0;
    XCTAssertTrue(mutable.intProp == 0, @"intProp mutableCopy default value failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // Test int no conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"intProp": @(42)}];
    XCTAssertTrue((model.intProp == 42), @"intProp identity failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    XCTAssertTrue(mutable.intProp == 42, @"intProp mutableCopy identity failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // test int from float
    
    model = [BasicPropertiesModel modelWithJson:@{@"intProp": @(42.0f)}];
    XCTAssertTrue((model.intProp == 42), @"intProp from float conversion failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.intProp = 42;
    XCTAssertTrue(mutable.intProp == 42, @"intProp mutableCopy identity failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // test string conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"intProp": @"42"}];
    XCTAssertTrue((model.intProp == 42), @"intProp from string conversion failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.intProp = 42;
    XCTAssertTrue(mutable.intProp == 42, @"intProp mutableCopy identity failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
}


-(void)testFloat
{
    BasicPropertiesModel *model;
    BasicPropertiesModel *mutable;
    
    // Test default value
    
    model = [[BasicPropertiesModel alloc] init];
    XCTAssertTrue(model.floatProp == 0.0f, @"floatProp default value failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.floatProp = 0;
    XCTAssertTrue(mutable.floatProp == 0.0f, @"floatProp mutableCopy default value failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // Test int no conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"floatProp": @(4.2f)}];
    XCTAssertTrue((model.floatProp == 4.2f), @"floatProp identity failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    XCTAssertTrue(mutable.floatProp == 4.2f, @"floatProp mutableCopy identity failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // test float from int
    
    model = [BasicPropertiesModel modelWithJson:@{@"floatProp": @(4)}];
    XCTAssertTrue((model.floatProp == 4), @"floatProp from float conversion failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.floatProp = 4;
    XCTAssertTrue(mutable.floatProp == 4, @"floatProp mutableCopy identity failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // test string conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"floatProp": @"4.2"}];
    XCTAssertTrue((model.floatProp == 4.2f), @"floatProp from string conversion failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.floatProp = 4.2f;
    XCTAssertTrue(mutable.floatProp == 4.2f, @"floatProp mutableCopy identity failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
}


-(void)testDouble
{
    BasicPropertiesModel *model;
    BasicPropertiesModel *mutable;
    
    // test default value
    
    model = [[BasicPropertiesModel alloc] init];
    XCTAssertTrue(model.doubleProp == 0.0, @"doubleProp default value failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.doubleProp = 0;
    XCTAssertTrue(mutable.doubleProp == 0.0, @"doubleProp mutableCopy default value failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // Test int no conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"doubleProp": @(4.2)}];
    XCTAssertTrue((model.doubleProp == 4.2), @"doubleProp identity failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.doubleProp = 4.2;
    XCTAssertTrue(mutable.doubleProp == 4.2, @"doubleProp mutableCopy identity failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // test double from float
    
    model = [BasicPropertiesModel modelWithJson:@{@"doubleProp": @(421.0f)}];
    XCTAssertTrue((model.doubleProp == 421), @"doubleProp from float conversion failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.doubleProp = 421;
    XCTAssertTrue(mutable.doubleProp == 421, @"doubleProp mutableCopy int conversion failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // test double from int
    
    model = [BasicPropertiesModel modelWithJson:@{@"doubleProp": @(4)}];
    XCTAssertTrue((model.doubleProp == 4), @"doubleProp from float conversion failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.doubleProp = 4;
    XCTAssertTrue(mutable.doubleProp == 4, @"doubleProp mutableCopy int conversion failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    
    // test string conversion
    
    model = [BasicPropertiesModel modelWithJson:@{@"doubleProp": @"4.2"}];
    XCTAssertTrue((model.doubleProp == 4.2), @"doubleProp from string conversion failed");
    mutable = [model mutableCopy];
    XCTAssertTrue(mutable.isMutable, @"mutableCopy not isMutable");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
    mutable.doubleProp = 4.2;
    XCTAssertTrue(mutable.doubleProp == 4.2, @"doubleProp mutableCopy int conversion failed");
    XCTAssertTrue([model isEqual:mutable], @"mutableCopy != original");
}


-(void)testString
{
    // todo
}


-(void)testBool
{
    // todo
}


-(void)testLongLong
{
    // todo
}


@end
