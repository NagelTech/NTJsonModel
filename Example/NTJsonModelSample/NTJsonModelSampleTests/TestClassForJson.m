//
//  TestClassForJson.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "TFeedItem.h"  
#import "TStatusFeedItem.h"
#import "TCommentFeedItem.h"


@interface TestClassForJson : XCTestCase

@end

@implementation TestClassForJson


- (void)setUp
{
    [super setUp];
}


- (void)tearDown
{
    [super tearDown];
}


-(void)testClassForJson
{
    TFeedItem *commentFeedItem = [TFeedItem modelWithJson:@{@"type": @"comment", @"user": @{@"firstName": @"Ethan"}, @"comment": @"this is a comment"}];
    TFeedItem *statusFeedItem = [TFeedItem modelWithJson:@{@"type": @"status", @"user": @{@"firstName": @"Caleb"}, @"status": @"this is a status item"}];

    NSAssert([commentFeedItem isKindOfClass:[TCommentFeedItem class]], @"Failed");
    NSAssert([statusFeedItem isKindOfClass:[TStatusFeedItem class]], @"Failed");
    
    statusFeedItem = [statusFeedItem mutate:^(MutableTStatusFeedItem *mutable) {
        mutable.status = [mutable.status stringByAppendingString:@" (updated)"];
    }];
    
    TStatusFeedItem *s = (TStatusFeedItem *)statusFeedItem;
    
    NSAssert([s.status hasSuffix:@"(updated)"], @"Failed");
    
    TCommentFeedItem *c = [TCommentFeedItem modelWithMutationBlock:^(MutableTCommentFeedItem *mutable) {
        mutable.comment = @"Seems to be working";
    }];
    
    NSAssert(c.type == TFeedItemTypeComment, @"Failed");
}


@end
