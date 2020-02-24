//
//  CustomTableViewCell.h
//  theodoreMemo
//
//  Created by theodore on 2020/02/23.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic, readwrite) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic, readwrite) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heartImage;

@end

NS_ASSUME_NONNULL_END
