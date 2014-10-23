//
//  NTJsonModel.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSArray+NTJsonModel.h"
#import "NSDictionary+NTJsonModel.h"

#import "NTJsonPropertyConversion.h"

#import "NTJsonPropertyInfo.h"


@interface NTJsonModel : NSObject <NSCopying, NSMutableCopying>

/**
 *  returns YES if this is a mutable instance
 */
@property (nonatomic,readonly) BOOL isMutable;


/**
 *  returns the default JSON for this object.
 *
 *  @return NSDictionary with the default JSON for this object.
 */
+(NSDictionary *)defaultJson;


/**
 *  returns the JSON representation of the object
 *
 *  @return NSDictionary with the JSON representation of the object.
 */
-(NSDictionary *)asJson;

+(Class)modelClassForJson:(NSDictionary *)json;
+(BOOL)modelClassForJsonOverridden;

/**
 *  returns a default mutable instance.
 */
-(id)init; // creates mutable instance


/**
 *  returns an immutable object with the supplied JSON
 *
 *  @param json the JSON
 *
 *  @return a new immutable model instance
 */
-(id)initWithJson:(NSDictionary *)json;

/**
 *  returns an mutable object with the supplied JSON
 *
 *  @param json the JSON
 *
 *  @return a new mutable model instance
 */
-(id)initMutableWithJson:(NSDictionary *)json;

/**
 *  returns an immutable object with the supplied JSON or nil if json is nil
 *
 *  @param json the JSON
 *
 *  @return a new immutable model instance or nil
 */
+(instancetype)modelWithJson:(NSDictionary *)json;

/**
 *  returns an mutable object with the supplied JSON or nil if json is nil
 *
 *  @param json the JSON
 *
 *  @return a new mutable model instance or nil
 */
+(instancetype)mutableModelWithJson:(NSDictionary *)json;

/**
 *  returns an array of immutable Model objects with the supplied type. Objects are created lazily as they are accessed.
 *
 *  @param jsonArray the JSON array
 *
 *  @return an array of Model objects.
 */
+(NSArray *)arrayWithJsonArray:(NSArray *)jsonArray;

/**
 *  returns an array of mutable Model objects with the supplied type. Objects are created lazily as they are accessed.
 *
 *  @param jsonArray the JSON array
 *
 *  @return a mutable array of mutable Model objects.
 */
+(NSMutableArray *)mutableArrayWithJsonArray:(NSArray *)jsonArray;

-(id)copyWithZone:(NSZone *)zone;
-(id)mutableCopyWithZone:(NSZone *)zone;

-(BOOL)isEqualToModel:(NTJsonModel *)model;
-(BOOL)isEqual:(id)object;
-(NSUInteger)hash;

-(NSString *)description;

/**
 *  returns a detailed description of the object
 *
 *  @return a detailed description of the object
 */
-(NSString *)fullDescription;

@end
