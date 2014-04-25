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
    
    model = [BasicPropertiesModel modelWithJson:@{@"colorProp": @"#9933ff"}];
    XCTAssert([model.colorProp isEqual:sampleColor], @"JSON -> UIColor conversion failed");
    
    model.colorProp = [UIColor redColor];
    XCTAssert([model.json[@"colorProp"] isEqualToString:@"#FF0000"], @"UIColor -> JSON conversion failed");
}


-(void)testPropertyBasedConversion
{
    UIColor *sampleColor = [UIColor colorWithRed:0.20 green:0.40 blue:0.60 alpha:1.0];
    
    BasicPropertiesModel *model;
    
    model = [BasicPropertiesModel modelWithJson:@{@"color2Prop": @{@"r": @(0.20), @"g": @(0.40), @"b": @(0.60)}}];
    XCTAssert([model.color2Prop isEqual:sampleColor], @"JSON -> UIColor conversion failed");
    
    model.color2Prop = [UIColor redColor];
    XCTAssert([model.json[@"color2Prop"][@"r"] floatValue] == 1.00, @"UIColor -> JSON conversion failed");
}


@end
