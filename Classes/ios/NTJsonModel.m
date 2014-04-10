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
    
    NSDictionary *_json;
    NSMutableDictionary *_mutableJson;
    
    NTJsonModel __weak *_rootModel;
}

@end


@implementation NTJsonModel


-(id)init
{
    self = [super init];
    
    if ( self )
    {
        _json = @{};
        _rootModel = nil;
        _mutableJson = nil;
    }
    
    return self;
}


-(id)initWithJson:(NSDictionary *)json
{
    self = [super init];
    
    if ( self )
    {
        _json = json;
        _rootModel = nil;
        _mutableJson = nil;
    }
    
    return self;
}


-(id)initWithRootModel:(NTJsonModel *)rootModel json:(NSDictionary *)json
{
    self = [super init];
    
    if ( self )
    {
        _rootModel = rootModel;
        _json = json;
        _mutableJson = nil;
    }
    
    return self;
}


-(id)initWithRootModel:(NTJsonModel *)rootModel mutableJson:(NSMutableDictionary *)mutableJson
{
    self = [super init];
    
    if ( self )
    {
        _rootModel = rootModel;
        _json = nil;
        _mutableJson = mutableJson;
    }
    
    return self;
}


+(instancetype)modelWithJson:(NSDictionary *)json
{
    if ( !json )
        return nil;
    
    return [[self alloc] initWithJson:json];
}


+(NSArray *)propertyInfo
{
    return @[];
}


-(NSDictionary *)json
{
    return (_mutableJson) ? _mutableJson : _json;
}


-(void)setJson:(NSDictionary *)json
{
    if ( _rootModel )
    {
        
    }
    else
    {
        _json = json;
        _mutableJson = nil;
    }
}


-(NSMutableDictionary *)mutableJson
{
    return _mutableJson;
}


-(void)setMutableJson:(NSMutableDictionary *)mutableJson
{
    if ( _rootModel )
    {
        
    }
    else
    {
        _json = nil;
        _mutableJson = mutableJson;
    }
}


-(NTJsonModel *)rootModel
{
    return (_rootModel) ? _rootModel : self;
}


-(void)setRootModel:(NTJsonModel *)rootModel json:(NSDictionary *)json mutableJson:(NSMutableDictionary *)mutableJson
{
    _rootModel = (rootModel == self) ? nil : rootModel;
    _mutableJson = mutableJson;
    _json = json;
    
    if ( !_valueCache )
        return ; // all done
    
    for (NTJsonProperty *property in [self.class propertyInfo])
    {
        id value = _valueCache[property.name];
        
        if ( !value )
            continue;

        if ( property.isArray )
        {
            NTJsonModelArray *array = value;
            
            [array setRootModel:rootModel jsonArray:_json[property.jsonKeyPath] mutableJsonArray:_mutableJson[property.jsonKeyPath]];
        }
        
        else  if ( property.type == NTJsonPropertyTypeModel )
        {
            NTJsonModel *childModel = value;
            
            [childModel setRootModel:_rootModel json:_json[property.jsonKeyPath] mutableJson:_mutableJson[property.jsonKeyPath]];
        }
    }
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


-(void)becomeMutable
{
    if ( _mutableJson )
        return ; // already mutable...
    
    if ( _rootModel )   // we are a child model...
    {
        [_rootModel becomeMutable]; // make the entire object mutable
    }
    
    else
    {
        // make a mutable deep copy...
        
        NSMutableDictionary *mutableJson = NTJsonModel_mutableDeepCopy(_json);
        
        // recursively convert all objects to mutable...
        
        [self setRootModel:_rootModel json:nil mutableJson:mutableJson];
    }
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
    
    // grab the value form our json...
    
    NSDictionary *json = (_mutableJson) ? _mutableJson : _json;
    
    id jsonValue = [json objectForKey:property.jsonKeyPath];
    
    id value;
    
    // transform it...
    
    if ( property.isArray )
    {
        if ( _mutableJson )
            value = [[NTJsonModelArray alloc] initWithRootModel:self.rootModel property:property mutableJsonArray:jsonValue];
        else
            value = [[NTJsonModelArray alloc] initWithRootModel:self.rootModel property:property jsonArray:jsonValue];
    }
    
    else if ( property.type == NTJsonPropertyTypeModel )
    {
        if ( _mutableJson )
            value = [[property.typeClass alloc] initWithRootModel:self.rootModel mutableJson:jsonValue];
        else
            value = [[property.typeClass alloc] initWithRootModel:self.rootModel json:jsonValue];
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
    
    if ( !_mutableJson )
    {
        [self becomeMutable];
    }
    
    // set the value...
    
    if ( !value )
        [_mutableJson removeObjectForKey:property.jsonKeyPath];
    
    else if ( [value isKindOfClass:[NTJsonModel class]] )
    {
        NTJsonModel *model = value;
        
        NSMutableDictionary *mutableJson = (model.mutableJson) ? model.mutableJson : NTJsonModel_mutableDeepCopy(model.json);
        
        [model setRootModel:self.rootModel json:nil mutableJson:mutableJson];
        
        _mutableJson[property.jsonKeyPath] = mutableJson;
    }
    
    else if ( [value isKindOfClass:[NTJsonModelArray class]] )
    {
        NTJsonModelArray *modelArray = value;
        
        NSMutableArray *mutableJsonArray = (modelArray.mutableJsonArray) ? modelArray.mutableJsonArray : NTJsonModel_mutableDeepCopy(modelArray.jsonArray);
        
        [modelArray setRootModel:self.rootModel jsonArray:nil mutableJsonArray:mutableJsonArray];
        
        _mutableJson[property.jsonKeyPath] = mutableJsonArray;
    }
    
    else if ( [value isKindOfClass:[NSNumber class]]
             || [value isKindOfClass:[NSString class]]
             || [value isKindOfClass:[NSArray class]]
             || [value isKindOfClass:[NSDictionary class]]
             || value == [NSNull null] )
    {
        // todo: coerce value
        
        _mutableJson[property.jsonKeyPath] = value;
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
