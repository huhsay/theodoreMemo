//
//  DataManager.h
//  theodoreMemo
//
//  Created by theodore on 2020/02/13.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSPersistentContainer;
@class Memo;

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

+ (instancetype)sharedInstance;

@property (readonly, strong) NSManagedObjectContext *mainContext;
@property (strong, nonatomic) NSMutableArray *memoList;

- (void)fetchMemo;
- (void)addNewMemo:(NSString *) newMemo;
- (void)deleteMemo:(Memo *)memo;


@end

NS_ASSUME_NONNULL_END
