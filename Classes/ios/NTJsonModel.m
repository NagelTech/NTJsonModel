//
//  NTJsonModel.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <objc/runtime.h>

#import "NTJsonModel+Private.h"


@interface NTJsonModel ()
{
    id _json;
    BOOL _isMutable;
}

@end


@implementation NTJsonModel


#pragma mark - Constructors


-(id)init
{
    self = [super init];
    
    if ( self )
    {
        _json = [NSMutableDictionary dictionary];
        _isMutable = YES;
    }
    
    return self;
}


-(id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    
    if ( self )
    {
        _json = json;
        _isMutable = NO;
    }
    
    return self;
}


-(id)initWithMutableJson:(NSMutableDictionary *)mutableJson
{
    self = [super init];
    
    if ( self )
    {
        _json = mutableJson;
        _isMutable = YES;
    }
    
    return self;
}


+(instancetype)modelWithJson:(NSDictionary *)json
{
    if ( !json )
        return nil;
    
    return [[self alloc] initWithJson:json];
}


+(instancetype)modelWithMutableJson:(NSMutableDictionary *)mutableJson
{
    if ( !mutableJson )
        return nil;
    
    return [[self alloc] initWithMutableJson:mutableJson];
}


#pragma mark - Array Helpers


+(NSArray *)arrayWithJsonArray:(NSArray *)jsonArray
{
    if ( ![jsonArray isKindOfClass:[NSArray class]] )
        return nil;
    
    return [[NTJsonModelArray alloc] initWithModelClass:self jsonArray:jsonArray];
}


+(NSMutableArray *)arrayWithMutableJsonArray:(NSMutableArray *)mutableJsonArray
{
    if ( ![mutableJsonArray isKindOfClass:[NSArray class]] )
        return nil;

    return [[NTJsonModelArray alloc] initWithModelClass:self mutableJsonArray:mutableJsonArray];
}


#pragma mark - Properties


-(NSDictionary *)json
{
    return _json;
}


-(NSMutableDictionary *)mutableJson
{
    return (_isMutable) ? _json : nil;
}


#pragma mark - NSCopying & NSMutableCopying


id NTJsonModel_mutableDeepCopy(id json)
{
    if ( [json isKindOfClass:[NSDictionary class]] )
    {
        NSMutableDictionary *mutable = [NSMutableDictionary dictionaryWithCapacity:[json count]];
        
        for (id key in [json allKeys])
        {
            id value = [json objectForKey:key];
            
            if ( [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] )
                value = NTJsonModel_mutableDeepCopy(value);
            
            [mutable setObject:value forKey:key];
        }
        
        return mutable;
    }
    
    else if ( [json isKindOfClass:[NSArray class]] )
    {
        NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:[json count]];
        
        for(id item in json)
        {
            id value = item;
            
            if ( [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] )
                value = NTJsonModel_mutableDeepCopy(value);
            
            [mutable addObject:value];
        }
        
        return mutable;
    }
    
    else
        return json;
}


id NTJsonModel_deepCopy(id json)
{
    if ( [json isKindOfClass:[NSDictionary class]] )
    {
        NSMutableDictionary *mutable = [NSMutableDictionary dictionaryWithCapacity:[json count]];
        
        for (id key in [json allKeys])
        {
            id value = [json objectForKey:key];
            
            if ( [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] )
                value = NTJsonModel_mutableDeepCopy(value);
            
            [mutable setObject:value forKey:key];
        }
        
        return [mutable copy];  // return immutable copy
    }
    
    else if ( [json isKindOfClass:[NSArray class]] )
    {
        NSMutableArray *mutable = [NSMutableArray arrayWithCapacity:[json count]];
        
        for(id item in json)
        {
            id value = item;
            
            if ( [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] )
                value = NTJsonModel_mutableDeepCopy(value);
            
            [mutable addObject:value];
        }
        
        return [mutable copy];
    }
    
    else
        return json;
}


-(id)mutableCopyWithZone:(NSZone *)zone
{
    NSMutableDictionary *mutableJson = NTJsonModel_mutableDeepCopy(self.json);
    
    return [[self.class allocWithZone:zone] initWithMutableJson:mutableJson];
}


-(id)copyWithZone:(NSZone *)zone
{
    NSDictionary *json = (self.isMutable) ? NTJsonModel_deepCopy(self.json) : self.json;
    
    return [[self.class allocWithZone:zone] initWithJson:json];
}


#pragma mark - Property Info management


static const void *PROPERTY_INFO_MAP_ASSOC_KEY = "PROPERTY_INFO_MAP_ASSOC_KEY";
static const void *SCANNING_PROPERTIES_ASSOC_KEY = "SCANNING_PROPERTIES_ASSOC_KEY";


+(NSArray *)propertyInfo
{
    return @[];
}


+(NSDictionary *)scanProperties
{
    NSMutableDictionary *propertyInfoMap = [NSMutableDictionary dictionary];
    
    for(NTJsonProperty *property in [self propertyInfo])
        propertyInfoMap[property.name] = property;
    
    return [propertyInfoMap copy];
}


+(NSDictionary *)propertyInfoMap
{
    NSDictionary *propertyInfoMap = objc_getAssociatedObject(self, PROPERTY_INFO_MAP_ASSOC_KEY);
    
    if ( !propertyInfoMap )
    {
        propertyInfoMap = [self scanProperties];
        objc_setAssociatedObject(self, PROPERTY_INFO_MAP_ASSOC_KEY, propertyInfoMap, OBJC_ASSOCIATION_RETAIN);
    }

    return propertyInfoMap;
}


+(NTJsonProperty *)propertyInfoForName:(NSString *)name
{
    return [self propertyInfoMap][name];
}


#pragma mark - caching


-(id)getCacheValueForProperty:(NTJsonProperty *)property
{
    if ( property.shouldCache )
    {
        id cachedValue = objc_getAssociatedObject(self, (__bridge void *)property);
        
        if ( cachedValue )
            return cachedValue;
    }
    
    return nil;
}


-(void)setCacheValue:(id)value forProperty:(NTJsonProperty *)property
{
    if ( !property.shouldCache )
        return ;

    objc_setAssociatedObject(self, (__bridge void *)property, value, OBJC_ASSOCIATION_RETAIN);
}


#pragma mark - get/set values


-(id)getValueForProperty:(NTJsonProperty *)property
{
    // get from cache, if it is present...
    
    id value = (property.shouldCache) ? [self getCacheValueForProperty:property] : nil;
    
    if ( value )
        return value;
    
    // grab the value from our json...
    
    id jsonValue = [self.json objectForKey:property.jsonKeyPath];
    
    // transform it...
    
    switch (property.type)
    {
        case NTJsonPropertyTypeInt:
        case NTJsonPropertyTypeBool:
        case NTJsonPropertyTypeFloat:
        case NTJsonPropertyTypeDouble:
        case NTJsonPropertyTypeLongLong:
        case NTJsonPropertyTypeString:
            value = jsonValue;  // more validation/conversion happens in the thunks
            break;
            
        case NTJsonPropertyTypeStringEnum:
        {
            NSString *enumValue = [property.enumValues member:jsonValue];
            value = (enumValue) ? enumValue : jsonValue;
            break;
        }
            
        case NTJsonPropertyTypeModel:
            if ( self.isMutable )
                value = [[property.typeClass alloc] initWithMutableJson:jsonValue];
            else
                value = [[property.typeClass alloc] initWithJson:jsonValue];
            break;
            
        case NTJsonPropertyTypeModelArray:
            if ( self.isMutable )
                value = [[NTJsonModelArray alloc] initWithModelClass:property.typeClass mutableJsonArray:jsonValue];
            else
                value = [[NTJsonModelArray alloc] initWithModelClass:property.typeClass jsonArray:jsonValue];
            break ;
            
        case NTJsonPropertyTypeObject:
            value = [property convertJsonToValue:jsonValue inModel:self];
            break;
            
        case NTJsonPropertyTypeObjectArray:
            value = [property convertJsonToValue:jsonValue inModel:self];
            break;
    }

    // save in cache, if indicated...
    
    if ( property.shouldCache )
        [self setCacheValue:value forProperty:property];
    
    return value;
}


-(void)setValue:(id)value forProperty:(NTJsonProperty *)property
{
    // todo: see if the value is actually changing
    
    // make sure we are mutable...
    
    if ( !self.isMutable )
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Attempt to modify an immutable NTJsonModel instance" userInfo:nil];
    }
    
    // if nil is passed in we simply remove the value
    
    if ( !value )
    {
        if (property.shouldCache)
            [self setCacheValue:nil forProperty:property];
        
        [_json removeObjectForKey:property.jsonKeyPath];
        return ;
    }

    // Convert to json...
    
    id jsonValue = nil;
    Class expectedValueType = Nil;
    
    switch (property.type)
    {
        case NTJsonPropertyTypeInt:
        case NTJsonPropertyTypeBool:
        case NTJsonPropertyTypeFloat:
        case NTJsonPropertyTypeDouble:
        case NTJsonPropertyTypeLongLong:
            expectedValueType = [NSNumber class];
            jsonValue = value;
            break;
            
        case NTJsonPropertyTypeString:
            expectedValueType = [NSString class];
            jsonValue = value;
            break;

        case NTJsonPropertyTypeStringEnum:
        {
            expectedValueType = [NSString class];
            NSString *enumValue = [property.enumValues member:value];
            jsonValue = (enumValue) ? enumValue : value;
            break;
        }
            
        case NTJsonPropertyTypeModel:
            expectedValueType = [NTJsonModel class];
            jsonValue = [value respondsToSelector:@selector(json)] ? [value json] : nil;
            break;
            
        case NTJsonPropertyTypeModelArray:
            expectedValueType = [NTJsonModelArray class];
            jsonValue = [value respondsToSelector:@selector(jsonArray)] ? [value jsonArray] : nil;
            break ;

            
        case NTJsonPropertyTypeObject:
            expectedValueType = property.typeClass;
            jsonValue = [property convertValueToJson:value inModel:self];
            // todo - conversion
            break;
            
        case NTJsonPropertyTypeObjectArray:
            expectedValueType = [NSArray class];
            jsonValue = [property convertValueToJson:value inModel:self];
            // to do - conversion
            break;
    }
    
    // Validate we got the correct expected type...
    
    if ( ![value isKindOfClass:expectedValueType] )
        @throw [NSException exceptionWithName:@"InvalidType" reason:@"Invalid type when setting property" userInfo:nil];
    
    // if we don't have a value now then we have a problem
    
    if ( !jsonValue )
        @throw [NSException exceptionWithName:@"InvalidJsonObject" reason:@"Unable to convert property to JSON object" userInfo:nil];
    
    // actually set the json...
    
    self.mutableJson[property.jsonKeyPath] = jsonValue;
    
    // cache the value, if indicated
    
    if ( property.shouldCache )
        [self setCacheValue:value forProperty:property];
}


#pragma mark - dynamic method resolution


+(BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selName = NSStringFromSelector(sel);
    
    BOOL isSet;
    NSString *name;
    
    if ( [selName hasPrefix:@"set"] )
    {
        isSet = YES;
        name = [[[selName substringWithRange:NSMakeRange(3, 1)] lowercaseString] stringByAppendingString:[selName substringWithRange:NSMakeRange(4, selName.length-5)]];
    }
    else
    {
        isSet = NO;
        name = selName;
    }
    
    NTJsonProperty *property = [self propertyInfoForName:name];
    
    if ( !property )
        return [super resolveInstanceMethod:sel]; // not a property we know about.
    
    // Wire this guy up!
    
    id impBlock;
    const char *typeCode = nil;
    
    switch(property.type)
    {
        case NTJsonPropertyTypeInt:
            typeCode = @encode(int);
            if ( isSet )
            {
                impBlock = ^(NTJsonModel *model, int value)
                {
                    [model setValue:@(value) forProperty:property];
                };
            }
            else
            {
                impBlock = ^int(NTJsonModel *model)
                {
                    NSNumber *value = [model getValueForProperty:property];
                    
                    if ( ![value respondsToSelector:@selector(intValue)] )
                        value = property.defaultValue;
                    
                    return [value intValue];
                };
            }
            break;
            
        case NTJsonPropertyTypeBool:
            typeCode = @encode(BOOL);
            if ( isSet )
            {
                impBlock = ^(NTJsonModel *model, BOOL value)
                {
                    [model setValue:@(value) forProperty:property];
                };
            }
            else
            {
                impBlock = ^BOOL(NTJsonModel *model)
                {
                    NSNumber *value = [model getValueForProperty:property];
                    
                    if ( ![value respondsToSelector:@selector(boolValue)] )
                        value = property.defaultValue;
                    
                    return [value boolValue];
                };
            }
            break;
            
        case NTJsonPropertyTypeFloat:
            typeCode = @encode(float);
            if ( isSet )
            {
                impBlock = ^(NTJsonModel *model, float value)
                {
                    [model setValue:@(value) forProperty:property];
                };
            }
            else
            {
                impBlock = ^float(NTJsonModel *model)
                {
                    NSNumber *value = [model getValueForProperty:property];
                    
                    if ( ![value respondsToSelector:@selector(floatValue)] )
                        value = property.defaultValue;
                    
                    return [value floatValue];
                };
            }
            break;
            
        case NTJsonPropertyTypeDouble:
            typeCode = @encode(double);
            if ( isSet )
            {
                impBlock = ^(NTJsonModel *model, double value)
                {
                    [model setValue:@(value) forProperty:property];
                };
            }
            else
            {
                impBlock = ^double(NTJsonModel *model)
                {
                    NSNumber *value = [model getValueForProperty:property];
                    
                    if ( ![value respondsToSelector:@selector(doubleValue)] )
                        value = property.defaultValue;
                    
                    return [value doubleValue];
                };
            }
            break;
            
        case NTJsonPropertyTypeLongLong:
            typeCode = @encode(long long);
            if ( isSet )
            {
                impBlock = ^(NTJsonModel *model, long long value)
                {
                    [model setValue:@(value) forProperty:property];
                };
            }
            else
            {
                impBlock = ^long long(NTJsonModel *model)
                {
                    NSNumber *value = [model getValueForProperty:property];
                    
                    if ( ![value respondsToSelector:@selector(longLongValue)] )
                        value = property.defaultValue;
                    
                    return [value longLongValue];
                };
            }
                
            break;
            
        case NTJsonPropertyTypeString:
        case NTJsonPropertyTypeStringEnum:
            typeCode = @encode(NSString *);
            if ( isSet )
            {
                impBlock = ^void(NTJsonModel *model, NSString *value)
                {
                    [model setValue:value forProperty:property];
                };
            }
            else
            {
                impBlock = ^NSString *(NTJsonModel *model)
                {
                    id value = [model getValueForProperty:property];
                    
                    if ( ![value isKindOfClass:[NSString class]] && [value respondsToSelector:@selector(stringValue)] )
                        value = [value stringValue];
                    
                    return [value isKindOfClass:[NSString class]] ? value : nil;
                };
            }
            break;

        case NTJsonPropertyTypeModel:
        case NTJsonPropertyTypeModelArray:
        case NTJsonPropertyTypeObject:
        case NTJsonPropertyTypeObjectArray:
            typeCode = @encode(id);
            if ( isSet )
            {
                impBlock = ^(NTJsonModel *model, id value)
                {
                    [model setValue:value forProperty:property];
                };
            }
            else
            {
                impBlock = ^id(NTJsonModel *model)
                {
                    return [model getValueForProperty:property];
                };
            }
            break;
    }
    
    char types[80];
    
    if ( isSet )
        sprintf(types, "v:@:%s", typeCode);
    else
        sprintf(types, "%s@:", typeCode);
    
    IMP imp = imp_implementationWithBlock(impBlock);
    
    class_addMethod(self, sel, imp, types);
    
    return YES; // re-resolve
}


@end
