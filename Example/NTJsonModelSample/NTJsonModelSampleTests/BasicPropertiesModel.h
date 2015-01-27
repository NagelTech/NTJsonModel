//
//  BasicPropertiesModel.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/24/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel.h"


@protocol BasicPropertiesModel <NSObject>
@end


@interface UIColor (BasicPropertiesModel) <NTJsonPropertyConversion>

+(id)convertJsonToValue:(id)json;
+(id)convertValueToJson:(id)value;

@end

@interface BasicPropertiesModel : NTJsonModel

@property (nonatomic) int intProp;
@property (nonatomic) float floatProp;
@property (nonatomic) double doubleProp;
@property (nonatomic) NSString *stringProp;
@property (nonatomic) BOOL boolProp;

@property (nonatomic) UIColor *colorProp;
@property (nonatomic) UIColor *color2Prop;
@property (nonatomic) UIColor *color3Prop;

@property (nonatomic) BasicPropertiesModel *childModel;

@property (nonatomic) NSArray *modelArray;
@property (nonatomic) NSArray *objectArray;
@property (nonatomic,readonly) NSArray *objectArrayStrings;

@property (nonatomic,readonly) int nestedValue;

+(id)convertColor2PropToJson:(UIColor *)value;
+(UIColor *)convertJsonToColor2Prop:(NSDictionary *)json;

+(void)setNamedColor:(UIColor *)color withName:(NSString *)name;

+(id)convertColor3PropToJson:(UIColor *)value;
+(UIColor *)convertJsonToColor3Prop:(NSString *)json;
+(BOOL)validateCachedColor3Prop:(UIColor *)value forJson:(NSString *)json;

@end


