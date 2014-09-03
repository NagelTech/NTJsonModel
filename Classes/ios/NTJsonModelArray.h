//
//  NTJsonModelArray.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/9/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NTJsonModel;

@interface NTJsonModelArray : NSArray <NSCopying, NSMutableCopying>

@property (nonatomic, readonly) Class modelClass;
@property (nonatomic, readonly) NSArray *jsonArray;

-(id)copyWithZone:(NSZone *)zone;
-(id)mutableCopyWithZone:(NSZone *)zone;

@end
