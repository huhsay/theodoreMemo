//
//  ProfileViewController.h
//  theodoreMemo
//
//  Created by theodore on 2020/02/23.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSString *documentsPath;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSArray *paths;
@end

NS_ASSUME_NONNULL_END
