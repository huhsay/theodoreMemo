//
// Created by theodore on 2020/02/11.
// Copyright (c) 2020 mobile-native. All rights reserved.
//

#import "ComposeViewController.h"
#import "DataManager.h"
#import "Memo+CoreDataProperties.h"
#import "Memo+CoreDataClass.h"


#pragma clang diagnostic push
#pragma ide diagnostic ignored "ResourceNotFoundInspection"
@implementation ComposeViewController {
    __weak IBOutlet UIBarButtonItem *closeButton;
}
@synthesize fovoriteButton;

- (void) dealloc {
    // 키보드 옵져버 해제
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

    if (self.editTarget != nil && self.editTarget.favorite != 0) {
        self.fovoriteButton.image = [UIImage imageNamed:@"heart.fill"];
    }
}

- (IBAction)back:(id)sender {
    NSString *memoString = self.memoTextView.text;

    if (self.editTarget == nil) {
        // 새로운 메모를 작성할 때

        // 작성되어 있는 경우 데이터베이스 업데이트
        if(![memoString isEqualToString:@""]) {
        [[DataManager sharedInstance] addNewMemo:memoString];
        }
    } else if (self.editTarget.content != self.memoTextView.text) {
        // 메모가 변경되었을 때
        self.editTarget.content = memoString;
        // 코어 데이터 업데이트
        [[DataManager sharedInstance] saveContext];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    if(self.editTarget != nil) {
//
//        self.editTarget.content = memoString;
//        [[DataManager sharedInstance] saveContext];
//    } else {
//
//        [[DataManager sharedInstance] addNewMemo:memoString];
//    }

    [self.memoTextView resignFirstResponder];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([self isNewMemo]) {
        self.navigationItem.title = @"new";
        self.memoTextView.text = @"";
    } else {
        self.navigationItem.title = @"edit";
        self.memoTextView.text = self.editTarget.content;
    }

    // 키보드 관련
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
    
    // favorite button long tap
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

#pragma mark favorite button

- (IBAction)pressFavoriteButton:(id)sender {
    if(self.editTarget == nil) {
        // do nothing
    } else {
        
        if(self.editTarget.favorite !=0) {
            [self longPress];
        } else {
            self.fovoriteButton.image = [UIImage systemImageNamed:@"heart.fill"];
            // TODO: database favorite 키우는 작업;
        }
    }
}

- (void) longPress {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"취소" message:@"좋아요를 취소하시겠습니까?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"삭제" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.fovoriteButton.image = [UIImage systemImageNamed:@"heart"];
        
        // TODO: database 취소 작업
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"longPressGesture");
}


#pragma mark items

- (IBAction)deleteMemo:(id)sender {
    if ([self isNewMemo]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"삭제 확인" message:@"메모를 삭제하시겠습니까?" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"삭제" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action) {
            [[DataManager sharedInstance] deleteMemo:self.editTarget];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:okAction];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

- (IBAction)shareMemo:(id)sender {
    if ([self isChanged]){
        NSString *memo = self.memoTextView.text;

        UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:@[memo] applicationActivities:nil];
        [self presentViewController:vc animated:YES completion:nil];

        // 저장
        NSString *memoString = self.memoTextView.text;        self.editTarget.content = memoString;
        [[DataManager sharedInstance] saveContext];

    } else {
        if([self isNewMemo]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"메모를 작성하세요" message:@"빈 메모입니다. 새로운 메모를 작성하세요" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
            }];
            [alert addAction:okAction];

            [self presentViewController:alert animated:YES completion:nil];
        } else {
            NSString *memo = self.editTarget.content;
            UIActivityViewController *vc = [[UIActivityViewController alloc]initWithActivityItems:@[memo] applicationActivities:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

- (BOOL)isNewMemo {
    if( self.editTarget == nil)
        return YES;

    return NO;
}

- (BOOL) isChanged {

    if([self isNewMemo]) {
        if([self.memoTextView.text isEqualToString:@""])
            return NO;
        return YES;
    }

    if([self.editTarget.content isEqualToString:self.memoTextView.text]) {
        return NO;
    }

    return YES;
}

@end

#pragma clang diagnostic pop
