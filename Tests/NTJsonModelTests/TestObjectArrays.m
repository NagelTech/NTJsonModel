//
//  TestObjectArrays.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 7/21/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "BasicPropertiesModel.h"


@interface TestObjectArrays : XCTestCase

@property (nonatomic,readonly) NSArray *jsonColors;

@end


@implementation TestObjectArrays


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


-(NSArray *)jsonColors
{
    return  @[@"#000000", @"#FF0000", @"#00FF00", @"#0000FF",
              @"#FFFF00", @"#00FFFF", @"#FF00FF", @"#C0C0C0",
              @"#FFFFFF"];
}


-(BasicPropertiesModel *)createModel
{
    return [BasicPropertiesModel modelWithJson:@{@"objectArray": [self jsonColors]}];
}



-(void)testConvertFromJson
{
    BasicPropertiesModel *model = [self createModel];
    
    const NSInteger index = 1;
    
    NSString *jsonValue = self.jsonColors[index];
    UIColor *value = [UIColor convertJsonToValue:jsonValue];
    
    // Make sure we can convert from JSON to our object type...
    
    XCTAssert([value isEqual:model.objectArray[index]], @"Conversion from JSON failed");
    
    // Make sure we are caching values once we read them...
    
    XCTAssert(model.objectArray[index] == model.objectArray[index], @"Caching may not be working correctly");
}


-(void)testSet
{
    BasicPropertiesModel *model = [[self createModel] mutableCopy];

    // See if we can set values...
    
    UIColor *newColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    NSString *newColorJson = [UIColor convertValueToJson:newColor];
    const NSInteger index = 2;
    
    NSMutableArray *mutableObjectArray = [model.objectArray mutableCopy];
    mutableObjectArray[index] = newColor;
    
    model.objectArray = mutableObjectArray;
    
    XCTAssert([newColor isEqual:model.objectArray[index]], @"Set value failed");
    XCTAssert(newColor == model.objectArray[index], @"Set Value isn't caching correctly");
    
    // Check conversion back to Json...

    NSArray *jsonArray = [model asJson][@"objectArray"];
    
    XCTAssert([newColorJson isEqualToString:jsonArray[index]], @"Conversion to JSON failed");
}


-(void)testArrayMutableCopy
{
    BasicPropertiesModel *model = [self createModel];
    
    NSMutableArray *mutable = [model.objectArray mutableCopy];
    
    // First let's compare the objects...
    
    XCTAssertTrue([mutable isEqualToArray:model.objectArray], @"mutableCopy objects differ");
    
    // Now let's check the underlying json...
    
    XCTAssertTrue([[mutable asJson] isEqual:[model.objectArray asJson]], @"asJson of mutableCopy differs");
}


@end
