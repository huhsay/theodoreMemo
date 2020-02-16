//
//  DetailViewController.m
//  theodoreMemo
//
//  Created by theodore on 2020/02/12.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import"DetailViewController.h"
#import "Memo+CoreDataProperties.h"
#import "ComposeViewController.h"
#import "DataManager.h"


@interface DetailViewController () <UITableViewDataSource>
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (weak, nonatomic) IBOutlet UITableView *memoTableView;
- (IBAction)deleteMemo:(id)sender;
@end

@implementation DetailViewController
@synthesize memo;

#pragma mark - life cycle

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {

    ComposeViewController *vc = segue.destinationViewController;
    vc.editTarget = self.memo;

}

- (void)viewWillAppear:(BOOL)animated {
    [self.memoTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateStyle = NSDateFormatterLongStyle;
    self.formatter.timeStyle = NSDateFormatterMediumStyle;
    self.formatter.locale = [NSLocale localeWithLocaleIdentifier:@"Ko_kr"]; // data format korea
    // Do any additional setup after loading the view.
}

#pragma mark - datasource protocal override

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memoCell" forIndexPath:indexPath];

        cell.textLabel.text = self.memo.content;

        return cell;
    } else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell" forIndexPath:indexPath];
        cell.textLabel.text = [self.formatter stringFromDate: self.memo.insertDate];
        return  cell;
    }

    return [[UITableViewCell alloc] init];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteMemo:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"삭제 확인" message:@"메모를 삭제하시겠습니까?" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"삭제" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *_Nonnull action){

        [[DataManager sharedInstance] deleteMemo:self.memo];
        [self.navigationController popViewControllerAnimated:YES];

    }];
    [alert addAction:okAction];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action){
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
