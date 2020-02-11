//
//  DetailViewController.h
//  theodoreMemo
//
//  Created by theodore on 2020/02/12.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Memo;

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (strong, nonatomic) Memo *memo;

@end

NS_ASSUME_NONNULL_END
