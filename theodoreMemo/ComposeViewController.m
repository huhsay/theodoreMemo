//
// Created by theodore on 2020/02/11.
// Copyright (c) 2020 mobile-native. All rights reserved.
//

#import "ComposeViewController.h"
#import "DataManager.h"
#import "Memo+CoreDataProperties.h"
#import "Memo+CoreDataClass.h"
#import <Lottie/Lottie.h>


#pragma clang diagnostic push
#pragma ide diagnostic ignored "ResourceNotFoundInspection"
@implementation ComposeViewController

@synthesize fovoriteButton;

- (void) dealloc {
    // 키보드 옵져버 해제
    if (self.willShowToken) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.willShowToken];
    }

    if (self.willHideToken) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.willHideToken];
    }
}

#pragma mark - life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if ([self isNewMemo]) {
        self.navigationItem.title = @"new";
        self.memoTextView.text = @"";
    } else {
        self.navigationItem.title = @"edit";
        self.memoTextView.text = self.editTarget.content;
    }
    
    [self.memoTextView endEditing:YES];

    // 키보드 관련
    self.willShowToken = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note ) {

        CGFloat height = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        UIEdgeInsets inset = self.memoTextView.contentInset;
        inset.bottom = height;
        self.memoTextView.contentInset = inset;

        inset = self.memoTextView.verticalScrollIndicatorInsets;
        inset.bottom = height;
        self.memoTextView.verticalScrollIndicatorInsets = inset;
    }];

    self.willHideToken = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        UIEdgeInsets inset = self.memoTextView.contentInset;
        inset.bottom = 0;
        self.memoTextView.contentInset = inset;

        inset = self.memoTextView.verticalScrollIndicatorInsets;
        inset.bottom = 0;
        self.memoTextView.scrollIndicatorInsets = inset;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.memoTextView becomeFirstResponder];

    if (self.editTarget != nil && self.editTarget.favorite != 0) {
        self.fovoriteButton.image = [UIImage systemImageNamed:@"heart.fill"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.memoTextView resignFirstResponder];
}

#pragma mark items

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

- (IBAction)pressFavoriteButton:(id)sender {
    if(self.editTarget == nil) {
        // do nothing
    } else {
        if(self.editTarget.favorite !=0) {
            self.fovoriteButton.image = [UIImage systemImageNamed:@"heart"];
            self.editTarget.favorite--;
            [[DataManager sharedInstance] saveContext];
        } else {
            self.fovoriteButton.image = [UIImage systemImageNamed:@"heart.fill"];
            [self playHeartLottie];
            self.editTarget.favorite ++;
            [[DataManager sharedInstance] saveContext];
        }
    }
}

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
            //do nothing
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

# pragma mark - member method

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

- (void)playHeartLottie {
    LOTAnimationView *animation1 = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://assets7.lottiefiles.com/temp/lf20_FuXRuT.json"]];
    animation1.contentMode = UIViewContentModeScaleAspectFit;
    animation1.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:animation1];
    [animation1 playWithCompletion:^(BOOL animationFinished) {
        [animation1 removeFromSuperview];
    }];
    
    animation1.loopAnimation = NO;
    
    LOTAnimationView *animation2 = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://assets1.lottiefiles.com/packages/lf20_TuxDyk.json"]];
    animation2.contentMode = UIViewContentModeScaleAspectFit;
    animation2.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:animation2];
    [animation2 playWithCompletion:^(BOOL animationFinished) {
        [animation2 removeFromSuperview];
    }];
    
    animation2.loopAnimation = NO;
}

@end

#pragma clang diagnostic pop
