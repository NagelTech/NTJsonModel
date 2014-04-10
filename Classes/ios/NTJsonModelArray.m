//
//  NTJsonModelArray.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/9/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel.h"


@interface NTJsonModelArray ()
{
    NTJsonModel *_rootModel;
    NTJsonProperty *_property;
    NSArray *_jsonArray;
    NSMutableArray *_mutableJsonArray;
    
    NSMutableDictionary *_valueCache;
}

@end


@implementation NTJsonModelArray


-(id)initWithRootModel:(NTJsonModel *)rootModel property:(NTJsonProperty *)property jsonArray:(NSArray *)jsonArray
{
    self = [super init];
    
    if ( self )
    {
        _rootModel = rootModel;
        _property = property;
        _jsonArray = jsonArray;
        _mutableJsonArray = nil;
    }
    
    return self;
}


-(id)initWithRootModel:(NTJsonModel *)rootModel property:(NTJsonProperty *)property mutableJsonArray:(NSMutableArray *)mutableJsonArray
{
    self = [super init];
    
    if ( self )
    {
        _rootModel = rootModel;
        _property = property;
        _mutableJsonArray = mutableJsonArray;
        _jsonArray = nil;
    }
    
    return self;
}


-(void)setRootModel:(NTJsonModel *)rootModel jsonArray:(NSArray *)jsonArray mutableJsonArray:(NSMutableArray *)mutableJsonArray;
{
    _rootModel = rootModel;
    _mutableJsonArray = mutableJsonArray;
    _jsonArray = jsonArray;
    
    if ( !_valueCache )
        return ;
    
    for(NSNumber *key in [_valueCache allKeys])
    {
        id value = _valueCache[key];
        
        if ( [value isKindOfClass:[NTJsonModel class]] )
        {
            int index = [key intValue];
            NTJsonModel *model = _valueCache[key];
            
            [model setRootModel:_rootModel json:_jsonArray[index] mutableJson:_mutableJsonArray[index]];
        }
    }
}


-(NSArray *)jsonArray
{
    return (_mutableJsonArray) ? _mutableJsonArray : _jsonArray;
}


-(NSUInteger)count
{
    return self.jsonArray.count;
}


-(id)objectAtIndex:(NSUInteger)index
{
    // see if we have already cached this value...
    
    if ( _valueCache )
    {
        id cachedObject = _valueCache[@(index)];
        
        if ( cachedObject )
            return cachedObject;
    }
    
    // get the value
    
    id jsonValue = self.jsonArray[index];
    
    // transform
    
    id value = jsonValue;
    
    if ( _property.type == NTJsonPropertyTypeModel )
    {
        if ( _mutableJsonArray )
            value = [[_property.typeClass alloc] initWithRootModel:_rootModel mutableJson:jsonValue];
        else
            value = [[_property.typeClass alloc] initWithRootModel:_rootModel json:jsonValue];
        
        // cache model values...
        
        if ( !_valueCache )
            _valueCache = [NSMutableDictionary dictionary];
        
        _valueCache[@(index)] = value;
    }

    return value;
}


-(id)ownValue:(id)value
{
    if ( [value isKindOfClass:[NTJsonModel class]] )
    {
        NTJsonModel *model = value;
        
        NSMutableDictionary *mutableJson = (model.mutableJson) ? model.mutableJson : NTJsonModel_mutableDeepCopy(model.json);

        [model setRootModel:self.rootModel json:nil mutableJson:mutableJson];

        return mutableJson;
    }
    
    else if ( [value isKindOfClass:[NTJsonModelArray class]] )
    {
        NTJsonModelArray *modelArray = value;
        
        NSMutableArray *mutableJsonArray = (modelArray.mutableJsonArray) ? modelArray.mutableJsonArray : NTJsonModel_mutableDeepCopy(modelArray.jsonArray);
        
        [modelArray setRootModel:_rootModel jsonArray:nil mutableJsonArray:mutableJsonArray];
        
        return mutableJsonArray;
    }
    
    else
        return value;
}


-(void)disownValue:(id)value
{
    if ( [value isKindOfClass:[NTJsonModel class]] )
    {
        NTJsonModel *model = value;
        
        if ( model.mutableJson )
            [model setRootModel:nil json:nil mutableJson:model.mutableJson];
        else
            [model setRootModel:nil json:model.json mutableJson:nil];
    }
    
    else if ( [value isKindOfClass:[NTJsonModelArray class]] )
    {
        NTJsonModelArray *modelArray = value;
        
        if ( modelArray.mutableJsonArray )
            [modelArray setRootModel:nil jsonArray:nil mutableJsonArray:modelArray.mutableJsonArray];
        else
            [modelArray setRootModel:nil jsonArray:modelArray.jsonArray mutableJsonArray:nil];
    }
}


-(void)insertObject:(id)value atIndex:(NSUInteger)index
{
    if ( !_mutableJsonArray )
        [_rootModel becomeMutable];
    
    // First, adjust our cache indexes...
    
    if ( _valueCache )
    {
        for(NSUInteger pos=_mutableJsonArray.count-1; pos>index; pos--)
        {
            NSNumber *key = @(pos);
            id value = _valueCache[key];
            
            if ( value )
            {
                NSNumber *newKey = @(pos+1);
                
                [_valueCache removeObjectForKey:key];
                _valueCache[newKey] = value;
            }
        }
    }
    
    if ( _property.isArray || _property.type == NTJsonPropertyTypeModel )
    {
        // Make it a part of our root model & mutable...
        
        id json = [self ownValue:value];

        // insert it into our array...
        
        [self.mutableJsonArray insertObject:json atIndex:index];
        
        if ( !_valueCache )
            _valueCache = [NSMutableDictionary dictionary];
        
        _valueCache[@(index)] = value;
    }
    
    else
    {
        // transform?
        
        // cache?
        
        [_mutableJsonArray insertObject:value atIndex:index];
    }
    
}


-(void)removeObjectAtIndex:(NSUInteger)index
{
    // todo validate ranges
    
    if ( !_mutableJsonArray )
        [_rootModel becomeMutable];

    // Update our value cache...
    
    if ( _valueCache )
    {
        // clean up any curently cached item...
        
        id currentValue = _valueCache[@(index)];
        
        if ( currentValue )
        {
            [self disownValue:currentValue];
            
            [_valueCache removeObjectForKey:@(index)];
        }
        
        // Shift all others down...
        
        for(NSUInteger pos=index; pos<_mutableJsonArray.count; pos++)
        {
            NSNumber *key = @(pos);
            id value = _valueCache[key];
            
            if ( value )
            {
                NSNumber *newKey = @(pos-1);
                
                [_valueCache removeObjectForKey:key];
                _valueCache[newKey] = value;
            }
        }
    }
    
    // Always remove from our array...
    
    [_mutableJsonArray removeObjectAtIndex:index];
}


-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)value
{
    // todo validate ranges
    
    if ( !_mutableJsonArray )
        [_rootModel becomeMutable];
    
    if ( _property.isArray || _property.type == NTJsonPropertyTypeModel )
    {
        // Make it a part of our root model & mutable...
        
        id json = [self ownValue:value];
        
        // insert it into our array...
        
        [self.mutableJsonArray replaceObjectAtIndex:index withObject:json];
        
        // add/update cache...
        
        if ( !_valueCache )
            _valueCache = [NSMutableDictionary dictionary];
        
        _valueCache[@(index)] = value;
    }
    
    else
    {
        // transform?
        
        // cache?
        
        [_mutableJsonArray replaceObjectAtIndex:index withObject:value];
    }
}


-(void)addObject:(id)anObject
{
    [self insertObject:anObject atIndex:self.count];
}


-(void)removeLastObject
{
    if ( !self.count )
        @throw [NSException exceptionWithName:NSRangeException reason:@"range exception" userInfo:nil];
    
    [self removeObjectAtIndex:self.count-1];
}


@end

