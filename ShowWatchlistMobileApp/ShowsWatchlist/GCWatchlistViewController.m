//
//  GCWatchlistViewController.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/8/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "GCWatchlistViewController.h"
#import "GCWatchViewCell.h"
#import "GCHttpData.h"
#import "AppDelegate.h"
#import "GCShowModel.h"
#import <UIKit/UIKit.h>
#import "GCShowDetailViewController.h"
#import "iToast.h"

@interface GCWatchlistViewController ()

@property (strong, nonatomic)NSString *url;

@property (strong, nonatomic) GCHttpData *data;

@end

@implementation GCWatchlistViewController

static NSString *showCell = @"WatchCell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor yellowColor];
    
    UINib *nib = [UINib nibWithNibName:@"GCWatchViewCell" bundle: nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier: showCell];
    NSString *url = [NSString stringWithFormat:@"%@", self.url];
    
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
        
        [self.watchingShows addObjectsFromArray: shows];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.watchingShows.count;
}

-(void)addShowToWatchlist : (id)sender{
    
    UIButton *btn = (UIButton *) sender;
    NSString *showId = [[self.watchingShows objectAtIndex:btn.tag] showId];
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSString *baseURL = del.baseUrl;
    NSString *url = [NSString stringWithFormat:@"%@/watch/%@",baseURL, showId];
    NSString *title = [[self.watchingShows objectAtIndex:btn.tag] title];
    [self.data putAt:url withBody:nil headers:nil andCompletionHandler:^(NSDictionary *response, NSError *err) {
        NSLog(@"%@",response);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = [response objectForKey:@"message"];
            BOOL isWatchingCurrShow = [[self.watchingShows objectAtIndex:btn.tag] isWatching];
            if ([msg containsString:@"removed"]) {
                isWatchingCurrShow = NO;
            } else {
                isWatchingCurrShow = YES;
            }
            
            UIImage *img = [UIImage imageNamed:@"Watching"];
            UIImage *add = [UIImage imageNamed:@"Add"];
            UIImage *sad = [UIImage imageNamed:@"Sad"];
            if (!isWatchingCurrShow) {
                [UIView animateWithDuration:0.5 animations:^{
                    btn.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [btn setImage:sad forState: UIControlStateNormal];
                    //        btn.alpha = 1.0;
                    [UIView animateWithDuration:0.5 animations:^{
                        btn.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            btn.alpha = 0.0;
                        } completion:^(BOOL finished) {
                            [btn setImage:add forState: UIControlStateNormal];
                            //        btn.alpha = 1.0;
                            [UIView animateWithDuration:0.5 animations:^{
                                btn.alpha = 1.0;
                            } completion:^(BOOL finished) {
                                
                                [[[[iToast makeText: [NSString stringWithFormat :@"%@ removed from watchlist :(", title]]
                                   setGravity:iToastGravityBottom] setDuration:iToastDurationShort] show];
                                [self.watchingShows removeObjectAtIndex:btn.tag];
                                [self.tableView reloadData];
                            }];
                        }];
                    }];
                }];
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    btn.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [btn setImage:img forState: UIControlStateNormal];
                    //        btn.alpha = 1.0;
                    [UIView animateWithDuration:0.5 animations:^{
                        btn.alpha = 1.0;
                    } completion:^(BOOL finished) {
                        [[[[iToast makeText: [NSString stringWithFormat :@"%@ added to watchlist ;)", title]]
                           setGravity:iToastGravityBottom] setDuration:iToastDurationShort] show];
                    }];
                }];
            }
            
            
        });
        
    }];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GCWatchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WatchCell"];
    
    
    cell.title.text = [[self.watchingShows objectAtIndex:indexPath.row] title];
    
    NSURL *url = [NSURL URLWithString: [[self.watchingShows objectAtIndex: indexPath.row] imageUrl]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    
    cell.imageView.image =  img;
    
    
    UIImage *img2 = [UIImage imageNamed:@"Watching"];
    
        
        [cell.button setImage:img2 forState: UIControlStateDisabled];
        [cell.button setImage:img2 forState: UIControlStateNormal];
        [cell.button addTarget:self action:@selector(addShowToWatchlist: ) forControlEvents:UIControlEventTouchUpInside];
        cell.button.tag = indexPath.row;
    
    
    
    return cell;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCShowDetailViewController *showDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetailView"];
    
    showDetailsVC.showId = [self.watchingShows[indexPath.row] showId];
    showDetailsVC.showTitle = [self.watchingShows[indexPath.row] title];
    
    [self.navigationController pushViewController:showDetailsVC animated:YES];
}

-(GCHttpData *)data {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    return delegate.httpData;
}

@synthesize url = _url;

-(NSString *) url {
    if (_url == nil) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        
        _url = [NSString stringWithFormat:@"%@/watch", delegate.baseUrl];
    }
    return _url;
}


-(NSMutableArray *)watchingShows {
    AppDelegate *delegate =  [UIApplication sharedApplication].delegate;
    return delegate.watchingShows;
}




-(void)setWatchingShows:(NSMutableArray *)watchingShows {
    AppDelegate *delegate =  [UIApplication sharedApplication].delegate;
    delegate.watchingShows = [NSMutableArray arrayWithArray:watchingShows];
}
@end
