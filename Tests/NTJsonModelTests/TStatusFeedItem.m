//
//  TStatusFeedItem.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "TStatusFeedItem.h"



@implementation TStatusFeedItem

NTJsonMutable(MutableTStatusFeedItem)
NTJsonProperty(status)


-(id)initMutable
{
    if ( (self = [super initMutable]) )
    {
        MutableTStatusFeedItem *mutable = (id)self;
        
        mutable.type = TFeedItemTypeStatus;
    }
    
    return self;
}

@end

