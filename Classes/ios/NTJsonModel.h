//
//  NTJsonModel.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NTJsonProperty.h"
#import "NTJsonModelArray.h"


@interface NTJsonModel : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic,readonly) NSDictionary *json;
@property (nonatomic, readonly) NSMutableDictionary *mutableJson;       // private
@property (nonatomic,readonly) BOOL isMutable;

-(id)init; // creates mutable instance
-(id)initWithJson:(NSDictionary *)json;
-(id)initWithMutableJson:(NSMutableDictionary *)mutableJson;
+(instancetype)modelWithJson:(NSDictionary *)json;
+(instancetype)modelWithMutableJson:(NSMutableDictionary *)mutableJson;

+(NSArray *)propertyInfo;

-(id)copyWithZone:(NSZone *)zone;
-(id)mutableCopyWithZone:(NSZone *)zone;

@end

id NTJsonModel_deepCopy(id json);
id NTJsonModel_mutableDeepCopy(id json);
