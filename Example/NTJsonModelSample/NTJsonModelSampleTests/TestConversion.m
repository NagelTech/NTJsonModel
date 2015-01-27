//
//  TestConversion.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/24/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NTJsonModel+Private.h"

#import "BasicPropertiesModel.h"


@interface TestConversion : XCTestCase

@end

@implementation TestConversion


- (void)setUp
{
    [super setUp];
}


- (void)tearDown
{
    [super tearDown];
}


-(void)testClassBasedConversion
{
    // test: convert[ClassName]toJson: and convertJsonTo[ClassName]
    
    UIColor *sampleColor = [UIColor colorWithRed:153.0/255.0 green:51.0/255.0 blue:255.0/255.0 alpha:1.0];
    BasicPropertiesModel *model;
    
    model = [BasicPropertiesModel mutableModelWithJson:@{@"colorProp": @"#9933ff"}];
    XCTAssert([model.colorProp isEqual:sampleColor], @"JSON -> UIColor conversion failed");

    model.colorProp = [UIColor redColor];
    XCTAssert([[model asJson][@"colorProp"] isEqualToString:@"#FF0000"], @"UIColor -> JSON conversion failed");
}


-(void)testPropertyBasedConversion
{
    UIColor *sampleColor = [UIColor colorWithRed:0.20 green:0.40 blue:0.60 alpha:1.0];
    
    BasicPropertiesModel *model;
    
    model = [BasicPropertiesModel mutableModelWithJson:@{@"color2Prop": @{@"r": @(0.20), @"g": @(0.40), @"b": @(0.60)}}];
    XCTAssert([model.color2Prop.description isEqualToString:sampleColor.description], @"JSON -> UIColor conversion failed");
    
    model.color2Prop = [UIColor redColor];
    XCTAssert([[model asJson][@"color2Prop"][@"r"] floatValue] == 1.00, @"UIColor -> JSON conversion failed");
}


-(void)testConversionsWithValidation
{
    UIColor *red1 = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:1.0];
    UIColor *red2 = [UIColor colorWithRed:0.75 green:0 blue:0 alpha:1.0];

    BasicPropertiesModel *model = [BasicPropertiesModel modelWithJson:@{@"color3Prop": @"red"}];

    [BasicPropertiesModel setNamedColor:red1 withName:@"red"];

    XCTAssert([model.color3Prop.description isEqualToString:red1.description], @"convertJsonTo<propertyName>:existingValue: failed");

    [BasicPropertiesModel setNamedColor:red2 withName:@"red"];

    XCTAssert([model.color3Prop.description isEqualToString:red2.description], @"convertJsonTo<propertyName>:existingValue: failed");
}


@end
