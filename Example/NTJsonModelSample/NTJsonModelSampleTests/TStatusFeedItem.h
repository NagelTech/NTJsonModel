//
//  TStatusFeedItem.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "TFeedItem.h"


@interface TStatusFeedItem : TFeedItem

@property (nonatomic,readonly) NSString *status;

@end


@protocol MutableTStatusFeedItem <MutableTFeedItem>

@property (nonatomic) NSString *status;

@end


@interface MutableTStatusFeedItem : TStatusFeedItem <MutableTStatusFeedItem>

-(id)init;

@end