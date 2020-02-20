//
//  ViewController.m
//  theodoreMemo
//
//  Created by mobile-native on 31/01/2020.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:@[@1,@2,@3] completionHandler:^(BOOL granted, NSError * _Nullable error) {
        // nothing
    }];
}


@end
