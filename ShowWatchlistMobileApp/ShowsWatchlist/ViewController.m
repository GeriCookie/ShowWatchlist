//
//  ViewController.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/4/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "ViewController.h"
#import "GCHttpData.h"
#import "AppDelegate.h"
#import "GCUserModel.h"
#import <CoreData/CoreData.h>
#import "iToast.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSManagedObjectContext *managedContext;

@property (strong, nonatomic) GCHttpData *data;
@end

@implementation ViewController
- (IBAction)loginBtn:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *passHash = self.passwordField.text;
    NSString *url = [NSString stringWithFormat:@"%@/auth", self.url];
    GCUserModel *user = [GCUserModel userWithUsername:username andPassHash:passHash];
    
    [self.data putAt:url withBody: user headers:nil andCompletionHandler:^(NSDictionary *response, NSError *err) {
        if (err) {
            NSLog(@"%@", err);
        }
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedContext];
        NSManagedObject *newUser = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedContext];
        
        [newUser setValue:[response objectForKey:@"username"] forKey:@"username"];
        [newUser setValue:[response objectForKey:@"token"] forKey:@"token"];
        NSLog(@"%@",[response objectForKey:@"username"]);
        NSLog(@"%@",[response objectForKey:@"token"]);
        NSError *error;
        [self.managedContext save:&error];
        if (error) {
            NSLog(@"Fuck...");
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadingScreen"];
            
            
            [[[[iToast makeText: [NSString stringWithFormat :@"%@ logged in  in Watchlist ;)", username]]
               setGravity:iToastGravityBottom] setDuration:iToastDurationShort] show];
        [self showViewController:controller sender:self];
        });
    }];
    
    
}
- (IBAction)registerBtn:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *passHash = self.passwordField.text;
    
    GCUserModel *user = [GCUserModel userWithUsername:username andPassHash:passHash];
    
    [self.data postAt:self.url withBody: user headers:nil andCompletionHandler:^(NSDictionary *response, NSError *err) {
        if (err) {
            NSLog(@"%@", err);
        }
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedContext];
        NSManagedObject *newUser = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedContext];
        
        [newUser setValue:[response objectForKey:@"username"] forKey:@"username"];
        [newUser setValue:[response objectForKey:@"token"] forKey:@"token"];
        NSLog(@"%@",[response objectForKey:@"username"]);
        NSLog(@"%@",[response objectForKey:@"token"]);
        NSError *error;
        [self.managedContext save:&error];
        if (error) {
            NSLog(@"Fuck...");
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoadingScreen"];
            
            
            [[[[iToast makeText: [NSString stringWithFormat :@"%@ register in Watchlist ;)", username]]
               setGravity:iToastGravityBottom] setDuration:iToastDurationShort] show];
            [self showViewController:controller sender:self];
        });
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(GCHttpData *)data {
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    return appDelegate.httpData;
}

@synthesize url = _url;

-(NSString *) url {
    if (_url == nil) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
        _url = [NSString stringWithFormat:@"%@/users", delegate.baseUrl];
    }
    return _url;
}

@synthesize managedContext = _managedContext;

-(NSManagedObjectContext *)managedContext {
    if (_managedContext == nil) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        _managedContext = appDelegate.managedObjectContext;
    }
    return _managedContext;
}
@end
