//
//  User.h
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "NTJsonModel.h"

#import "Account.h"

@protocol SampleProtocol <NSObject>
@end


@interface User : NTJsonModel

@property (nonatomic) NSString *id;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) int age;
@property (nonatomic) Account *account;
@property (nonatomic) NSMutableArray<Account,SampleProtocol> *accounts;

@end
