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


/*
-(void)testMutableCaching
{
    BasicPropertiesModel *model;
    BasicPropertiesModel *child;
    
    model = [BasicPropertiesModel modelWithJson:@{@"stringProp": @"parent", @"childModel": @{@"stringProp": @"child"}}];
    
    XCTAssert([model.stringProp isEqualToString:@"parent"], @"cannot resolve parent property");
    
    child = model.childModel;
    XCTAssert([child.stringProp isEqualToString:@"child"], @"cannot resolve child property");
    
    XCTAssert(child == model.childModel, @"immutable caching fail");
    
    child.intProp = 2;
    
    XCTAssert(child.isMutable, @"becomeMutable fail");
    XCTAssert(model.isMutable, @"becomeMutable fail (recursion to parent)");

    XCTAssert(child.intProp == 2, @"failed to set child property (becomeMutable fail?)");
    
    XCTAssert(child == model.childModel, @"cache fail after becomeMutable");
    
    // set new child
    
    BasicPropertiesModel *newChild = [BasicPropertiesModel modelWithJson:@{@"stringProp": @"newChild"}];
    
    model.childModel = newChild;
    
    XCTAssert(model.childModel == newChild, @"set child model to new value failed");
    
    XCTAssert([model.childModel.stringProp isEqualToString:@"newChild"], @"get newCHild properry value failed");
    
    XCTAssert(newChild.isMutable, @"newChild is not mutable");
    
    // original child is now an orphan, hopefully...
    
    child.stringProp = @"orphan";
    
    XCTAssert([child.stringProp isEqualToString:@"orphan"], @"set orphan property fail");
    
    // set child to nil...
    
    model.childModel = nil;
    
    XCTAssert(model.childModel == nil, @"set child model to nil failed");
    
    newChild.stringProp = @"orphan2";
    
    XCTAssert([newChild.stringProp isEqualToString:@"orphan2"], @"set orphan property fail (setting prop to nil)");
    
    // Test atempt to assign object from one model to another...
    
    BasicPropertiesModel *model2 = [BasicPropertiesModel modelWithJson:@{@"stringProp": @"model2", @"childModel": @{@"stringProp": @"model2child"}}];
    
    XCTAssertThrows(model.childModel = model2.childModel, @"should throw exception when assigning model between models.");
}
 
*/


@end
