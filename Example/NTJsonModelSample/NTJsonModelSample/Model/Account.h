//
//  Account.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/9/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel.h"

@interface Account : NTJsonModel

@property (nonatomic) NSString *id;
@property (nonatomic) NSString *service;
@property (nonatomic) NSString *username;

@end
