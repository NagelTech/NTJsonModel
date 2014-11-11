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


@protocol TFeedItem <NSObject>

@property (nonatomic,readonly) TFeedItemType type;
@property (nonatomic,readonly) TUser *user;

@end


@interface TFeedItem : NTJsonModel<TFeedItem>

+(NSArray *)types;

@end


@interface MutableTFeedItem : TFeedItem

@property (nonatomic,readonly) TFeedItemType type;
@property (nonatomic,readonly) TUser *user;

@end