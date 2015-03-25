//
//  TCommentFeedItem.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "TFeedItem.h"


@interface TCommentFeedItem : TFeedItem

@property (nonatomic,readonly) NSString *comment;

@end


@protocol MutableTCommentFeedItem <MutableTFeedItem>

@property (nonatomic) NSString *comment;

@end


typedef TCommentFeedItem<MutableTCommentFeedItem> MutableTCommentFeedItem;

