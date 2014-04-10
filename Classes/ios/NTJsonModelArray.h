//
//  NTJsonModelArray.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/9/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NTJsonModel;

@interface NTJsonModelArray : NSMutableArray

@property (nonatomic) NTJsonModel *rootModel;
@property (nonatomic) NSArray *jsonArray;
@property (nonatomic) NSMutableArray *mutableJsonArray;

-(id)initWithRootModel:(NTJsonModel *)rootModel property:(NTJsonProperty *)property jsonArray:(NSArray *)jsonArray;
-(id)initWithRootModel:(NTJsonModel *)rootModel property:(NTJsonProperty *)property mutableJsonArray:(NSMutableArray *)mutableJsonArray;

-(void)setRootModel:(NTJsonModel *)rootModel jsonArray:(NSArray *)jsonArray mutableJsonArray:(NSMutableArray *)mutableJsonArray;


@end
