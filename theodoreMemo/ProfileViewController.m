//
//  ProfileViewController.m
//  theodoreMemo
//
//  Created by theodore on 2020/02/23.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import "ProfileViewController.h"
#import "DataManager.h"
#import "KeychainItemWrapper.h"

@interface ProfileViewController ()
- (IBAction)presentPhotoLibrary:(id)sender;
- (IBAction)logout:(id)sender;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *memoCountTextField;
@property (weak, nonatomic) IBOutlet UILabel *favoritCountTextField;
@property (strong, nonatomic) KeychainItemWrapper *keychainItem;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:HJLoginIdentifier accessGroup:nil];

    self.profileImageView.layer.masksToBounds = YES;
    NSLog(@"%f", self.profileImageView.frame.size.width);
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;

    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate = self;
    // Do any additional setup after loading the view.
    
    
    self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentsPath = [self.paths objectAtIndex:0];
    NSString *userID = [self.keychainItem objectForKey:(__bridge id)kSecAttrAccount];
    NSLog(@"name : %@", userID);
    self.filePath = [self.documentsPath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@_profile.png", userID]];
    

    if(self.filePath != nil) {
        NSData *pngData = [NSData dataWithContentsOfFile:self.filePath];
        [self.profileImageView initWithImage:[UIImage imageWithData:pngData]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    DataManager *dataManager = [DataManager sharedInstance];
    self.memoCountTextField.text = [[NSString alloc] initWithFormat:@"%i", [dataManager getCount]];
    self.favoritCountTextField.text = [[NSString alloc] initWithFormat:@"%i", [dataManager getFavoriteCount]];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)presentPhotoLibrary:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

- (IBAction)logout:(id)sender {
    [self.keychainItem resetKeychainItem];
    
    UITabBarController *tabBarController = self.tabBarController;
    [tabBarController dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo {
    [self.profileImageView initWithImage:image];
    [self saveImageToDir:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImageToDir:(UIImage *)image {
    NSData *pngData = UIImagePNGRepresentation(image);
    [pngData writeToFile:self.filePath atomically:YES];
}


@end
