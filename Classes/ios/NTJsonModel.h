//
//  NTJsonModel.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NTJsonProperty.h"
#import "NTJsonModelArray.h"


@interface NTJsonModel : NSObject

@property (nonatomic,readonly) NTJsonModel *rootModel;
@property (nonatomic) NSDictionary *json;
@property (nonatomic) NSMutableDictionary *mutableJson;

-(id)init;
-(id)initWithJson:(NSDictionary *)json;
+(instancetype)modelWithJson:(NSDictionary *)json;

-(id)initWithRootModel:(NTJsonModel *)rootModel json:(NSDictionary *)json;
-(id)initWithRootModel:(NTJsonModel *)rootModel mutableJson:(NSMutableDictionary *)mutableJson;

+(NSArray *)propertyInfo;

-(void)becomeMutable;

-(void)setRootModel:(NTJsonModel *)rootModel json:(NSDictionary *)json mutableJson:(NSMutableDictionary *)mutableJson;

@end

id NTJsonModel_mutableDeepCopy(id json);
