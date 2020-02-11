//
//  DetailViewController.m
//  theodoreMemo
//
//  Created by theodore on 2020/02/12.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import "DetailViewController.h"
#import "Memo.h"

@interface DetailViewController () <UITableViewDataSource>
@property (strong, nonatomic) NSDateFormatter *formatter;
@end

@implementation DetailViewController
@synthesize memo;

#pragma mark - life cycle
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

@end
