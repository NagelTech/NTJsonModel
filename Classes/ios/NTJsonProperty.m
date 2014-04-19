//
//  NTJsonProperty.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel+Private.h"


@interface NTJsonProperty ()
{
    id _defaultValue;
}

@end


@implementation NTJsonProperty


#pragma mark - Internal initializers


+(instancetype)property:(NSString *)name type:(NTJsonPropertyType)type jsonKeyPath:(NSString *)jsonKeyPath
{
    NTJsonProperty *property = [[NTJsonProperty alloc] init];
    
    if ( property )
    {
        property->_name = name;
        property->_jsonKeyPath = jsonKeyPath;
        property->_type = type;
    }
    
    return property;
}


+(instancetype)property:(NSString *)name type:(NTJsonPropertyType)type class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath
{
    NTJsonProperty *property = [[NTJsonProperty alloc] init];
    
    if ( property )
    {
        property->_name = name;
        property->_jsonKeyPath = jsonKeyPath;
        property->_type = type;
        property->_typeClass = class;
    }
    
    return property;
}


+(instancetype)property:(NSString *)name type:(NTJsonPropertyType)type enumValues:(NSSet *)enumValues jsonKeyPath:(NSString *)jsonKeyPath
{
    NTJsonProperty *property = [[NTJsonProperty alloc] init];
    
    if ( property )
    {
        property->_name = name;
        property->_jsonKeyPath = jsonKeyPath;
        property->_type = type;
        property->_enumValues = enumValues;
    }
    
    return property;
}


#pragma mark - Basic Types


+(instancetype)stringProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self property:name type:NTJsonPropertyTypeString jsonKeyPath:jsonKeyPath];
}


+(instancetype)stringProperty:(NSString *)name
{
    return [self property:name type:NTJsonPropertyTypeString jsonKeyPath:name];
}


+(instancetype)intProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self property:name type:NTJsonPropertyTypeInt jsonKeyPath:jsonKeyPath];
}


+(instancetype)intProperty:(NSString *)name
{
    return [self property:name type:NTJsonPropertyTypeInt jsonKeyPath:name];
}


+(instancetype)boolProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
{
    return [self property:name type:NTJsonPropertyTypeBool jsonKeyPath:jsonKeyPath];
}


+(instancetype)boolProperty:(NSString *)name;
{
    return [self property:name type:NTJsonPropertyTypeBool jsonKeyPath:name];
}


+(instancetype)floatProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
{
    return [self property:name type:NTJsonPropertyTypeFloat jsonKeyPath:jsonKeyPath];
}


+(instancetype)floatProperty:(NSString *)name;
{
    return [self property:name type:NTJsonPropertyTypeFloat jsonKeyPath:name];
}


+(instancetype)doubleProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
{
    return [self property:name type:NTJsonPropertyTypeDouble jsonKeyPath:jsonKeyPath];
}


+(instancetype)doubleProperty:(NSString *)name;
{
    return [self property:name type:NTJsonPropertyTypeDouble jsonKeyPath:name];
}


+(instancetype)longLongProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath;
{
    return [self property:name type:NTJsonPropertyTypeLongLong jsonKeyPath:jsonKeyPath];
}


+(instancetype)longLongProperty:(NSString *)name;
{
    return [self property:name type:NTJsonPropertyTypeLongLong jsonKeyPath:name];
}


#pragma mark - String Enum Types


+(instancetype)enumProperty:(NSString *)name enumValues:(NSSet *)enumValues jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self property:name type:NTJsonPropertyTypeStringEnum enumValues:enumValues jsonKeyPath:jsonKeyPath];
}


+(instancetype)enumProperty:(NSString *)name enumValues:(NSSet *)enumValues
{
    return [self property:name type:NTJsonPropertyTypeStringEnum enumValues:enumValues jsonKeyPath:name];
}


#pragma mark - Model Types


+(instancetype)modelProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self property:name type:NTJsonPropertyTypeModel class:class jsonKeyPath:jsonKeyPath];
}


+(instancetype)modelProperty:(NSString *)name class:(Class)class
{
    return [self property:name type:NTJsonPropertyTypeModel class:class jsonKeyPath:name];
}


+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self property:name type:NTJsonPropertyTypeModelArray class:class jsonKeyPath:jsonKeyPath];
}


+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class
{
    return [self property:name type:NTJsonPropertyTypeModelArray class:class jsonKeyPath:name];
}


#pragma mark - Object Types


+(instancetype)objectProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self property:name type:NTJsonPropertyTypeObject class:class jsonKeyPath:jsonKeyPath];
}


+(instancetype)objectProperty:(NSString *)name class:(Class)class
{
    return [self property:name type:NTJsonPropertyTypeObject class:class jsonKeyPath:name];
}


+(instancetype)objectArrayProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self property:name type:NTJsonPropertyTypeObjectArray class:class jsonKeyPath:jsonKeyPath];
}


+(instancetype)objectArrayProperty:(NSString *)name class:(Class)class
{
    return [self property:name type:NTJsonPropertyTypeObjectArray class:class jsonKeyPath:name];
}


#pragma mark - Properties


-(BOOL)shouldCache
{
    return (self.type == NTJsonPropertyTypeModel
            || self.type == NTJsonPropertyTypeModelArray
            || self.type == NTJsonPropertyTypeObject
            || self.type == NTJsonPropertyTypeObjectArray);
}


+(id)defaultValueForType:(NTJsonPropertyType)type
{
    switch (type)
    {
        case NTJsonPropertyTypeInt:
            return @(0);
            
        case NTJsonPropertyTypeBool:
            return @(NO);
            
        case NTJsonPropertyTypeFloat:
            return @((float)0);
            
        case NTJsonPropertyTypeDouble:
            return @((double)0);
            
        case NTJsonPropertyTypeLongLong:
            return ((long long)0);
            
        default:
            return nil;
    }
}


-(id)defaultValue
{
    if ( !_defaultValue )
        _defaultValue = [self.class defaultValueForType:self.type];
    
    return _defaultValue;
}


-(id)convertJsonToValue:(id)json inModel:(NTJsonModel *)model
{
    // todo: support builtin types (NSNumber, etc)

    if ( self.type != NTJsonPropertyTypeObject && self.type != NTJsonPropertyTypeObjectArray )
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"convertJsonToValue:inModel only supports Objects and ObjectArrays cuurrently." userInfo:nil];
    
    if ( ![self.typeClass respondsToSelector:@selector(convertJsonToValue:)] )
        @throw [NSException exceptionWithName:@"UnableToConvert" reason:@"Unable to convert Json to value 0 convertJsonToValue: not implemented" userInfo:nil];
    
    if ( self.type == NTJsonPropertyTypeObject )
        return [self.typeClass convertJsonToValue:json];
    
    else if ( self.type == NTJsonPropertyTypeObjectArray )
    {
        if ( ![json isKindOfClass:[NSArray class]] )
            return nil;  // not something we can actually convert.
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[json count]];
        
        for(id jsonItem in json)
        {
            id valueItem = [self.typeClass convertJsonToValue:jsonItem];
            
            if (valueItem)
                [array addObject:valueItem];
        }
        
        return (model.isMutable) ? array : [array copy];
    }
    
    return nil; // we shouldn't get here
}


-(id)convertValueToJson:(id)value inModel:(NTJsonModel *)model
{
    // todo: support builtin types (NSNumber, etc)
    
    if ( self.type != NTJsonPropertyTypeObject && self.type != NTJsonPropertyTypeObjectArray )
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"convertValueToJson:inModel only supports Objects and ObjectArrays cuurrently." userInfo:nil];
    
    if ( ![self.typeClass respondsToSelector:@selector(convertValueToJson:)] )
        @throw [NSException exceptionWithName:@"UnableToConvert" reason:@"Unable to convert Json to value 0 convertValueToJson: not implemented" userInfo:nil];
    
    if ( self.type == NTJsonPropertyTypeObject )
        return [self.typeClass convertValueToJson:value];
    
    else if ( self.type == NTJsonPropertyTypeObjectArray )
    {
        if ( ![value isKindOfClass:[NSArray class]] )
            return nil;  // not something we can actually convert.
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[value count]];
        
        for(id valueItem in value)
        {
            id jsonItem = [self.typeClass convertValueToJson:valueItem];
            
            if (jsonItem)
                [array addObject:jsonItem];
        }
        
        return (model.isMutable) ? array : [array copy];
    }
    
    return nil; // we shouldn't get here

}


@end
