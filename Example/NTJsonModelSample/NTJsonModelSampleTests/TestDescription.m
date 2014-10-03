//
//  TestDescription.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 9/13/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "BasicPropertiesModel.h"


@interface TestDescription : XCTestCase

@end


@implementation TestDescription


- (void)setUp
{
    [super setUp];
}


- (void)tearDown
{
    [super tearDown];
}


- (void)testDescription
{
    BasicPropertiesModel *model;
    
    model = [BasicPropertiesModel modelWithJson:@{@"stringProp": @"parent", @"childModel": @{@"stringProp": @"child"}}];
    
    // test description with a child model...
    
    NSString *description = model.description;
    NSString *expectedDescription = @"BasicPropertiesModel(stringProp=\"parent\", childModel=BasicPropertiesModel(...))";
    
    XCTAssertTrue([description isEqualToString:expectedDescription], @"description does not match");
    
    // Test fullDescription...

    NSString *fullDescription = model.fullDescription;
    NSString *expectedFullDescription = @"BasicPropertiesModel(intProp=0, floatProp=0, doubleProp=0, stringProp=\"parent\", boolProp=NO, colorProp=nil, color2Prop=nil, childModel=BasicPropertiesModel(intProp=0, floatProp=0, doubleProp=0, stringProp=\"child\", boolProp=NO, colorProp=nil, color2Prop=nil, childModel=nil, modelArray=nil, objectArray=nil, objectArrayStrings=nil, nestedValue=0), modelArray=nil, objectArray=nil, objectArrayStrings=nil, nestedValue=0)";
    
    XCTAssertTrue([fullDescription isEqualToString:expectedFullDescription], @"fullDescription does not match");

}


@end
