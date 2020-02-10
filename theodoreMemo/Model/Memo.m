//
// Created by theodore on 2020/02/10.
// Copyright (c) 2020 mobile-native. All rights reserved.
//

#import "Memo.h"


@implementation Memo
static NSMutableArray *_dummyMemoList = nil;

- (instancetype)initWithContent:(NSString *)content {
    self = [super init];
    if (self != nil) {
        self.content = content;
        self.insertDate = [NSDate date];
    }
    return self;
}

+ (NSMutableArray *)dummyMemoList {

    if (_dummyMemoList == nil) {
        Memo *memo1 = [[Memo alloc] initWithContent:@"dummy data 001"];
        Memo *memo2 = [[Memo alloc] initWithContent:@"dummy data 002"];

        _dummyMemoList = [@[memo1, memo2] mutableCopy];
    }

    return _dummyMemoList;
}

@end