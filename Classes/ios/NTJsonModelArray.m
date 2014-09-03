//
//  NTJsonModelArray.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/9/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel+Private.h"


@interface NTJsonModelArrayEmptyElement : NSObject

+(id)emptyElement;

@end



@interface NTJsonModelArray ()
{
    Class _modelClass;
    NTJsonProp *_property;
    id _jsonArray;
    
    NSMutableArray *_valueCache;
}

@property (nonatomic,readonly) BOOL isModel;
@property (nonatomic,readonly) Class typeClass;

@end


@implementation NTJsonModelArrayEmptyElement


+(id)emptyElement
{
    static NTJsonModelArrayEmptyElement *emptyElement = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        emptyElement = [[NTJsonModelArrayEmptyElement alloc] init];
    });
    
    return emptyElement;
}


@end


@implementation NTJsonModelArray


#pragma mark - Initialization


-(id)initWithModelClass:(Class)modelClass jsonArray:(NSArray *)jsonArray
{
    self = [super init];
    
    if ( self )
    {
        _modelClass = modelClass;
        _jsonArray = jsonArray;
        _valueCache = nil;
    }
    
    return self;
}


-(id)initWithProperty:(NTJsonProp *)property jsonArray:(NSArray *)jsonArray
{
    self = [super init];
    
    if ( self )
    {
        _property = property;
        _valueCache = nil;
    }
    
    return self;
}


#pragma mark - Properties


-(NSArray *)jsonArray
{
    return _jsonArray;
}


-(BOOL)isModel
{
    if ( _property )
        return (_property.type == NTJsonPropTypeModelArray) ? YES : NO;
    else
        return YES;
}


-(Class)modelClass
{
    if ( _modelClass )
        return _modelClass;
    else
        return (_property.type == NTJsonPropTypeModelArray) ? _property.typeClass : Nil;
}


-(Class)typeClass
{
    return (_modelClass) ? _modelClass : _property.typeClass;
}


#pragma mark - cache support


-(id)cachedObjectAtIndex:(NSUInteger)index
{
    if ( !_valueCache )
        return nil; // nothing in the cache here
    
    if ( index >= _valueCache.count )
        return nil; //past the end of what we have cached
    
    id value = _valueCache[index];
    
    return (value == [NTJsonModelArrayEmptyElement emptyElement] ? nil : value);
}


-(void)ensureCacheSize:(NSUInteger)size
{
    if ( !_valueCache )
        _valueCache = [NSMutableArray arrayWithCapacity:size];
    
    while ( _valueCache.count < size )
        [_valueCache addObject:[NTJsonModelArrayEmptyElement emptyElement]];
}


#pragma mark - NSCopying, NSMutableCopying


-(id)copyWithZone:(NSZone *)zone
{
    return self;    // it's already immutable
}


-(id)mutableCopyWithZone:(NSZone *)zone
{
    return [NSMutableArray arrayWithArray:self];
}


#pragma mark - NSArray overrides


-(NSUInteger)count
{
    return self.jsonArray.count;
}


-(id)objectAtIndex:(NSUInteger)index
{
    // Grab from the cache if it exists...
    
    id value = [self cachedObjectAtIndex:index];
    
    if ( value )
        return value;
    
    id jsonValue = self.jsonArray[index];
    
    if ( self.isModel )
    {
        // handle NSNulls or invalid types right away
        
        if ( ![jsonValue isKindOfClass:[NSDictionary class]] )
            return [NSNull null];
        
        // transform

        value = [[self.modelClass alloc] initWithJson:jsonValue];
    }
    else
    {
        value = [_property convertJsonToValue:jsonValue];
    }
    
    // cache...
    
    [self ensureCacheSize:index];
    _valueCache[index] = value;
    
    return value;
}


@end


