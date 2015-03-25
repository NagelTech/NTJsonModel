//
//  TFeedItem.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel.h"

@class TUser;


typedef NSString *TFeedItemType;

extern TFeedItemType TFeedItemTypeComment;
extern TFeedItemType TFeedItemTypeStatus;


@interface TFeedItem : NTJsonModel

@property (nonatomic,readonly) TFeedItemType type;
@property (nonatomic,readonly) TUser *user;

+(NSArray *)types;

@end


@protocol MutableTFeedItem <NTJsonMutableModel>

@property (nonatomic) TFeedItemType type;
@property (nonatomic) TUser *user;

@end


typedef TFeedItem<MutableTFeedItem> MutableTFeedItem;
