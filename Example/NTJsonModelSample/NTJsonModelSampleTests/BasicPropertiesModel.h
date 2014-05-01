//
//  BasicPropertiesModel.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/24/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel.h"


@interface BasicPropertiesModel : NTJsonModel

@property (nonatomic) int intProp;
@property (nonatomic) float floatProp;
@property (nonatomic) double doubleProp;
@property (nonatomic) NSString *stringProp;
@property (nonatomic) BOOL boolProp;

@property (nonatomic) UIColor *colorProp;
@property (nonatomic) UIColor *color2Prop;

@property (nonatomic) BasicPropertiesModel *childModel;

@property (nonatomic) NTJsonModelArray *modelArray;

@property (nonatomic) int nestedValue;

@end


