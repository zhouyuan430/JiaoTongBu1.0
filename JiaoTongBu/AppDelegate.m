//
//  AppDelegate.m
//  JiaoTongBu
//
//  Created by zhouyuan on 14-4-10.
//  Copyright (c) 2014年 zhouyuan. All rights reserved.
//

#import "AppDelegate.h"
#import "CommenData.h"

static NSString* const KAssetsListPlist = @"AssetsList.plist";
static NSString* const KContactInfoPlist = @"ContactInfo.plist";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"55");
    if ([[CommenData mainShare] isExistsFile:KAssetsListPlist]) {
        [[CommenData mainShare] DeleteFile:KAssetsListPlist];
    }
    if ([[CommenData mainShare] isExistsFile:KContactInfoPlist]) {
        [[CommenData mainShare] DeleteFile:KContactInfoPlist];
    }
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"44");

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"33");

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"22");

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
 
    NSLog(@"11");
    if ([[CommenData mainShare] isExistsFile:KAssetsListPlist]) {
        [[CommenData mainShare] DeleteFile:KAssetsListPlist];
    }
    if ([[CommenData mainShare] isExistsFile:KContactInfoPlist]) {
        [[CommenData mainShare] DeleteFile:KContactInfoPlist];
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
