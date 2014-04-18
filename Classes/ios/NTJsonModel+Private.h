//
//  NTJsonModel+Private.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel.h"

#import "NTJsonModelArray+Private.h"
#import "NTJsonProperty+Private.h"


@interface NTJsonModel (Private)

@property (nonatomic, readonly) NSMutableDictionary *mutableJson;

@end

id NTJsonModel_deepCopy(id json);
id NTJsonModel_mutableDeepCopy(id json);


