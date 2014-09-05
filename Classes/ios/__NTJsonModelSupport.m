//
//  __NTJsonModelSupport.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 9/4/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "__NTJsonModelSupport.h"

#import "NTJsonModel+Private.h"


@interface __NTJsonModelSupport ()
{
    NSDictionary *_properties;
    NSDictionary *_allRelatedProperties;
    NSDictionary *_defaultJson;
    BOOL _modelClassForJsonOverridden;
}

@property (nonatomic,readonly) NSDictionary *allRelatedProperties;

@end


@implementation __NTJsonModelSupport


-(__NTJsonModelSupport *)superSupport
{
    if ( self.modelClass.superclass == [NSObject class] )
        return nil;
    else
        return [self.modelClass.superclass __ntJsonModelSupport];
}


#pragma mark - Initialization


-(void)addImpsForProperty:(NTJsonProp *)property
{
    // Figure out the typeCode, getter and setter based on the property type...
    
    const char *typeCode = nil;
    id getBlock = nil;
    id setBlock = nil;
    
    switch(property.type)
    {
        case NTJsonPropTypeInt:
        {
            typeCode = @encode(int);
            setBlock = ^(NTJsonModel *model, int value)
            {
                [self setValue:@(value) forProperty:property inModel:model];
            };
            getBlock = ^int(NTJsonModel *model)
            {
                return [[self getValueForProperty:property inModel:model] intValue];
            };
            break;
        }
            
        case NTJsonPropTypeBool:
        {
            typeCode = @encode(BOOL);
            setBlock = ^(NTJsonModel *model, BOOL value)
            {
                [self setValue:@(value) forProperty:property inModel:model];
            };
            getBlock = ^BOOL(NTJsonModel *model)
            {
                return [[self getValueForProperty:property inModel:model] boolValue];
            };
            break;
        }
            
        case NTJsonPropTypeFloat:
        {
            typeCode = @encode(float);
            setBlock = ^(NTJsonModel *model, float value)
            {
                [self setValue:@(value) forProperty:property inModel:model];
            };
            getBlock = ^float(NTJsonModel *model)
            {
                return [[self getValueForProperty:property inModel:model] floatValue];
            };
            break;
        }
            
        case NTJsonPropTypeDouble:
        {
            typeCode = @encode(double);
            setBlock = ^(NTJsonModel *model, double value)
            {
                [self setValue:@(value) forProperty:property inModel:model];
            };
            getBlock = ^double(NTJsonModel *model)
            {
                return [[self getValueForProperty:property inModel:model] doubleValue];
            };
            break;
        }
            
        case NTJsonPropTypeLongLong:
        {
            typeCode = @encode(long long);
            setBlock = ^(NTJsonModel *model, long long value)
            {
                [self setValue:@(value) forProperty:property inModel:model];
            };
            getBlock = ^long long(NTJsonModel *model)
            {
                return [[self getValueForProperty:property inModel:model] longLongValue];
            };
            break;
        }
            
        case NTJsonPropTypeString:
        case NTJsonPropTypeStringEnum:
        case NTJsonPropTypeModel:
        case NTJsonPropTypeModelArray:
        case NTJsonPropTypeObject:
        case NTJsonPropTypeObjectArray:
        {
            typeCode = @encode(id);
            setBlock = ^(NTJsonModel *model, id value)
            {
                [self setValue:value forProperty:property inModel:model];
            };
            getBlock = ^id(NTJsonModel *model)
            {
                return [self getValueForProperty:property inModel:model];
            };
            break;
        }
            
        default:
            @throw [NSException exceptionWithName:@"NTJsonPropertyError" reason:[NSString stringWithFormat:@"Unexpected property type for %@.%@", NSStringFromClass(self.modelClass), property.name] userInfo:nil];
    }

    // Always add the getter...
    
    char getTypes[80];
    sprintf(getTypes, "%s@:", typeCode);
    IMP getImp = imp_implementationWithBlock(getBlock);
    SEL getSel = NSSelectorFromString(property.name);
    IMP getPrevImp = class_replaceMethod(self.modelClass, getSel, getImp, getTypes);
    
    if ( getPrevImp )
    {
        @throw [NSException exceptionWithName:@"NTJsonPropertyError"
                                       reason:[NSString stringWithFormat:@"An existing getter of an NTJsonModel property %@.%@ was found. Missing @dynamic?", NSStringFromClass(self.modelClass), property.name]
                                     userInfo:nil];
    }
    
    // Add setter if this is a read/write property...
    
    if ( !property.isReadOnly )
    {
        char setTypes[80];
        sprintf(setTypes, "v:@:%s", typeCode);
        IMP setImp = imp_implementationWithBlock(setBlock);
        SEL setSel = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [[property.name substringToIndex:1] uppercaseString], [property.name substringFromIndex:1]]);
        
        IMP setPrevImp = class_replaceMethod(self.modelClass, setSel, setImp, setTypes);
        
        if ( setPrevImp )
        {
            @throw [NSException exceptionWithName:@"NTJsonPropertyError"
                                           reason:[NSString stringWithFormat:@"An existing setter of an NTJsonModel property %@.%@ was found. Missing @dynamic?", NSStringFromClass(self.modelClass), property.name]
                                         userInfo:nil];
        }
    }
}


+(NSArray *)extractPropertiesForModelClass:(Class)modelClass
{
    unsigned int numProperties;
    objc_property_t *objc_properties = class_copyPropertyList(modelClass, &numProperties);
    
    NSMutableArray *properties = [NSMutableArray arrayWithCapacity:numProperties];
    
    for(unsigned int index=0; index<numProperties; index++)
    {
        objc_property_t objc_property = objc_properties[index];
        
        NTJsonProp *prop = [NTJsonProp propertyWithClass:modelClass objcProperty:objc_property];
        
        if ( prop )
            [properties addObject:prop];
    }
    
    free(objc_properties);
    
    return[properties copy];
}


+(NSDictionary *)findAllRelatedPropertiesIn:(NSArray *)properties
{
    // Build our array of related properties...
    
    NSMutableDictionary *allRelatedProperties = [NSMutableDictionary dictionary];
    
    for(NTJsonProp *prop in properties)
    {
        NSMutableArray *relatedProperties = nil;
        
        for (NTJsonProp *related in properties)
        {
            if ( prop == related )
                continue;
            
            if ( [related.jsonKey isEqualToString:prop.jsonKey] )
            {
                if ( !relatedProperties )
                    relatedProperties = [NSMutableArray array];
                
                [relatedProperties addObject:related];
            }
        }
        
        if ( relatedProperties )
            allRelatedProperties[prop.name] = [relatedProperties copy];
    }
  
    return [allRelatedProperties copy];
}


-(NSArray *)relatedPropertiesForProperty:(NTJsonProp *)prop
{
    return self.allRelatedProperties[prop.name];
}


-(void)validateRelatedProperties
{
    for (NTJsonProp *prop in self.properties.allValues)
    {
        if ( prop.isReadOnly )
            continue;
        
        NSArray *relatedProperties = [self relatedPropertiesForProperty:prop];
        
        if ( !relatedProperties.count )
            continue;
        
        NSMutableArray *readwriteNames = nil;
        
        for(NTJsonProp *related in relatedProperties)
        {
            if ( !related.isReadOnly )
            {
                if ( !readwriteNames )  // delay creating this unless there is actually an error
                    readwriteNames = [NSMutableArray arrayWithObject:prop.name];
                
                [readwriteNames addObject:related.name];
            }
        }
        
        if ( readwriteNames.count > 1 )
        {
            @throw [NSException exceptionWithName:@"NTJsonPropertyError"
                                           reason:[NSString stringWithFormat:@"Only one readwrite property may refer to the same jsonPath, consider making secondary properties read-only. Properties: %@(%@), JsonKey: %@", NSStringFromClass(self.modelClass), [readwriteNames componentsJoinedByString:@", "], prop.jsonKey]
                                         userInfo:nil];
        }
    }
}


-(instancetype)initWithModelClass:(Class)modelClass
{
    if ( (self=[super init]) )
    {
        _modelClass = modelClass;
        
        // start with properties from our superclass...
        
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        
        if ( self.superSupport )
            [properties addEntriesFromDictionary:self.superSupport.properties];
        
        // Add our properties and create the implementations for them...
        
        for(NTJsonProp *property in [self.class extractPropertiesForModelClass:self.modelClass])
        {
            [self addImpsForProperty:property];
            properties[property.name] = property;
        }
        
        _properties = [properties copy];
        
        // Get our related properties...
        
       _allRelatedProperties = [self.class findAllRelatedPropertiesIn:properties.allValues];
        
        // Now validate related properties...
        
        [self validateRelatedProperties];
     }
    
    return self;
}


#pragma mark - Properties


-(BOOL)modelClassForJsonOverridden
{
    if ( !_modelClassForJsonOverridden )
    {
        BOOL modelClassForJsonOverridden = NO;
        
        unsigned int count;
        Method *methods = class_copyMethodList(object_getClass(self.modelClass), &count);
        
        for(unsigned int index=0; index<count; index++)
        {
            SEL selector = method_getName(methods[index]);
            
            if ( selector == @selector(modelClassForJson:) )
            {
                modelClassForJsonOverridden = YES;
                break;
            }
        }
        
        free(methods);
        
        _modelClassForJsonOverridden = modelClassForJsonOverridden;
    }
    
    return _modelClassForJsonOverridden;
}


#pragma mark - default json


+(NSDictionary *)setValue:(id)value forKeyPath:(NSString *)keyPath inDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *newDictionary = (dictionary) ? [dictionary mutableCopy] : [NSMutableDictionary dictionary];
    
    NSUInteger dotPos = [keyPath rangeOfString:@"."].location;
    
    if ( dotPos != NSNotFound)
    {
        NSString *key = [keyPath substringToIndex:dotPos];
        NSString *remainingKeyPath = [keyPath substringFromIndex:dotPos+1];
        
        NSDictionary *nestedDictionary = [newDictionary objectForKey:key];
        
        if ( ![nestedDictionary isKindOfClass:[NSDictionary class]] )
            nestedDictionary = nil;
        
        newDictionary[key] = [self setValue:value forKeyPath:remainingKeyPath inDictionary:nestedDictionary];
    }
    else
        newDictionary[keyPath] = value;
    
    return [newDictionary copy];
}


-(NSDictionary *)defaultJsonWithParentClasses:(NSSet *)parentClasses
{
    
    parentClasses = (parentClasses) ? [parentClasses setByAddingObject:self.modelClass] : [NSSet setWithObject:self.modelClass];
    
    NSMutableDictionary *defaults = nil;
    
    for(NTJsonProp *prop in self.properties.allValues)
    {
        id defaultValue;
        
        if ( prop.type == NTJsonPropTypeModel ) // recursive here...
        {
            if ( [parentClasses containsObject:self.modelClass] ) // prevent infinite recursion if self referential
                defaultValue = nil;
            else
                defaultValue = [[prop.modelClass __ntJsonModelSupport] defaultJsonWithParentClasses:parentClasses]; // recursive
        }
        
        else
            defaultValue = prop.defaultValue;
        
        if ( defaultValue )
        {
            if ( !defaults )
                defaults = [NSMutableDictionary dictionary];
            
            if ( prop.remainingJsonKeyPath )
            {
                defaults[prop.jsonKey] = [self.class setValue:defaultValue forKeyPath:prop.remainingJsonKeyPath inDictionary:defaults[prop.jsonKey]];
            }
            else
                defaults[prop.jsonKey] = defaultValue;
        }
    }
    
    return [defaults copy];
}


-(NSDictionary *)defaultJson
{
    if ( !_defaultJson )
    {
        _defaultJson = [self defaultJsonWithParentClasses:nil] ?: (id)[NSNull null];
    }
    
    return (_defaultJson == (id)[NSNull null]) ? nil : _defaultJson;
}


#pragma mark - json calculation (mutable)


-(NSDictionary *)jsonForModel:(NTJsonModel *)model
{
    if ( !model.isMutable )
        return [model __json];
    
    NSMutableDictionary *json = [[model __json] mutableCopy];
    
    // todo: calculate any dynamic json bits and return...
    
    return [json copy];
}


#pragma mark - caching


-(id)getCacheValueForProperty:(NTJsonProp *)property inModel:(NTJsonModel *)model
{
    if ( property.shouldCache || model.isMutable )
    {
        id cachedValue = objc_getAssociatedObject(model, (__bridge void *)property);
        
        if ( cachedValue )
            return cachedValue;
    }
    
    return nil;
}


-(void)setCacheValue:(id)value forProperty:(NTJsonProp *)property inModel:(NTJsonModel *)model
{
    objc_setAssociatedObject(model, (__bridge void *)property, value, OBJC_ASSOCIATION_RETAIN);
}


#pragma mark - getValue


-(id)getValueForProperty:(NTJsonProp *)property inModel:(NTJsonModel *)model
{
    // get from cache, if it is present...
    
    id value = [self getCacheValueForProperty:property inModel:model];
    
    if ( value )
        return value;
    
    // grab the value from our json...
    
    id jsonValue = [model.json objectForKey:property.jsonKey];
    
    // if there's a jsonPath, walk it to get to the effective value...
    
    if ( property.remainingJsonKeyPath.length )
    {
        NSString *keyPath = property.remainingJsonKeyPath;
        
        while ( YES )
        {
            if ( ![jsonValue isKindOfClass:[NSDictionary class]] )
            {
                jsonValue = nil;
                break;
            }
            
            NSInteger dotPos = [keyPath rangeOfString:@"."].location;
            
            if ( dotPos == NSNotFound)  // the last part
            {
                jsonValue = [jsonValue objectForKey:keyPath];
                break;
            }
            
            NSString *key = [keyPath substringToIndex:dotPos];
            keyPath = [keyPath substringFromIndex:dotPos+1];
            
            jsonValue = [jsonValue objectForKey:key];
        }
    }
    
    // transform it, if needed...

    value = [property transformJsonValue:jsonValue];
    
    // save in cache, if there was any conversion or we had to parse a path...
    
    if ( value != jsonValue || property.remainingJsonKeyPath.length > 0 )
        [self setCacheValue:value forProperty:property inModel:model];
    
    return value;
}


#pragma mark - setValue


-(void)setValue:(id)value forProperty:(NTJsonProp *)prop inModel:(NTJsonModel *)model
{
    // todo
}


/***
 

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

***/

@end
