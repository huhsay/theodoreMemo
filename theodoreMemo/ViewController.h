//
//  ViewController.h
//  theodoreMemo
//
//  Created by mobile-native on 31/01/2020.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AuthenticationServices/AuthenticationServices.h>

static NSString *const HJLoginIdentifier = @"LoginData";

@interface ViewController : UIViewController <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>


@end

