//
//  NTJsonModelArray+Private.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/18/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModelArray.h"


@class NTJsonProp;

@interface NTJsonModelArray (Private) 

-(id)initWithModelClass:(Class)modelClass jsonArray:(NSArray *)jsonArray;
-(id)initWithProperty:(NTJsonProp *)property jsonArray:(NSArray *)jsonArray;

@end
