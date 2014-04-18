//
//  NTJsonModel.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <objc/runtime.h>

#import "NTJsonModel.h"


@interface NTJsonModel ()
{
    NSMutableDictionary *_valueCache;
    
    id _json;
    BOOL _isMutable;
}

@end


@implementation NTJsonModel


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


+(NSArray *)propertyInfo
{
    return @[];
}


-(NSDictionary *)json
{
    return _json;
}


-(NSMutableDictionary *)mutableJson
{
    return (_isMutable) ? _json : nil;
}


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


+(NTJsonProperty *)propertyInfoForName:(NSString *)name
{
    for (NTJsonProperty *property in [self propertyInfo])
    {
        if ( [property.name isEqualToString:name] )
            return property;
    }
    
    return nil;
}


-(id)getValueForProperty:(NTJsonProperty *)property
{
    // get from cache, if it is present...
    
    if ( property.shouldCache && _valueCache )
    {
        id cachedValue = _valueCache[property.name];
        
        if ( cachedValue )
            return cachedValue;   // that was easy!
    }
    
    // grab the value from our json...
    
    id jsonValue = [self.json objectForKey:property.jsonKeyPath];
    
    id value;
    
    // transform it...
    
    if ( property.isArray && property.type == NTJsonPropertyTypeModel )
    {
        if ( self.isMutable )
            value = [[NTJsonModelArray alloc] initWithModelClass:property.typeClass mutableJsonArray:jsonValue];
        else
            value = [[NTJsonModelArray alloc] initWithModelClass:property.typeClass jsonArray:jsonValue];
    }
    
    else if ( property.type == NTJsonPropertyTypeModel )
    {
        if ( self.isMutable )
            value = [[property.typeClass alloc] initWithMutableJson:jsonValue];
        else
            value = [[property.typeClass alloc] initWithJson:jsonValue];
    }
    
    else
    {
        value = jsonValue; // todo: coerce into correct type
    }
    
    // save in cache, if indicated...
    
    if ( property.shouldCache )
    {
        if ( !value )
        {
            if ( _valueCache )
                [_valueCache removeObjectForKey:property.name];
        }
        else
        {
            if ( !_valueCache )
                _valueCache = [NSMutableDictionary dictionary];
            
            _valueCache[property.name] = value;
        }
    }
    
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
    
    // set the value...
    
    if ( !value )
        [_json removeObjectForKey:property.jsonKeyPath];
    
    else if ( [value isKindOfClass:[NTJsonModel class]] )
    {
        NTJsonModel *model = value;
        
        self.mutableJson[property.jsonKeyPath] = model.json;
    }
    
    else if ( [value isKindOfClass:[NTJsonModelArray class]] )
    {
        NTJsonModelArray *modelArray = value;

        self.mutableJson[property.jsonKeyPath] = modelArray.jsonArray;
    }
    
    else if ( [value isKindOfClass:[NSArray class]]
             || [value isKindOfClass:[NSDictionary class]] )
    {
        self.mutableJson[property.jsonKeyPath] = value;
    }
    
    else if ( [value isKindOfClass:[NSNumber class]]
             || [value isKindOfClass:[NSString class]]
             || value == [NSNull null] )
    {
        // todo: coerce value
        
        self.mutableJson[property.jsonKeyPath] = value;
    }
    
    else
    {
        // todo
    }
    
    // cache it, if indicated
    
    if ( property.shouldCache )
    {
        if ( !value )
        {
            if ( _valueCache )
                [_valueCache removeObjectForKey:property.name];
        }
        else
        {
            if ( !_valueCache )
                _valueCache = [NSMutableDictionary dictionary];
            
            _valueCache[property.name] = value;
        }
    }
}


static NSMutableDictionary *propertyMap = nil;


static id getPropertyValue_object(NTJsonModel *model, SEL _cmd)
{
    NTJsonProperty *property = propertyMap[@((NSInteger)(void *)_cmd)];
    
    return [model getValueForProperty:property];
}


static void setPropertyValue_object(NTJsonModel *model, SEL _cmd, id value)
{
    NTJsonProperty *property = propertyMap[@((NSInteger)(void *)_cmd)];
    
    [model setValue:value forProperty:property];
}


static int getPropertyValue_int(NTJsonModel *model, SEL _cmd)
{
    NTJsonProperty *property = propertyMap[@((NSInteger)(void *)_cmd)];
    
    NSNumber *value = [model getValueForProperty:property];
    
    return [value intValue];
}


static void setPropertyValue_int(NTJsonModel *model, SEL _cmd, int value)
{
    NTJsonProperty *property = propertyMap[@((NSInteger)(void *)_cmd)];
    
    [model setValue:@(value) forProperty:property];
}


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
        return [super resolveInstanceMethod:sel]; // not a property we know about, crap.
    
    // Wire this guy up!
    
    if ( !propertyMap )
    {
        propertyMap = [NSMutableDictionary dictionary];
    }
    
    propertyMap[@((NSInteger)(void *)sel)] = property;
    
    IMP imp;
    const char *typeCode;
    
    if ( property.isArray )
    {
        imp = (isSet) ? (IMP)setPropertyValue_object : (IMP)getPropertyValue_object;
        typeCode = @encode(id);
    }
    
    else
    {
        switch(property.type)
        {
            case NTJsonPropertyTypeInt:
                imp = (isSet) ? (IMP)setPropertyValue_int : (IMP)getPropertyValue_int;
                typeCode = @encode(int);
                break;
                
            default:
                imp = (isSet) ? (IMP)setPropertyValue_object : (IMP)getPropertyValue_object;
                typeCode = @encode(id);
                break;
        }
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
