//
//  GCHomeScreenViewController.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/7/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "GCHomeScreenViewController.h"

#import "GCHttpData.h"
#import "AppDelegate.h"
#import "GCUserModel.h"
#import <CoreData/CoreData.h>

@interface GCHomeScreenViewController ()
@property (strong, nonatomic) NSManagedObjectContext *managedContext;
@end

@implementation GCHomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Watchmen"]]];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    NSError *err;
    
    NSInteger user = [self.managedContext countForFetchRequest:fetchRequest error:&err];
    
    if (user > 0) {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TabView"];
        //        [self showViewController:controller sender:self];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = controller;
    } else {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        //        [self showViewController:controller sender:self];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = controller;
    
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize managedContext = _managedContext;

-(NSManagedObjectContext *)managedContext {
    if (_managedContext == nil) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        _managedContext = appDelegate.managedObjectContext;
    }
    return _managedContext;
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
