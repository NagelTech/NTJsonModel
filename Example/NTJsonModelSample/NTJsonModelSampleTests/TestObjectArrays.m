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
    UIColor *value = [BasicPropertiesModel convertJsonToUIColor:jsonValue];
    
    // Make sure we can convert from JSON to our object type...
    
    XCTAssert([value isEqual:model.objectArray[index]], @"Conversion from JSON failed");
    
    // Make sure we are caching values once we read them...
    
    XCTAssert(model.objectArray[index] == model.objectArray[index], @"Caching may not be working correctly");
    
}

-(void)testSet
{
    BasicPropertiesModel *model = [self createModel];

    // See if we can set values...
    
    UIColor *newColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    NSString *newColorJson = [BasicPropertiesModel convertUIColorToJson:newColor];
    const NSInteger index = 2;
    
    model.objectArray[index] = newColor;
    
    XCTAssert([newColor isEqual:model.objectArray[index]], @"Set value failed");
    XCTAssert(newColor == model.objectArray[index], @"Set Value isn't caching correctly");
    
    // Check conversion back to Json...
    
    XCTAssert([newColorJson isEqualToString:model.objectArray.jsonArray[index]], @"Conversion to JSON failed");
}


-(void)testInsert
{
    BasicPropertiesModel *model = [self createModel];
    
    UIColor *newColor = [UIColor cyanColor];
    NSString *newColorJson = [BasicPropertiesModel convertUIColorToJson:newColor];
    const NSInteger index = 2;
    NSInteger newSize = self.jsonColors.count + 1;
    
    [model.objectArray insertObject:newColor atIndex:index];
    
    XCTAssert(model.objectArray.count == newSize, @"Insert failed (size wrong)");
    
    XCTAssert([newColor isEqual:model.objectArray[index]], @"Insert failed, value not inserted");
    XCTAssert(newColor == model.objectArray[index], @"Insert failed, value not cached");
    
    XCTAssert([newColorJson isEqualToString:model.objectArray.jsonArray[index]], @"Insert failed, json incorrect");
}


-(void)testDelete
{
    BasicPropertiesModel *model = [self createModel];
    
    const NSInteger index = 2;
    NSInteger newSize = self.jsonColors.count - 1;
    NSString *newColorJson = self.jsonColors[index+1]; // these are the values we expect to find at index after the delete
    UIColor *newColor = [BasicPropertiesModel convertJsonToUIColor:newColorJson];
    
    [model.objectArray removeObjectAtIndex:index];
    
    XCTAssert(model.objectArray.count == newSize, @"Delete failed (size wrong)");
    
    XCTAssert([newColor isEqual:model.objectArray[index]], @"Delete failed, exected value not found at index");
    
    XCTAssert([newColorJson isEqualToString:model.objectArray.jsonArray[index]], @"Delete failed, json incorrect at index");
}


@end
