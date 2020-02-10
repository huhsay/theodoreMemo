//
// Created by theodore on 2020/02/11.
// Copyright (c) 2020 mobile-native. All rights reserved.
//

#import "ComposeViewController.h"
#import "Memo.h"


@implementation ComposeViewController {

    IBOutlet UITextView *memoTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)save:(id)sender {
    NSString *memo = memoTextView.text;

    Memo *newMemo = [[Memo alloc] initWithContent:memo];
    [[Memo dummyMemoList] addObject:newMemo];

    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
