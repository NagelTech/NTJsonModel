//
//  TestDefaultJson.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 5/1/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <XCTest/XCTest.h>


#import "BasicPropertiesModel.h"

@interface TestDefaultJson : XCTestCase

@end


@implementation TestDefaultJson


- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}


- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testDefaultJson
{
    NSDictionary *defaultJson = [BasicPropertiesModel defaultJson];
    
    NSDictionary *expectedDefaultJson =
    @{
      @"intProp": @(0),
      @"floatProp": @(0.0f),
      @"doubleProp": @(0.0),
      @"boolProp": @(NO),
      @"nested":
          @{
              @"value": @(0),
            },
      };
    
    XCTAssert([defaultJson isEqualToDictionary:expectedDefaultJson], @"defaultJson does not match expected default json");
}


@end
