//
//  NTJsonProperty.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <Foundation/Foundation.h>


#define NTJsonString(name, jsonName) @dynamic name; +(NTJsonProperty *)name##__property { return [NTJsonProperty property:@#name jsonKeyPath:@#jsonName type:NTJsonPropertyTypeString]; }

#define NSJsonString(name) NTJsonString(name,name)


typedef enum
{
    NTJsonPropertyTypeString        = 1,
    NTJsonPropertyTypeInt           = 2,
    
    NTJsonPropertyTypeBool          = 3,
    NTJsonPropertyTypeFloat         = 4,
    NTJsonPropertyTypeDouble        = 5,
    NTJsonPropertyTypeLongLong      = 6,
    
    NTJsonPropertyTypeModel         = 8,
    NTJsonPropertyTypeModelArray    = 9,
    
    NTJsonPropertyTypeStringEnum    = 10,
    
    NTJsonPropertyTypeObject        = 11,   // a custom object of somekind
} NTJsonPropertyType;


@interface NTJsonProperty : NSObject

@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSString *jsonKeyPath;
@property (nonatomic,readonly) NTJsonPropertyType type;
@property (nonatomic,readonly) Class typeClass;
@property (nonatomic,readonly) NSSet *enumValues;
@property (nonatomic,readonly) id defaultValue;

@property (nonatomic,readonly) BOOL shouldCache;

+(instancetype)property:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath type:(NTJsonPropertyType)type;

+(instancetype)stringProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)stringProperty:(NSString *)name;

+(instancetype)intProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)intProperty:(NSString *)name;

+(instancetype)modelProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)modelProperty:(NSString *)name class:(Class)class;

+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath;
+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class;

@end
