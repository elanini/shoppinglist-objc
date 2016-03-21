//
//  AppDelegate.m
//  shoppinglist
//
//  Created by Eric Lanini on 3/3/16.
//  Copyright © 2016 Eric Lanini. All rights reserved.
//

#import "AppDelegate.h"
#import "SLTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)changeViewController:(UIEvent*)event
{
    NSLog(@"changing vc");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //set up the view controllers programmatically, because it makes more sense this way. tabbarcontroller is the rootviewcontroller in storyboard.
//    UITabBarController *tbc = (UITabBarController*)self.window.rootViewController;
//    
//    
//    //create and initialize two view controllers, one for optional and one for necessary, and add the plus buttons
//    SLTableViewController *vc1 = [[SLTableViewController alloc] init];
//    vc1.title = @"Necessary";
//    vc1.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:vc1 action:@selector(myRightButton)];
//    SLTableViewController *vc2 = [[SLTableViewController alloc] init];
//    vc2.title = @"Optional";
//    vc2.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:vc2 action:@selector(myRightButton)];
//    
//    
//    UINavigationController *navc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
//    UINavigationController *navc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
//
//    
//    tbc.viewControllers = [NSArray arrayWithObjects:navc1, navc2,nil];
//
//    //initialize tab bar images
//    UITabBar *tabBar = tbc.tabBar;
//    UITabBarItem *item = [tabBar.items objectAtIndex:0];
//    UIImage *selectedImage = [UIImage imageNamed:@"nec-tab-sel"];
//    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *unselectedImage = [UIImage imageNamed:@"nec-tab"];
//    unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [item setImage:unselectedImage];
//    [item setSelectedImage:selectedImage];
//
//    UITabBarItem *item2 = [tabBar.items objectAtIndex:1];
//    selectedImage = [UIImage imageNamed:@"opt-tab-sel"];
//    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    unselectedImage = [UIImage imageNamed:@"opt-tab"];
//    unselectedImage = [unselectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [item2 setImage:unselectedImage];
//    [item2 setSelectedImage:selectedImage];

//    UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
//    UISegmentedControl *segControl = (UISegmentedControl*)[nav.navigationBar.subviews lastObject];
//    [segControl addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventValueChanged];

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
