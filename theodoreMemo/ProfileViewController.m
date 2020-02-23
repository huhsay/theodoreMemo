//
//  ProfileViewController.m
//  theodoreMemo
//
//  Created by theodore on 2020/02/23.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.profileImageView.layer.maskedCorners = YES;
    self.profileImageView.layer.cornerRadius = (self.profileImageView.frame.size.height / 2);
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
