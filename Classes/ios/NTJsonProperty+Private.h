//
//  NTJsonProperty+Private.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/18/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <objc/runtime.h>

#import "NTJsonProperty.h"

@interface NTJsonProperty (Private)

@property (nonatomic,readwrite) Class modelClass;
@property (nonatomic,readonly) id defaultValue;
@property (nonatomic,readonly) BOOL shouldCache;

// conversion

-(id)convertValueToJson:(id)object;
-(id)convertJsonToValue:(id)json;

+(instancetype)propertyWithClass:(Class)class objcProperty:(objc_property_t)objcProperty;


@end
