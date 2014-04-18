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


+(NSArray *)propertyInfo
{
    return @[];
}


+(NTJsonProperty *)propertyInfoForName:(NSString *)name
{
    for (NTJsonProperty *property in [self propertyInfo])
    {
        if ( [property.name isEqualToString:name] )
            return property;
    }
    
    return nil;
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


#pragma mark - get/set property IMP thunks


static void setPropertyForSelector(Class class, SEL sel, NTJsonProperty *property)
{
    objc_setAssociatedObject(class, sel, property, OBJC_ASSOCIATION_RETAIN);
}


static NTJsonProperty *getPropertyForSelector(Class class, SEL sel)
{
    return objc_getAssociatedObject(class, sel);
}


static id getPropertyValue_object(NTJsonModel *model, SEL _cmd)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    return [model getValueForProperty:property];
}


static void setPropertyValue_object(NTJsonModel *model, SEL _cmd, id value)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    [model setValue:value forProperty:property];
}


static NSString *getPropertyValue_string(NTJsonModel *model, SEL _cmd)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    id value = [model getValueForProperty:property];
    
    if ( ![value isKindOfClass:[NSString class]] && [value respondsToSelector:@selector(stringValue)] )
        value = [value stringValue];
    
    return [value isKindOfClass:[NSString class]] ? value : nil;
}


static void setPropertyValue_string(NTJsonModel *model, SEL _cmd, NSString *value)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    [model setValue:value forProperty:property];
}


static int getPropertyValue_int(NTJsonModel *model, SEL _cmd)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    NSNumber *value = [model getValueForProperty:property];
    
    if ( ![value respondsToSelector:@selector(intValue)] )
        value = property.defaultValue;
    
    return [value intValue];
}


static void setPropertyValue_int(NTJsonModel *model, SEL _cmd, int value)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    [model setValue:@(value) forProperty:property];
}


static BOOL getPropertyValue_BOOL(NTJsonModel *model, SEL _cmd)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    NSNumber *value = [model getValueForProperty:property];
    
    if ( ![value respondsToSelector:@selector(boolValue)] )
        value = property.defaultValue;
    
    return [value boolValue];
}


static void setPropertyValue_BOOL(NTJsonModel *model, SEL _cmd, BOOL value)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    [model setValue:@(value) forProperty:property];
}


static float getPropertyValue_float(NTJsonModel *model, SEL _cmd)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    NSNumber *value = [model getValueForProperty:property];
    
    if ( ![value respondsToSelector:@selector(floatValue)] )
        value = property.defaultValue;
    
    return [value floatValue];
}


static void setPropertyValue_float(NTJsonModel *model, SEL _cmd, float value)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    [model setValue:@(value) forProperty:property];
}


static double getPropertyValue_double(NTJsonModel *model, SEL _cmd)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    NSNumber *value = [model getValueForProperty:property];
    
    if ( ![value respondsToSelector:@selector(doubleValue)] )
        value = property.defaultValue;

    return [value doubleValue];
}


static void setPropertyValue_double(NTJsonModel *model, SEL _cmd, double value)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    [model setValue:@(value) forProperty:property];
}


static long long getPropertyValue_longLong(NTJsonModel *model, SEL _cmd)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    NSNumber *value = [model getValueForProperty:property];
    
    if ( ![value respondsToSelector:@selector(longLongValue)] )
        value = property.defaultValue;
    
    return [value longLongValue];
}


static void setPropertyValue_longLong(NTJsonModel *model, SEL _cmd, long long value)
{
    NTJsonProperty *property = getPropertyForSelector([model class], _cmd);
    
    [model setValue:@(value) forProperty:property];
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
    
    setPropertyForSelector(self, sel, property);
    
    IMP imp;
    const char *typeCode = nil;
    
    switch(property.type)
    {
        case NTJsonPropertyTypeInt:
            imp = (isSet) ? (IMP)setPropertyValue_int : (IMP)getPropertyValue_int;
            typeCode = @encode(int);
            break;
            
        case NTJsonPropertyTypeBool:
            imp = (isSet) ? (IMP)setPropertyValue_BOOL : (IMP)getPropertyValue_BOOL;
            typeCode = @encode(BOOL);
            break;
            
        case NTJsonPropertyTypeFloat:
            imp = (isSet) ? (IMP)setPropertyValue_float : (IMP)getPropertyValue_float;
            typeCode = @encode(float);
            break;
            
        case NTJsonPropertyTypeDouble:
            imp = (isSet) ? (IMP)setPropertyValue_double : (IMP)getPropertyValue_double;
            typeCode = @encode(double);
            break;
            
        case NTJsonPropertyTypeLongLong:
            imp = (isSet) ? (IMP)setPropertyValue_longLong : (IMP)getPropertyValue_longLong;
            typeCode = @encode(long long);
            break;
            
        case NTJsonPropertyTypeString:
        case NTJsonPropertyTypeStringEnum:
            imp = (isSet) ? (IMP)setPropertyValue_string : (IMP)getPropertyValue_string;
            typeCode = @encode(NSString *);
            break;

        case NTJsonPropertyTypeModel:
        case NTJsonPropertyTypeModelArray:
        case NTJsonPropertyTypeObject:
        case NTJsonPropertyTypeObjectArray:
            imp = (isSet) ? (IMP)setPropertyValue_object : (IMP)getPropertyValue_object;
            typeCode = @encode(id);
            break;
    }
    
    char types[80];
    
    if ( isSet )
        sprintf(types, "v:@:%s", typeCode);
    else
        sprintf(types, "%s@:", typeCode);
    
    class_addMethod(self, sel, imp, types);
    
    return YES; // re-resolve
}


@end
