//
//  MemoListTableViewController.m
//  theodoreMemo
//
//  Created by theodore on 2020/02/10.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import "MemoListTableViewController.h"

#import "ComposeViewController.h"
#import "DetailViewController.h"
#import "Memo+CoreDataProperties.h"
#import "DataManager.h"
#import "CustomTableViewCell.h"
#import <UserNotifications/UserNotifications.h>

@interface MemoListTableViewController ()

@property (strong, nonatomic) NSDateFormatter *formatter;

@end

@implementation MemoListTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender]; // cell로부터 인덱스를 얻는다. 매개변수가 셀임

    if (indexPath !=nil) {
        Memo *target = [[[DataManager sharedInstance] memoList] objectAtIndex:indexPath.row];
        ComposeViewController *vc = (ComposeViewController*)segue.destinationViewController;
        vc.editTarget = target;
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
    [self.formatter setDateFormat:@"yyyy MM dd"];
//    self.formatter.dateFormat = @"yyyy MM dd";
//    self.formatter.timeStyle = NSDateFormatterNoStyle;
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
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Memo *target =[[[DataManager sharedInstance] memoList] objectAtIndex:indexPath.row];
    cell.textLabel.text = target.content;
    cell.dateLabel.text = [self.formatter stringFromDate:target.insertDate];
    
    if( target.favorite != 0) {
        cell.heartImage.image = [UIImage systemImageNamed:@"heart.fill"];
    } else {
        cell.heartImage.image = nil;
    }


    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Notification" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        // Authorization
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError *error) {
            //do nothing

            if(granted){
                NSLog(@"granted");
            } else {
                NSLog(@"notiAuth %@", error.description);
            }
        }];

        // noti 객체
        Memo *target =[[[DataManager sharedInstance] memoList] objectAtIndex:indexPath.row];
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        content.title = @"Diary noti";
        content.subtitle = [self.formatter stringFromDate:target.insertDate];
        content.body = target.content;

        /**
         * trigger
         * tirgger의 설정에 따라 반응한다
         * trigger가 nil이변 시스템에 noti가 바로 전달된다.
         *
         * 앱이 켜진상태에서 노티가 오지 않는다.
         */
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];

        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"timedone" content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            //nothing
            if(error != nil) {
                NSLog(@"%@", error.description);
            } else {
                NSLog(@"noti 성공");
            }
        }];

        NSLog(@"noti");


        completionHandler (YES);


    }];

    action.backgroundColor = UIColor.blueColor;

    return [UISwipeActionsConfiguration configurationWithActions:@[action]];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {

    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {

        Memo *target = [[DataManager sharedInstance] memoList][indexPath.row];
        [[DataManager sharedInstance] deleteMemo:target];

        [[[DataManager sharedInstance] memoList] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        completionHandler (YES);
    }];
    action.backgroundColor = UIColor.redColor;

    return [UISwipeActionsConfiguration configurationWithActions:@[action]];
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
