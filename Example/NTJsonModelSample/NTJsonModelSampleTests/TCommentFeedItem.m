//
//  TCommentFeedItem.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "TCommentFeedItem.h"


@implementation TCommentFeedItem

NTJsonProperty(comment)

@end


@implementation MutableTCommentFeedItem

@dynamic comment;


-(id)init
{
    if ( (self = [super init]) )
    {
        self.type = TFeedItemTypeComment;
    }
    
    return self;
}


@end

