//
//  TFeedItem.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//


#import "TFeedItem.h"

#import "TCommentFeedItem.h"
#import "TStatusFeedItem.h"

TFeedItemType TFeedItemTypeComment = @"comment";
TFeedItemType TFeedItemTypeStatus = @"status";



@implementation TFeedItem


NTJsonMutable(MutableTFeedItem)

NTJsonProperty(type, enumValues=[TFeedItem types])
NTJsonProperty(user)


+(NSArray *)types
{
    return @[TFeedItemTypeComment, TFeedItemTypeStatus];
}


+(Class)modelClassForJson:(NSDictionary *)json
{
    NSString *type = json[@"type"];
    
    if ( [type isEqualToString:TFeedItemTypeComment] )
        return [TCommentFeedItem class];
    
    else if ( [type isEqualToString:TFeedItemTypeStatus] )
        return [TStatusFeedItem class];

    return self;    // unknown
}

@end

