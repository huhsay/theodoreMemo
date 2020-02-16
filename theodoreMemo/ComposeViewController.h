//
// Created by theodore on 2020/02/11.
// Copyright (c) 2020 mobile-native. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Memo;


@interface ComposeViewController : UIViewController
- (IBAction)close:(id)sender;


@property (strong, nonatomic) IBOutlet UITextView *memoTextView;

@property (strong, nonatomic) Memo *editTarget;
@property (strong, nonatomic) id willShowToken;
@property (strong, nonatomic) id willhideToken;
@end
