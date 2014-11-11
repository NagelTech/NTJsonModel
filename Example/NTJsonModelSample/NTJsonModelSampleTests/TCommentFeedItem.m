//
//  TCommentFeedItem.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "TCommentFeedItem.h"


@implementation TCommentFeedItem

NTJsonMutable(MutableTCommentFeedItem)

NTJsonProperty(comment)


-(id)initMutable
{
    if ( (self = [super initMutable]) )
    {
        MutableTCommentFeedItem *mutable = (id)self;
        
        mutable.type = TFeedItemTypeComment;
    }
    
    return self;
}


@end

