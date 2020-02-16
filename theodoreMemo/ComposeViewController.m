//
// Created by theodore on 2020/02/11.
// Copyright (c) 2020 mobile-native. All rights reserved.
//

#import "ComposeViewController.h"
#import "DataManager.h"
#import "Memo+CoreDataProperties.h"
#import "Memo+CoreDataClass.h"


@implementation ComposeViewController {

    IBOutlet UITextView *memoTextView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ( self.editTarget != nil) {
        self.navigationItem.title = @"edit";
        memoTextView.text = self.editTarget.content;
    } else {
        self.navigationItem.title = @"new";
        memoTextView.text = @"";
    }
}
- (IBAction)save:(id)sender {
    NSString *memoString = memoTextView.text;
    [[DataManager sharedInstance] addNewMemo:memoString];


    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
