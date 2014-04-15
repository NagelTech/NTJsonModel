//
//  NTJsonModelContainer.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NTJsonModelContainer <NSObject>

@property (nonatomic,readonly) id<NTJsonModelContainer> parentContainer;
@property (nonatomic,readonly) BOOL isReadonly;

-(void)becomeMutable;
-(void)detachChildModel:(NTJsonModel *)model;   // remove this item from this container

@end
