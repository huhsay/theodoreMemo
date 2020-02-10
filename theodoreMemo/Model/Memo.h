//
// Created by theodore on 2020/02/10.
// Copyright (c) 2020 mobile-native. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Memo : NSObject

@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSDate* insertDate;
@property (strong, nonatomic, readonly, class) NSMutableArray *dummyMemoList;

- (instancetype)initWithContent:(NSString *)content;
@end
