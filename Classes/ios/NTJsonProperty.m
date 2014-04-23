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
    Class _modelClass;
    
    id _defaultValue;

    id _convertValueToJsonTarget;
    SEL _convertValueToJsonSelector;

    id _convertJsonToValueTarget;
    SEL _convertJsonToValueSelector;
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


-(Class)modelClass
{
    return _modelClass;
}


-(void)setModelClass:(Class)modelClass
{
    _modelClass = modelClass;
}


#pragma mark - Conversion support



-(BOOL)probeConverterToValue:(BOOL)toValue Target:(id)target selector:(SEL)selector
{
    if ( ![target respondsToSelector:selector] )
        return NO;
    
    if ( toValue )
    {
        _convertJsonToValueTarget = target;
        _convertJsonToValueSelector = selector;
    }
    
    else // toJson
    {
        _convertValueToJsonTarget = target;
        _convertValueToJsonSelector = selector;
    }
    
    return YES;
}


-(id)convertJsonToValue:(id)json
{
    if ( self.type != NTJsonPropertyTypeObject && self.type != NTJsonPropertyTypeObjectArray )
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"convertJsonToValue: only supports Objects currently." userInfo:nil];
    
    if ( !_convertJsonToValueSelector )
    {
        NSString *convertJsonToProperty = [NSString stringWithFormat:@"convertJsonTo%@%@:", [[self.name substringToIndex:1] uppercaseString], [self.name substringFromIndex:1]];
        NSString *convertJsonToClass = [NSString stringWithFormat:@"convertJsonTo%@:", NSStringFromClass(self.typeClass)];
        
        BOOL found = [self probeConverterToValue:YES Target:self.modelClass selector:NSSelectorFromString(convertJsonToProperty)];
        
        if ( !found )
            found = [self probeConverterToValue:YES Target:self.modelClass selector:NSSelectorFromString(convertJsonToClass)];
        
        if ( !found )
            found = [self probeConverterToValue:YES Target:self.typeClass selector:@selector(convertJsonToValue:)];
        
        if ( !found )
            @throw [NSException exceptionWithName:@"UnableToConvert" reason:[NSString stringWithFormat:@"Unable to find a JsonToValue converter for %@.%@ of type %@. Tried %@ +%@, %@ +%@ and %@ +convertJsonToValue:",  NSStringFromClass(self.modelClass), self.name, NSStringFromClass(self.typeClass), NSStringFromClass(self.modelClass), convertJsonToProperty, NSStringFromClass(self.modelClass), convertJsonToClass, NSStringFromClass(self.modelClass)] userInfo:nil];
    }

    // somehow this is the "safe" way to call performSelector using ARC. Ironic? Yep!
    // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    
    id (*method)(id self, SEL _cmd, id json) = (void *)[_convertJsonToValueTarget methodForSelector:_convertJsonToValueSelector];
    
    return method(_convertJsonToValueTarget, _convertJsonToValueSelector, json);
}


-(id)convertValueToJson:(id)value
{
    if ( self.type != NTJsonPropertyTypeObject && self.type != NTJsonPropertyTypeObjectArray )
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"convertValueToJson: only supports Objects currently." userInfo:nil];
    
    if ( !_convertValueToJsonSelector )
    {
        NSString *convertPropertyToJson = [NSString stringWithFormat:@"convert%@%@ToJson:", [[self.name substringToIndex:1] uppercaseString], [self.name substringFromIndex:1]];
        NSString *convertClassToJson = [NSString stringWithFormat:@"convert%@ToJson:", NSStringFromClass(self.typeClass)];
        
        BOOL found = [self probeConverterToValue:NO Target:self.modelClass selector:NSSelectorFromString(convertPropertyToJson)];
        
        if ( !found )
            found = [self probeConverterToValue:NO Target:self.modelClass selector:NSSelectorFromString(convertClassToJson)];
        
        if ( !found )
            found = [self probeConverterToValue:NO Target:self.typeClass selector:@selector(convertValueToJson:)];
        
        if ( !found )
            @throw [NSException exceptionWithName:@"UnableToConvert" reason:[NSString stringWithFormat:@"Unable to find a ValueToJson converter for %@.%@ of type %@. Tried %@ +%@, %@ +%@ and %@ +convertValueToJson:",  NSStringFromClass(self.modelClass), self.name, NSStringFromClass(self.typeClass), NSStringFromClass(self.modelClass), convertPropertyToJson, NSStringFromClass(self.modelClass), convertClassToJson, NSStringFromClass(self.modelClass)] userInfo:nil];
    }
    
    // somehow this is the "safe" way to call performSelector using ARC. Ironic? Yep!
    // http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    
    id (*method)(id self, SEL _cmd, id json) = (void *)[_convertValueToJsonTarget methodForSelector:_convertValueToJsonSelector];
    
    return method(_convertValueToJsonTarget, _convertValueToJsonSelector, value);
}


@end
