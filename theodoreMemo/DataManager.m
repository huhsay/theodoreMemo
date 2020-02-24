//
//  DataManager.m
//  theodoreMemo
//
//  Created by theodore on 2020/02/13.
//  Copyright © 2020 mobile-native. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "Memo+CoreDataProperties.h"
#import "Memo+CoreDataClass.h"

@implementation DataManager


#pragma mark - Core Data Stack
@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Model"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }

    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

+ (instancetype)sharedInstance {

    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
        sharedInstance.memoList = [[NSMutableArray alloc] init];
    });

    return sharedInstance;
}

- (void)fetchMemo {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Memo"];
    NSSortDescriptor *sortByDateDesc = [NSSortDescriptor sortDescriptorWithKey:@"insertDate" ascending:NO];
    request.sortDescriptors = @[sortByDateDesc];

    //NSError *error = nil;
    NSError *result = [self.mainContext executeFetchRequest:request error:nil];
    [self.memoList setArray:result];
}

- (void)addNewMemo:(NSString *)newMemo {
    Memo *memo = [[Memo alloc] initWithContext:self.mainContext];
    memo.content = newMemo;
    memo.insertDate = [NSDate date];
    memo.favorite = 0;

    [self saveContext];
}

- (void)deleteMemo:(Memo *)memo {

    if (memo != nil) {
        [self.mainContext deleteObject:memo];
        [self saveContext];
    }

}

- (int)getCount {
    [self fetchMemo];
    NSLog(@"%i",self.memoList.count);
    return (int) self.memoList.count;
}


- (NSManagedObjectContext *)mainContext {
    return self.persistentContainer.viewContext;
}

- (int)getFavoriteCount {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Memo"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"favorite = %d", 1]];
    NSArray *result = [self.mainContext executeFetchRequest:request error:nil];
    
    NSLog(@"%i", (int)result.count);
    return (int) result.count;
    
    return 1;
}



@end
