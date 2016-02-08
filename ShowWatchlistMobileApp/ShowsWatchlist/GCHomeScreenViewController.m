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
#import "GCHttpData.h"
#import "GCExploreViewController.h"
#import "GCShowModel.h"

@interface GCHomeScreenViewController ()
@property (strong, nonatomic) NSManagedObjectContext *managedContext;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *token;
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
        //
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
        
        NSString *url = [NSString stringWithFormat:@"%@?page=%d", self.url, 1];
        [self.data getFrom:url headers:nil withCompletionHandler:^(NSDictionary *result, NSError *err) {
            NSArray *showsDicts = [result objectForKey:@"result"];
            if (err) {
                NSLog(@"Fuck: %@", err);
                return;
            }
            NSMutableArray *shows = [NSMutableArray array];
            [showsDicts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [shows addObject:[[GCShowModel alloc] initWithDict:obj]];
            }];
            
            [delegate.shows addObjectsFromArray: shows];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showViewController:controller sender:self];

            });
        }];
        
        
    } else {
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
        //        [self showViewController:controller sender:self];
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = controller;
    
    }
    
//    self.shows = [NSMutableArray array];
    
    

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

-(GCHttpData *)data {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    return delegate.httpData;
}

@synthesize url = _url;

-(NSString *) url {
    if (_url == nil) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
        _url = [NSString stringWithFormat:@"%@/shows", delegate.baseUrl];
    }
    return _url;
}

@synthesize token = _token;

-(NSString *)token {
    if(_token == nil){
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
        _token = delegate.token;
    }
    return _token;
}
@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


