//
//  WebViewController.m
//  theodoreMemo
//
//  Created by theodore on 2020/02/18.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://plaync.com"]];
    [self.webView loadRequest:request];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
