//
//  AppDelegate.m
//  shoppinglist
//
//  Created by Eric Lanini on 3/3/16.
//  Copyright © 2016 Eric Lanini. All rights reserved.
//

#import "AppDelegate.h"
#import <LoopBack/LoopBack.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UITabBar *tabBar = ((UITabBarController*)[self.window.rootViewController.childViewControllers firstObject]).tabBar;
    
    UITabBarItem *item = [tabBar.items objectAtIndex:0];
    UIImage *selectedImage = [UIImage imageNamed:@"nec-tab-sel"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *unselectedImage = [UIImage imageNamed:@"nec-tab"];
    unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setImage:unselectedImage];
    [item setSelectedImage:selectedImage];

    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
    selectedImage = [UIImage imageNamed:@"opt-tab-sel"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    unselectedImage = [UIImage imageNamed:@"opt-tab"];
    unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item2 setImage:unselectedImage];
    [item2 setSelectedImage:selectedImage];


    //    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
//    UITabBar *tabBar = (UITabBar*)tabController.tabBar;
//    
//    UITabBarItem *item1 = [tabBar.items objectAtIndex:0];
//    UIImage *selectedImage = [UIImage imageNamed:@"nec-tab-image"];
//    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *unselectedImage = [UIImage imageNamed:@"nec-tab-image"];
//    unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [item1 setImage:unselectedImage];
//    [item1 setSelectedImage:selectedImage];

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
