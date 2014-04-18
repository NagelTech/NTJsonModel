//
//  NTJsonProperty.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonProperty.h"


@interface NTJsonProperty ()
{
    id _defaultValue;
}

@end


@implementation NTJsonProperty


+(instancetype)property:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath type:(NTJsonPropertyType)type
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


+(instancetype)stringProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self property:name jsonKeyPath:jsonKeyPath type:NTJsonPropertyTypeString];
}


+(instancetype)stringProperty:(NSString *)name
{
    return [self property:name jsonKeyPath:name type:NTJsonPropertyTypeString];
}


+(instancetype)intProperty:(NSString *)name jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self property:name jsonKeyPath:jsonKeyPath type:NTJsonPropertyTypeInt];
}


+(instancetype)intProperty:(NSString *)name
{
    return [self property:name jsonKeyPath:name type:NTJsonPropertyTypeInt];
}


+(instancetype)modelProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath
{
    NTJsonProperty *property = [[NTJsonProperty alloc] init];
    
    if ( property )
    {
        property->_name = name;
        property->_jsonKeyPath = jsonKeyPath;
        property->_type = NTJsonPropertyTypeModel;
        property->_typeClass = class;
    }
    
    return property;
}


+(instancetype)modelProperty:(NSString *)name class:(Class)class
{
    return [self modelProperty:name class:class jsonKeyPath:name];
}


+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath
{
    NTJsonProperty *property = [[NTJsonProperty alloc] init];
    
    if ( property )
    {
        property->_name = name;
        property->_jsonKeyPath = jsonKeyPath;
        property->_type = NTJsonPropertyTypeModelArray;
        property->_typeClass = class;
    }
    
    return property;
}


+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class
{
    return [self modelArrayProperty:name class:class jsonKeyPath:name];
}


-(BOOL)shouldCache
{
    return (self.type == NTJsonPropertyTypeModel || self.type == NTJsonPropertyTypeModelArray);
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

@end
