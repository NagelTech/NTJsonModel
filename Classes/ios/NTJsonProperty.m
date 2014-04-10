//
//  NTJsonProperty.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonProperty.h"


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


+(instancetype)modelProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath isArray:(BOOL)isArray
{
    NTJsonProperty *property = [[NTJsonProperty alloc] init];
    
    if ( property )
    {
        property->_name = name;
        property->_jsonKeyPath = jsonKeyPath;
        property->_type = NTJsonPropertyTypeModel;
        property->_typeClass = class;
        property->_isArray = isArray;
    }
    
    return property;
}


+(instancetype)modelProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self modelProperty:name class:class jsonKeyPath:jsonKeyPath isArray:NO];
}


+(instancetype)modelProperty:(NSString *)name class:(Class)class
{
    return [self modelProperty:name class:class jsonKeyPath:name isArray:NO];
}


+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class jsonKeyPath:(NSString *)jsonKeyPath
{
    return [self modelProperty:name class:class jsonKeyPath:jsonKeyPath isArray:YES];
}


+(instancetype)modelArrayProperty:(NSString *)name class:(Class)class
{
    return [self modelProperty:name class:class jsonKeyPath:name isArray:YES];
}


-(BOOL)shouldCache
{
    return (self.type == NTJsonPropertyTypeModel || self.isArray);
}


@end
