//
//  AppDelegate.m
//  theodoreMemo
//
//  Created by mobile-native on 31/01/2020.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "AppDelegate.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

-(void)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {

    // foreground 상태에서 받은 노티에 관한 delegate 설정
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setDelegate:self];

}

// foreground 상태에서 받은 노티에 관한 delegate override
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {

    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);

}


@end
