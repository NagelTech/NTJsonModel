//
//  BasicPropertiesModel.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/24/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "BasicPropertiesModel.h"


@implementation BasicPropertiesModel


NTJsonProperty(intProp)
NTJsonProperty(floatProp)
NTJsonProperty(doubleProp)
NTJsonProperty(stringProp)
NTJsonProperty(boolProp)
NTJsonProperty(colorProp)
NTJsonProperty(color2Prop)
NTJsonProperty(color3Prop)
NTJsonProperty(childModel)
NTJsonProperty(modelArray)

NTJsonProperty(objectArray, elementType=[UIColor class])
NTJsonProperty(objectArrayStrings, jsonPath="objectArray")

NTJsonProperty(nestedValue, jsonPath="nested.value")


+(id)convertColor2PropToJson:(UIColor *)value
{
    const CGFloat *color = CGColorGetComponents(value.CGColor);

    return @{@"r": @(color[0]), @"g": @(color[1]), @"b": @(color[2])};
}


+(UIColor *)convertJsonToColor2Prop:(NSDictionary *)json
{
    if ( ![json isKindOfClass:[NSDictionary class]] )
        return nil;
    
    return [UIColor colorWithRed:[json[@"r"] floatValue] green:[json[@"g"] floatValue] blue:[json[@"b"] floatValue] alpha:1.0];
}


static NSMutableDictionary *sNamedColors;


+(void)setNamedColor:(UIColor *)color withName:(NSString *)name
{
    if ( !sNamedColors )
        sNamedColors = [NSMutableDictionary dictionary];

    if ( color )
        sNamedColors[name] = color;
    else
        [sNamedColors removeObjectForKey:name];
}


+(id)convertColor3PropToJson:(UIColor *)value
{
    __block NSString *json = nil;

    [sNamedColors enumerateKeysAndObjectsUsingBlock:^(NSString *name, UIColor *color, BOOL *stop) {
        if ([color isEqual:value] )
        {
            json = name;
            *stop = YES;
        }
    }];

    return json;
}


+(UIColor *)convertJsonToColor3Prop:(NSString *)json
{
    return sNamedColors[json];
}


+(id)validateCachedColor3Prop:(UIColor *)value forJson:(NSString *)json
{
    return nil;  // cache is never valid.
}


@end



@implementation UIColor (BasicPropertiesModel)


+(id)convertValueToJson:(UIColor *)value
{
    if ( CGColorGetNumberOfComponents(value.CGColor) != 4 )
        return nil; // this will catch colors that are in a strange space or something
    
    const CGFloat *color = CGColorGetComponents(value.CGColor);
    
    int r = (int)(color[0]*255.0);
    int g = (int)(color[1]*255.0);
    int b = (int)(color[2]*255.0);
    
    return [NSString stringWithFormat:@"#%02X%02X%02X", r, g, b];
}


+(id)convertJsonToValue:(id)json
{
    unsigned int hexValue;
    
    if ( [json isKindOfClass:[NSString class]] )
    {
        NSCharacterSet * characterSet = [NSCharacterSet characterSetWithCharactersInString:@"#"];
        NSScanner * scanner = [NSScanner scannerWithString:json];
        [scanner setCharactersToBeSkipped:characterSet];
        [scanner scanHexInt:&hexValue];
        
        if ( !scanner.isAtEnd )
            return nil;
    }
    
    else if ( [json isKindOfClass:[NSNumber class]] )
        hexValue = [json unsignedIntValue];
    
    else
        return nil;
    
    int b = (hexValue & 0x0000FF) >> 0;
    int g = (hexValue & 0x00FF00) >> 8;
    int r = (hexValue & 0xFF0000) >> 16;
    
    return [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0];
}


@end
