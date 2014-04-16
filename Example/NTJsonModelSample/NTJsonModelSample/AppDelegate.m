//
//  AppDelegate.m
//  NTJsonModelSample
//
//  Created by Ethan Nagel on 4/8/14.
//  Copyright (c) 2014 NagelTech. All rights reserved.
//

#import "AppDelegate.h"

#import "User.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    NSDictionary *json =
    @{
      @"id": @(12),
      @"first_name": @"Ethan",
      @"last_name": @"Nagel",
      @"age": @(42),
      
      @"account":
        @{
              @"service": @"yahoo",
              @"user_name": @"eanagel",
        },
      
      @"accounts":
          @[
              @{
                  @"service": @"gmail",
                  @"user_name": @"eanagel",
                },
              @{
                  @"service": @"MSN",
                  @"user_name": @"mad_dog",
                },
              @{
                  @"service": @"aol.com",
                  @"user_name": @"jimmy",
                },
            ],
      
      };
    
    User *user = [User modelWithJson:json];
    
    user = [user mutableCopy];
    
    for(Account *account in user.accounts)
        NSLog(@"account: %@ - %@", account.service, account.username);
    
    Account *msn = user.accounts[1];
    
    msn.service = @"Mutated!";

    for(Account *account in user.accounts)
        NSLog(@"account: %@ - %@", account.service, account.username);

/**
    
    NSLog(@"First Name: %@", user.firstName);
    
    NSLog(@"account.username = %@", user.account.username);
    
    // mutate
    
    Account *newAccount = [[Account alloc] init];
    
    newAccount.service = @"outlook.com";
    newAccount.username = @"enagel@nageltech.com";
    
    user.account = newAccount;
    
    user.account.username = @"NEW USERNAME";
    
    NSLog(@"mutated account.username = %@", user.account.username);
    
    user.firstName = @"Nathan";
    
    NSLog(@"Mutated First Name: %@", user.firstName);
    
    NSLog(@"Age: %d", user.age);
    
    ++user.age;
    
    NSLog(@"Mutated age: %d", user.age);
    
    NSLog(@"account.username = %@", user.account.username);
 
*/
 
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
