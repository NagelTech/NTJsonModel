//
//  TestUser.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 11/10/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel.h"


@interface TUser : NTJsonModel

@property (nonatomic,readonly) NSString *firstName;
@property (nonatomic,readonly) NSString *lastName;
@property (nonatomic,readonly) int age;

@property (nonatomic,readonly) NSString *fullName;

@end


@protocol MutableTUser <NTJsonMutableModel>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) int age;

@property (nonatomic) NSString *fullName;

@end


typedef TUser<MutableTUser> MutableTUser;




