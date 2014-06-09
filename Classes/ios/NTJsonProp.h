//
//  NTJsonProp.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTJsonModel;

typedef enum
{
    NTJsonPropTypeString        = 1,
    NTJsonPropTypeInt           = 2,
    NTJsonPropTypeBool          = 3,
    NTJsonPropTypeFloat         = 4,
    NTJsonPropTypeDouble        = 5,
    NTJsonPropTypeLongLong      = 6,
    NTJsonPropTypeModel         = 7,
    NTJsonPropTypeModelArray    = 8,
    NTJsonPropTypeStringEnum    = 9,
    NTJsonPropTypeObject        = 10,   // a custom object of some kind (eg NSDate)
    NTJsonPropTypeObjectArray   = 11,   // an array of custom objects
} NTJsonPropType;


@interface NTJsonProp : NSObject

@property (nonatomic,readonly) Class modelClass;
@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSString *jsonKeyPath;
@property (nonatomic,readonly) NTJsonPropType type;
@property (nonatomic,readonly) Class typeClass;
@property (nonatomic,readonly) NSSet *enumValues;

// basic types

+(instancetype)property:(NSString *)name type:(NTJsonPropType)type jsonKeyPath:(NSString *)jsonKeyPath;

+(instancetype)stringProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)stringProperty:(NSString *)name;

+(instancetype)intProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)intProperty:(NSString *)name;

+(instancetype)boolProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)boolProperty:(NSString *)name;

+(instancetype)floatProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)floatProperty:(NSString *)name;

+(instancetype)doubleProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)doubleProperty:(NSString *)name;

+(instancetype)longLongProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)longLongProperty:(NSString *)name;

// string enum types

+(instancetype)enumProperty:(NSString *)name enumValues:(NSSet *)enumValues jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)enumProperty:(NSString *)name enumValues:(NSSet *)enumValues;

// model types

+(instancetype)modelProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)modelProperty:(NSString *)name class:(Class)class;

+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class;

// object types

+(instancetype)objectProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)objectProperty:(NSString *)name class:(Class)class;

/* Not currently supported
+(instancetype)objectArrayProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)objectArrayProperty:(NSString *)name class:(Class)class;
*/

@end
