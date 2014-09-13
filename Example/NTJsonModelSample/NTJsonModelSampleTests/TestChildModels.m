//
//  TestChildModels.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/25/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NTJsonModel+Private.h"
#import "BasicPropertiesModel.h"


@interface TestChildModels : XCTestCase

@end


@implementation TestChildModels


- (void)setUp
{
    [super setUp];
}


- (void)tearDown
{
    [super tearDown];
}



-(void)testMutableCaching
{
    BasicPropertiesModel *model;
    BasicPropertiesModel *child;
    
    model = [BasicPropertiesModel modelWithJson:@{@"stringProp": @"parent", @"childModel": @{@"stringProp": @"child"}}];
    
    XCTAssert([model.stringProp isEqualToString:@"parent"], @"cannot resolve parent property");
    
    child = model.childModel;
    XCTAssert([child.stringProp isEqualToString:@"child"], @"cannot resolve child property");
    
    XCTAssert(child == model.childModel, @"immutable caching fail");
    
    XCTAssertThrows(child.intProp = 2, @"Exception expected when setting immutable property");
    
    BasicPropertiesModel *mutableModel = [model mutableCopy];
    
    XCTAssertTrue([mutableModel isEqual:model], @"mutableCopy != to original");
    
    mutableModel.intProp = 2;

    XCTAssert(mutableModel.intProp == 2, @"failed to set property (mutableCopy fail?)");
    
    // set new child
    
    BasicPropertiesModel *newChild = [BasicPropertiesModel mutableModelWithJson:@{@"stringProp": @"newChild"}];
    
    mutableModel.childModel = newChild;
    
    XCTAssert([mutableModel.childModel isEqual:newChild], @"set child model to new value failed");
    
    XCTAssert([mutableModel.childModel.stringProp isEqualToString:@"newChild"], @"get newChild property value failed");
    
    // set child to nil...
    
    mutableModel.childModel = nil;
    
    XCTAssert(mutableModel.childModel == nil, @"set child model to nil failed");
}



@end
