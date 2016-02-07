//
//  AppDelegate.h
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/4/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GCHttpData.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *baseUrl;

@property (strong, nonatomic) GCHttpData *httpData;
@property (strong, nonatomic) NSMutableArray *shows;
@property (strong, nonatomic) NSString *token;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

