//
//  ViewController.m
//  theodoreMemo
//
//  Created by mobile-native on 31/01/2020.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import "MemoListTableViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIStackView *loginButtonStackView;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupProviderLoginView];
}

- (void) setupProviderLoginView {
    ASAuthorizationAppleIDButton *appleLoginButton = [ASAuthorizationAppleIDButton new];
    [appleLoginButton addTarget:self action:@selector(handleAuthorizationAppleIDButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButtonStackView addArrangedSubview:appleLoginButton];
    
}

- (void)handleAuthorizationAppleIDButtonPress {
    NSLog(@"handleAuthorizationAppleIDButtonPress");
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
    request.requestedScopes = @[NSFullUserName(), ASAuthorizationScopeEmail];

    ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    authorizationController.delegate = self;
    authorizationController.presentationContextProvider = self;
    [authorizationController performRequests];
}


#pragma mark - ASAuthorizationControllerDelegate
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    NSLog(@"didCompleteWithAuth");
    
    ASAuthorizationAppleIDCredential *credential = authorization.credential;
    NSData *authorizationCodeData = credential.authorizationCode;
    NSString *authorizationCode = [[NSString alloc] initWithData:authorizationCodeData encoding:NSUTF8StringEncoding];
    NSString *userID = credential.user;
    NSString *fullName = credential.fullName;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
    vc.selectedIndex = 1;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
    
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    NSLog(@"didCompleteWitherror error is %@:", error.description);
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding

- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
{
    return self.view.window;
}

@end
