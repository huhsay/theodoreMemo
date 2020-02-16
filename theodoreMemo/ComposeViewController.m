//
// Created by theodore on 2020/02/11.
// Copyright (c) 2020 mobile-native. All rights reserved.
//

#import "ComposeViewController.h"
#import "DataManager.h"
#import "Memo+CoreDataProperties.h"
#import "Memo+CoreDataClass.h"


@implementation ComposeViewController {
}

- (void) dealloc {

    //옵저버 해제
   if (self.willShowToken) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.willShowToken];
    }

    if (self.willhideToken) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.willhideToken];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.memoTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.memoTextView resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    if ( self.editTarget != nil) {
        self.navigationItem.title = @"edit";
        self.memoTextView.text = self.editTarget.content;
    } else {
        self.navigationItem.title = @"new";
        self.memoTextView.text = @"";
    }

    self.willShowToken = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note ) {
        CGFloat height = [note.userInfo[UIKeyboardWillShowNotification] CGRectValue].size.height;

        UIEdgeInsets inset = self.memoTextView.contentInset;
        inset.bottom = height;
        self.memoTextView.contentInset = inset;

        inset = self.memoTextView.scrollIndicatorInsets;
        inset.bottom = height;
        self.memoTextView.scrollIndicatorInsets;
    }];

    self.willhideToken = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        UIEdgeInsets inset = self.memoTextView.contentInset;
        inset.bottom = 0;
        self.memoTextView.contentInset = inset;

        inset = self.memoTextView.scrollIndicatorInsets;
        inset.bottom = 0;
        self.memoTextView.scrollIndicatorInsets;
    }];
}

- (IBAction)save:(id)sender {
    NSString *memoString = self.memoTextView.text;

    if(self.editTarget != nil) {

        self.editTarget.content = memoString;
        [[DataManager sharedInstance] saveContext];
    } else {

        [[DataManager sharedInstance] addNewMemo:memoString];
    }


    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
