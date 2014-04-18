//
//  NTJsonProperty.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NTJsonModel;

typedef enum
{
    NTJsonPropertyTypeString        = 1,
    NTJsonPropertyTypeInt           = 2,
    NTJsonPropertyTypeBool          = 3,
    NTJsonPropertyTypeFloat         = 4,
    NTJsonPropertyTypeDouble        = 5,
    NTJsonPropertyTypeLongLong      = 6,
    NTJsonPropertyTypeModel         = 7,
    NTJsonPropertyTypeModelArray    = 8,
    NTJsonPropertyTypeStringEnum    = 9,
    NTJsonPropertyTypeObject        = 10,   // a custom object of some kind (eg NSDate)
    NTJsonPropertyTypeObjectArray   = 11,   // an array of custom objects
} NTJsonPropertyType;


@interface NTJsonProperty : NSObject

@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSString *jsonKeyPath;
@property (nonatomic,readonly) NTJsonPropertyType type;
@property (nonatomic,readonly) Class typeClass;
@property (nonatomic,readonly) NSSet *enumValues;
@property (nonatomic,readonly) id defaultValue;

@property (nonatomic,readonly) BOOL shouldCache;

// basic types

+(instancetype)property:(NSString *)name type:(NTJsonPropertyType)type jsonKeyPath:(NSString *)jsonKeyPath;

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

+(instancetype)objectArrayProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)objectArrayProperty:(NSString *)name class:(Class)class;

// conversion

-(id)convertValueToJson:(id)object inModel:(NTJsonModel *)model;
-(id)convertJsonToValue:(id)json inModel:(NTJsonModel *)model;

@end
