//
//  NTJsonModel.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <objc/runtime.h>

#import "NTJsonModel+Private.h"

#import "__NTJsonModelSupport.h"


@interface NTJsonModel () <NTJsonMutableModel>
{
    id _json;
    BOOL _isMutable;
}


-(id)initWithJson:(NSDictionary *)json mutable:(BOOL)isMutable;


@end


@implementation NTJsonModel


#pragma mark - One-time initialization


+(__NTJsonModelSupport *)__ntJsonModelSupport
{
    return objc_getAssociatedObject(self, @selector(__ntJsonModelSupport));
}


+(void)initialize
{
    if ( ![self __ntJsonModelSupport] )
    {
        // The init call here does all initialization, including adding property getter/setters.
        // If it fails, an exception will be thrown.
        
        __NTJsonModelSupport *support = [[__NTJsonModelSupport alloc] initWithModelClass:self];
        
        if ( !support ) // unlikely, but just in case...
            @throw [NSException exceptionWithName:@"NTJsonPropertyError" reason:@"Unknown error initializing NTJsonModel class" userInfo:nil];
        
        objc_setAssociatedObject(self, @selector(__ntJsonModelSupport), support, OBJC_ASSOCIATION_RETAIN);
        
        return ;
    }
}


#pragma mark - Constructors


+(Class)modelClassForJson:(NSDictionary *)json
{
    return self;
}


-(id)initWithJson:(NSDictionary *)json mutable:(BOOL)isMutable
{
    __NTJsonModelSupport *support = [self.class __ntJsonModelSupport];

    if ( json && !isMutable && support.modelClassForJsonOverridden )
    {
        Class modelClass = [self.class modelClassForJson:json];

        if ( modelClass != self.class )
        {
            if ( ![modelClass isSubclassOfClass:self.class] )
            {
                @throw [NSException exceptionWithName:@"NTJsonModelNotSubclass"
                                               reason:[NSString stringWithFormat:@"NTJsonModel cannot create instance of %@ returned by modelClassForJson because it is not a subclass of %@", NSStringFromClass(modelClass), NSStringFromClass(self.class)]
                                             userInfo:nil];
            }
            
            return [[modelClass alloc] initWithJson:json mutable:isMutable];
        }
    }
    
    if ( isMutable != support.isMutableClass )   // if mutability is different between request and actual class
    {
        if ( support.isPairedClass )
            return [[support.pairedModelClass alloc] initWithJson:json mutable:isMutable];
    }
    
    // Ok, we are here, so it means we need to actually instantiate this guy...
    
    if ( (self = [super init]) )
    {
        _json = (isMutable) ? [json mutableCopy] ?: [NSMutableDictionary dictionary]
                            : [json copy] ?: [NSDictionary dictionary];
        _isMutable = isMutable;
    }
    
    return self;
}


-(id)init
{
    return [self initWithJson:nil mutable:[self.class __ntJsonModelSupport].isMutableClass && [self.class __ntJsonModelSupport].isPairedClass];
}


-(id)initWithJson:(NSDictionary *)json
{
    return [self initWithJson:json mutable:[self.class __ntJsonModelSupport].isMutableClass && [self.class __ntJsonModelSupport].isPairedClass];
}


-(id)initWithMutationBlock:(void (^)(id mutable))mutationBlock
{
    NTJsonModel *mutable = [self initMutable];
    
    if ( mutable )
        mutationBlock(mutable);
    
    return [mutable copy];
}


-(id)initMutable
{
    return [self initWithJson:nil mutable:YES];
}


-(id)initMutableWithJson:(NSDictionary *)json
{
    return [self initWithJson:json mutable:YES];
}


+(id)modelWithJson:(NSDictionary *)json
{
    if ( ![json isKindOfClass:[NSDictionary class]] )
        return nil;
    
    return [[self alloc] initWithJson:json];
}


+(id)modelWithMutationBlock:(void (^)(id mutable))mutationBlock
{
    return [[self alloc] initWithMutationBlock:mutationBlock];
}


+(id)mutableModelWithJson:(NSDictionary *)json
{
    if ( ![json isKindOfClass:[NSDictionary class]] )
        return nil;
    
    return [[self alloc] initMutableWithJson:json];
}


-(id)mutate:(void (^)(id mutable))mutationBlock
{
    NTJsonModel *mutable = [self mutableCopy];
    
    mutationBlock(mutable);
    
    return [mutable copy];
}


#pragma mark - Array Helpers


+(NSArray *)arrayWithJsonArray:(NSArray *)jsonArray
{
    if ( ![jsonArray isKindOfClass:[NSArray class]] )
        return nil;
    
    return [[NTJsonModelArray alloc] initWithModelClass:self json:jsonArray];
}


+(NSMutableArray *)mutableArrayWithJsonArray:(NSArray *)jsonArray
{
    if ( ![jsonArray isKindOfClass:[NSArray class]] )
        return nil;

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:jsonArray.count];
    
    for(NSDictionary *json in jsonArray)
        [array addObject:[[self alloc] initMutableWithJson:json]];
    
    return array;
}


#pragma mark - Properties


+(BOOL)modelClassForJsonOverridden
{
    return [self __ntJsonModelSupport].modelClassForJsonOverridden;
}


+(NSDictionary *)defaultJson
{
    return [self __ntJsonModelSupport].defaultJson;
}


-(id)__json
{
    return _json;
}


-(NSDictionary *)asJson
{
    return [_json copy];
}


#pragma mark - NSCopying & NSMutableCopying


-(id)mutableCopyWithZone:(NSZone *)zone
{
    return [[self.class alloc] initWithJson:[self asJson] mutable:YES];
}


-(id)copyWithZone:(NSZone *)zone
{
    if ( !self.isMutable )
        return self;
    
    return [[self.class alloc] initWithJson:[self asJson] mutable:NO];
}


#pragma mark - Equality & hash


-(BOOL)isEqualToModel:(NTJsonModel *)model
{
    if ( model == self )
        return YES;
    
    return [self->_json isEqualToDictionary:model->_json];
}


-(BOOL)isEqual:(id)object
{
    if ( object == self )
        return YES;
    
    if ( ![object isKindOfClass:self.class] )  // or do we compare to self.class?
        return NO;
    
    return [self isEqualToModel:object];
}


-(NSUInteger)hash
{
    return [_json hash];  // NSDictionary hash sucks, maybe we should try a little harder here?
}


#pragma mark - description


-(NSString *)description
{
    return [[self.class __ntJsonModelSupport] descriptionForModel:self fullDescription:NO parentModels:@[]];
}


-(NSString *)fullDescription
{
    return [[self.class __ntJsonModelSupport] descriptionForModel:self fullDescription:YES parentModels:@[]];
}


@end



