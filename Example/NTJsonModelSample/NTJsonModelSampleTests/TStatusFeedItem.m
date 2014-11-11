//
//  TStatusFeedItem.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "TStatusFeedItem.h"


@implementation TStatusFeedItem

NTJsonProperty(status)

@end


@implementation MutableTStatusFeedItem

@dynamic status;


-(id)init
{
    if ( (self = [super init]) )
    {
        self.type = TFeedItemTypeStatus;
    }
    
    return self;
}

@end

