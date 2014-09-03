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


#pragma mark - One-time initialization


+(BOOL)addImpsForProperty:(NTJsonProp *)property
{
    id getBlock;
    id setBlock;
    const char *typeCode = nil;
    
    switch(property.type)
    {
        case NTJsonPropTypeInt:
        {
            typeCode = @encode(int);
            setBlock = ^(NTJsonModel *model, int value)
            {
                [model setValue:@(value) forProperty:property];
            };
            getBlock = ^int(NTJsonModel *model)
            {
                NSNumber *value = [model getValueForProperty:property];
                
                if ( ![value respondsToSelector:@selector(intValue)] )
                    value = property.defaultValue;
                
                return [value intValue];
            };
            break;
        }
            
        case NTJsonPropTypeBool:
        {
            typeCode = @encode(BOOL);
            setBlock = ^(NTJsonModel *model, BOOL value)
            {
                [model setValue:@(value) forProperty:property];
            };
            getBlock = ^BOOL(NTJsonModel *model)
            {
                NSNumber *value = [model getValueForProperty:property];
                
                if ( ![value respondsToSelector:@selector(boolValue)] )
                    value = property.defaultValue;
                
                return [value boolValue];
            };
            break;
        }
            
        case NTJsonPropTypeFloat:
        {
            typeCode = @encode(float);
            setBlock = ^(NTJsonModel *model, float value)
            {
                [model setValue:@(value) forProperty:property];
            };
            getBlock = ^float(NTJsonModel *model)
            {
                NSNumber *value = [model getValueForProperty:property];
                
                if ( ![value respondsToSelector:@selector(floatValue)] )
                    value = property.defaultValue;
                
                return [value floatValue];
            };
            break;
        }
            
        case NTJsonPropTypeDouble:
        {
            typeCode = @encode(double);
            setBlock = ^(NTJsonModel *model, double value)
            {
                [model setValue:@(value) forProperty:property];
            };
            getBlock = ^double(NTJsonModel *model)
            {
                NSNumber *value = [model getValueForProperty:property];
                
                if ( ![value respondsToSelector:@selector(doubleValue)] )
                    value = property.defaultValue;
                
                return [value doubleValue];
            };
            break;
        }
            
        case NTJsonPropTypeLongLong:
        {
            typeCode = @encode(long long);
            setBlock = ^(NTJsonModel *model, long long value)
            {
                [model setValue:@(value) forProperty:property];
            };
            getBlock = ^long long(NTJsonModel *model)
            {
                NSNumber *value = [model getValueForProperty:property];
                
                if ( ![value respondsToSelector:@selector(longLongValue)] )
                    value = property.defaultValue;
                
                return [value longLongValue];
            };
            break;
        }
            
        case NTJsonPropTypeString:
        case NTJsonPropTypeStringEnum:
        {
            typeCode = @encode(NSString *);
            setBlock = ^void(NTJsonModel *model, NSString *value)
            {
                [model setValue:value forProperty:property];
            };
            getBlock = ^NSString *(NTJsonModel *model)
            {
                id value = [model getValueForProperty:property];
                
                if ( ![value isKindOfClass:[NSString class]] && [value respondsToSelector:@selector(stringValue)] )
                    value = [value stringValue];
                
                return [value isKindOfClass:[NSString class]] ? value : nil;
            };
            break;
        }
            
        case NTJsonPropTypeModel:
        case NTJsonPropTypeModelArray:
        case NTJsonPropTypeObject:
        case NTJsonPropTypeObjectArray:
        {
            typeCode = @encode(id);
            setBlock = ^(NTJsonModel *model, id value)
            {
                [model setValue:value forProperty:property];
            };
            getBlock = ^id(NTJsonModel *model)
            {
                return [model getValueForProperty:property];
            };
            break;
        }
            
        default:
            @throw [NSException exceptionWithName:@"UnexpectedPropertyType" reason:[NSString stringWithFormat:@"Unexpected property type for %@.%@", NSStringFromClass(self), property.name] userInfo:nil];
    }
    
    BOOL success = YES;
    
    // Add setter...
    
    if ( !property.isReadOnly )
    {
        char setTypes[80];
        sprintf(setTypes, "v:@:%s", typeCode);
        IMP setImp = imp_implementationWithBlock(setBlock);
        SEL setSel = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[property.name substringToIndex:1] uppercaseString], [property.name substringFromIndex:1]]);

        IMP setPrevImp = class_replaceMethod(self, setSel, setImp, setTypes);
        
        if ( setPrevImp )
        {
            NSLog(@"Error: an existing setter of an NTJsonModel property %@.%@ was found. Missing @dynamic?", NSStringFromClass(self), property.name);

            success = NO;
        }
    }
    
    // Add getter...
    
    if ( YES ) // just for consistency sake
    {
        char getTypes[80];
        sprintf(getTypes, "%s@:", typeCode);
        IMP getImp = imp_implementationWithBlock(getBlock);
        SEL getSel = NSSelectorFromString(property.name);;
        IMP getPrevImp = class_replaceMethod(self, getSel, getImp, getTypes);
        
        if ( getPrevImp )
        {
            NSLog(@"Error: an existing getter of an NTJsonModel property %@.%@ was found. Missing @dynamic?", NSStringFromClass(self), property.name);
            
            success = NO;
        }
    }
    
    return success;
}


+(NSArray *)jsonPropertiesForClass:(Class)class
{
    unsigned int numProperties;
    objc_property_t *objc_properties = class_copyPropertyList(class, &numProperties);
    
    NSMutableArray *properties = [NSMutableArray arrayWithCapacity:numProperties];
    
    for(unsigned int index=0; index<numProperties; index++)
    {
        objc_property_t objc_property = objc_properties[index];
        
        NTJsonProp *prop = [NTJsonProp propertyWithClass:self objcProperty:objc_property];

        if ( prop )
            [properties addObject:prop];
    }
    
    free(objc_properties);

    return [properties copy];
}


+(NSDictionary *)allRelatedPropertiesForPropertyInfo:(NSArray *)propertyInfo
{
    // Build our array of related properties...
    
    NSMutableDictionary *allRelatedProperties = [NSMutableDictionary dictionary];
    
    for(NTJsonProp *prop in propertyInfo)
    {
        NSMutableArray *relatedProperties = nil;
        int numReadWrite = (prop.isReadOnly) ? 0 : 1;
        
        for (NTJsonProp *related in propertyInfo)
        {
            if ( prop == related )
                continue;
            
            if ( [prop.jsonKeyPath hasPrefix:related.jsonKeyPath] || [related.jsonKeyPath hasPrefix:prop.jsonKeyPath] )
            {
                if ( !relatedProperties )
                    relatedProperties = [NSMutableArray array];
                
                [relatedProperties addObject:related];
                
                numReadWrite += (related.isReadOnly) ? 0 : 1;
            }
        }
        
        if ( relatedProperties )
        {
            allRelatedProperties[prop.name] = [relatedProperties copy];
        }

    }
    
    return [allRelatedProperties copy];
}


+(NSDictionary *)allRelatedProperties
{
    return objc_getAssociatedObject(self, @selector(allRelatedProperties));
}


+(NSArray *)relatedPropertiesForProperty:(NTJsonProp *)prop
{
    return [self allRelatedProperties][prop.name];
}


+(void)initialize
{
    if ( [self jsonAllPropertyInfo] )
        return ; // already initiailized
    
    NSMutableDictionary *jsonAllPropertyInfo = [NSMutableDictionary dictionary];
    BOOL success = YES;
    
    // start with properties from our superclass...
    
    if ( self.superclass != [NSObject class] )
        [jsonAllPropertyInfo addEntriesFromDictionary:[self.superclass jsonAllPropertyInfo]];
    
    // Add our properties and create the implementations for them...
    
    for(NTJsonProp *property in [self jsonPropertiesForClass:self])
    {
        success = success && [self addImpsForProperty:property];
        jsonAllPropertyInfo[property.name] = property;
    }
    
    if ( !success )
    {
        @throw [NSException exceptionWithName:@"NTJsonModelErrors" reason:[NSString stringWithFormat:@"Errors encountered initializing properties for NTJsonModel class %@, see log for more information.", NSStringFromClass(self)] userInfo:nil];
    }
    
    objc_setAssociatedObject(self, @selector(jsonAllPropertyInfo), [jsonAllPropertyInfo copy], OBJC_ASSOCIATION_RETAIN);
}


#pragma mark - Constructors


+(BOOL)modelClassForJsonOverridden
{
    NSNumber *modelClassForJsonOverridden = objc_getAssociatedObject(self, @selector(modelClassForJsonOverridden));
    
    if ( !modelClassForJsonOverridden )
    {
        modelClassForJsonOverridden = @(NO);
        
        unsigned int count;
        Method *methods = class_copyMethodList(object_getClass(self), &count);
        
        for(unsigned int index=0; index<count; index++)
        {
            SEL selector = method_getName(methods[index]);
            
            if ( selector == @selector(modelClassForJson:) )
            {
                modelClassForJsonOverridden = @(YES);
                break;
            }
        }
        
        free(methods);
        
        objc_setAssociatedObject(self, @selector(modelClassForJsonOverridden), modelClassForJsonOverridden, OBJC_ASSOCIATION_RETAIN);
    }
    
    return [modelClassForJsonOverridden boolValue];
}


+(Class)modelClassForJson:(NSDictionary *)json
{
    return self;
}


-(id)init
{
    self = [super init];
    
    if ( self )
    {
        _json = nil;
        _isMutable = YES;
    }
    
    return self;
}


-(id)initWithJson:(NSDictionary *)json
{
    if ( [self.class modelClassForJsonOverridden] )
    {
        Class modelClass = [self.class modelClassForJson:json];
        
        if ( modelClass != self.class )
            return [[modelClass alloc] initWithJson:json];
    }
    
    self = [super init];
    
    if ( self )
    {
        _json = [json copy];
        _isMutable = NO;
    }
    
    return self;
}


-(id)initMutableWithJson:(NSDictionary *)json
{
    if ( [self.class modelClassForJsonOverridden] )
    {
        Class modelClass = [self.class modelClassForJson:json];
        
        if ( modelClass != self.class )
            return [[modelClass alloc] initMutableWithJson:json];
    }
    
    // a little hack for now...
    
    NTJsonModel *model = [[self.class alloc] initWithJson:json];

    return [model mutableCopy];
}


+(instancetype)modelWithJson:(NSDictionary *)json
{
    if ( ![json isKindOfClass:[NSDictionary class]] )
        return nil;
    
    return [[self alloc] initWithJson:json];
}


+(instancetype)mutableModelWithJson:(NSDictionary *)json
{
    if ( ![json isKindOfClass:[NSDictionary class]] )
        return nil;
    
    return [[self alloc] initMutableWithJson:json];
}


#pragma mark - Array Helpers


+(NSArray *)arrayWithJsonArray:(NSArray *)jsonArray
{
    if ( ![jsonArray isKindOfClass:[NSArray class]] )
        return nil;
    
    return [[NTJsonModelArray alloc] initWithModelClass:self jsonArray:jsonArray];
}


+(NSMutableArray *)mutableArrayWithJsonArray:(NSArray *)jsonArray
{
    if ( ![jsonArray isKindOfClass:[NSMutableArray class]] )
        return nil;

    return nil; // todo [[NTJsonModelArray alloc] initWithModelClass:self mutableJsonArray:mutableJsonArray];
}


#pragma mark - create json


-(NSDictionary *)json
{
    if ( !_json && self.isMutable )
    {
        NSArray *properties = self.class.jsonAllPropertyInfo.allValues;
        
        NSMutableDictionary *json = [NSMutableDictionary dictionaryWithCapacity:properties.count];
        
        for(NTJsonProp *property in properties)
        {
            id jsonValue = [self getJsonValueForProperty:property];
            
            if ( jsonValue )
                json[property.name] = jsonValue;
        }
        
        _json = [json copy];
    }
    
    return _json;
}


#pragma mark - NSCopying & NSMutableCopying


static id NTJsonModel_deepCopy(id json)
{
    if ( [json isKindOfClass:[NSDictionary class]] )
    {
        NSMutableDictionary *mutable = [NSMutableDictionary dictionaryWithCapacity:[json count]];
        
        for (id key in [json allKeys])
        {
            id value = [json objectForKey:key];
            
            if ( [value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] )
                value = NTJsonModel_deepCopy(value);
            
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
                value = NTJsonModel_deepCopy(value);
            
            [mutable addObject:value];
        }
        
        return [mutable copy];
    }
    
    else
        return json;
}


-(id)mutableCopyWithZone:(NSZone *)zone
{
    NTJsonModel *model = [[self.class alloc] init];
    
    NSArray *properties = self.class.jsonAllPropertyInfo.allValues;
    
    for(NTJsonProp *property in properties)
    {
        id value = [self getValueForProperty:property];
        [model setValue:value forProperty:property];
    }
    
    return model;
}


-(id)copyWithZone:(NSZone *)zone
{
    if ( !self.isMutable )
        return self;
    
    return [[self.class alloc] initWithJson:self.json];
}


#pragma mark - Property Info management


+(NSArray *)jsonPropertyInfo
{
    return @[];
}


+(NSDictionary *)jsonAllPropertyInfo
{
    return objc_getAssociatedObject(self, @selector(jsonAllPropertyInfo));
}


#pragma mark - default json


+(NSDictionary *)_defaultJsonWithParentClasses:(NSSet *)parentClasses
{
    parentClasses = (parentClasses) ? [parentClasses setByAddingObject:[self class]] : [NSSet setWithObject:[self class]];
    
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    
    for(NTJsonProp *prop in [self jsonAllPropertyInfo].allValues)
    {
        id defaultValue;
        
        if ( prop.type == NTJsonPropTypeModel ) // recursive here...
        {
            if ( [parentClasses containsObject:[self class]] ) // prevent infinite recursion if self referential
                defaultValue = nil;
            else
                defaultValue = [self _defaultJsonWithParentClasses:parentClasses];
        }
        
        else
            defaultValue = prop.defaultValue;
        
        if ( defaultValue )
            [defaults NTJsonModel_setObject:defaultValue forKeyPath:prop.jsonKeyPath];
    }
    
    return (defaults.count) ? defaults : nil;
}


+(NSDictionary *)defaultJson
{
    NSDictionary *defaultJson = objc_getAssociatedObject(self, @selector(defaultJson));
    
    if ( !defaultJson )
    {
        defaultJson = NTJsonModel_deepCopy([self _defaultJsonWithParentClasses:nil]) ?: (id)[NSNull null];
        
        objc_setAssociatedObject(self, @selector(defaultJson), defaultJson, OBJC_ASSOCIATION_RETAIN);
    }
    
    return (defaultJson == (id)[NSNull null]) ? nil : defaultJson;
}


#pragma mark - caching


-(id)getCacheValueForProperty:(NTJsonProp *)property
{
    if ( property.shouldCache || self.isMutable )
    {
        id cachedValue = objc_getAssociatedObject(self, (__bridge void *)property);
        
        if ( cachedValue )
            return cachedValue;
    }
    
    return nil;
}


-(void)setCacheValue:(id)value forProperty:(NTJsonProp *)property
{
    objc_setAssociatedObject(self, (__bridge void *)property, value, OBJC_ASSOCIATION_RETAIN);
}


#pragma mark - get/set values


-(id)getValueForProperty:(NTJsonProp *)property
{
    // get from cache, if it is present...
    
    id value = (property.shouldCache || self.isMutable) ? [self getCacheValueForProperty:property] : nil;
    
    if ( value )
        return value;
    
    if ( self.isMutable )
        return nil; // we don't have a value for this guy, not much we can do.
    
    // grab the value from our json...
    
    id jsonValue = [self.json objectForKey:property.jsonKeyPath];
    
    // transform it...
    
    switch (property.type)
    {
        case NTJsonPropTypeInt:
        case NTJsonPropTypeBool:
        case NTJsonPropTypeFloat:
        case NTJsonPropTypeDouble:
        case NTJsonPropTypeLongLong:
        case NTJsonPropTypeString:
        {
            value = jsonValue;  // more validation/conversion happens in the thunks
            break;
        }
            
        case NTJsonPropTypeStringEnum:
        {
            NSString *enumValue = [property.enumValues member:jsonValue];
            value = (enumValue) ? enumValue : jsonValue;
            break;
        }
            
        case NTJsonPropTypeModel:
        {
            if ( ![jsonValue isKindOfClass:[NSDictionary class]] )
                value = nil;
            else if ( self.isMutable )
                value = [[property.typeClass alloc] initMutableWithJson:jsonValue];
            else
                value = [[property.typeClass alloc] initWithJson:jsonValue];

            break;
        }
            
        case NTJsonPropTypeObject:
        {
            value = [property convertJsonToValue:jsonValue];
            break;
        }

        case NTJsonPropTypeObjectArray:
        case NTJsonPropTypeModelArray:
        {
            if ( ![jsonValue isKindOfClass:[NSArray class]] )
                jsonValue = nil;
            else
                value = [[NTJsonModelArray alloc] initWithProperty:property jsonArray:jsonValue];
            break ;
        }
    }

    // save in cache, if indicated...
    
    if ( property.shouldCache && value != jsonValue )
        [self setCacheValue:value forProperty:property];
    
    return value;
}


-(id)getJsonValueForProperty:(NTJsonProp *)property
{
    id value = [self getCacheValueForProperty:property];
    
    if ( !value )
        return nil;
    
    switch (property.type)
    {
        case NTJsonPropTypeInt:
        case NTJsonPropTypeBool:
        case NTJsonPropTypeFloat:
        case NTJsonPropTypeDouble:
        case NTJsonPropTypeLongLong:
        case NTJsonPropTypeString:
        case NTJsonPropTypeStringEnum:
            return value;
            
        case NTJsonPropTypeModel:
            return [value respondsToSelector:@selector(json)] ? [value json] : nil;
            
        case NTJsonPropTypeModelArray:
            return [(NSArray *)value valueForKey:@"json"];  // extract the json out of each model object and create an array
            
        case NTJsonPropTypeObjectArray:
        {
            NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:[value count]];
            
            for(id object in value)
                [jsonArray addObject:[property convertValueToJson:object] ?: [NSNull null]];
            
            return [jsonArray copy];
        }
            
        case NTJsonPropTypeObject:
            return [property convertValueToJson:value];
            
        default:
            return nil;
    }
}


-(void)setValue:(id)value forProperty:(NTJsonProp *)property
{
    // make sure we are mutable...
    
    if ( !self.isMutable )
        @throw [NSException exceptionWithName:@"Immutable" reason:@"Attempt to modify an immutable NTJsonModel" userInfo:nil];
    
    // if we had a cached version of the json, invalidate it now.
    
    _json = nil;
    
    // if nil is passed in we simply remove the value
    
    if ( !value )
    {
        [self setCacheValue:nil forProperty:property];
        return ;
    }

    // Make sure we have a valid type
    
    Class expectedValueType = Nil;
    
    switch (property.type)
    {
        case NTJsonPropTypeInt:
        case NTJsonPropTypeBool:
        case NTJsonPropTypeFloat:
        case NTJsonPropTypeDouble:
        case NTJsonPropTypeLongLong:
            expectedValueType = [NSNumber class];
            break;
            
        case NTJsonPropTypeString:
            expectedValueType = [NSString class];
            break;

        case NTJsonPropTypeStringEnum:
        {
            expectedValueType = [NSString class];
            value = [property.enumValues member:value] ?: value;       // always massage to the enum value if it exists
            break;
        }
            
        case NTJsonPropTypeModel:
        case NTJsonPropTypeObject:
            expectedValueType = property.typeClass;
            break;

        case NTJsonPropTypeModelArray:
        case NTJsonPropTypeObjectArray:
        {
            expectedValueType = [NSArray class];
            break ;
        }
    }
    
    // Validate we got the correct expected type...
    
    if ( ![value isKindOfClass:expectedValueType] )
        @throw [NSException exceptionWithName:@"InvalidType" reason:@"Invalid type when setting property" userInfo:nil];
    
    [self setCacheValue:value forProperty:property];
}


@end
