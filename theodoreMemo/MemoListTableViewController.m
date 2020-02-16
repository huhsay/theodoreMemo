//
//  MemoListTableViewController.m
//  theodoreMemo
//
//  Created by theodore on 2020/02/10.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import "MemoListTableViewController.h"
#import "DetailViewController.h"
#import "Memo+CoreDataProperties.h"
#import "DataManager.h"

@interface MemoListTableViewController ()

@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation MemoListTableViewController

#pragma mark - data

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender]; // cell로부터 인덱스를 얻는다. 매개변수가 셀임

    if (indexPath !=nil) {
        Memo *target = [[[DataManager sharedInstance] memoList] objectAtIndex:indexPath.row];
        DetailViewController *vc = (DetailViewController *)segue.destinationViewController;
        vc.memo = target;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[DataManager sharedInstance] fetchMemo];
    // 테이블뷰에 새로 들어왔을 때 데이터를 업데이트 해준다.
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.formatter = [[NSDateFormatter alloc] init];
    self.formatter.dateStyle = NSDateFormatterLongStyle;
    self.formatter.timeStyle = NSDateFormatterNoStyle;
    self.formatter.locale = [NSLocale localeWithLocaleIdentifier:@"Ko_kr"]; // data format korea
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[DataManager sharedInstance] memoList] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Memo *target =[[[DataManager sharedInstance] memoList] objectAtIndex:indexPath.row];
    cell.textLabel.text = target.content;
    cell.detailTextLabel.text = [self.formatter stringFromDate:target.insertDate];

    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source

        // 데이터베이스에서 메시지 삭제
        Memo *target = [[DataManager sharedInstance] memoList][indexPath.row];
        [[DataManager sharedInstance] deleteMemo:target];

        // 리스트와 데이터베이스에서 개수를 비교하기 때문에 리스트에서 삭제해서 숫자를 일치시켜야한다.dddd
        [[[DataManager sharedInstance] memoList] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
