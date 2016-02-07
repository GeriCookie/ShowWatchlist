//
//  GCExploreViewController.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/6/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "GCExploreViewController.h"
#import "GCShowViewCell.h"
#import "GCHttpData.h"
#import "AppDelegate.h"
#import "GCShowModel.h"
#import <UIKit/UIKit.h>
#import "GCShowDetailViewController.h"

@interface GCExploreViewController()



@property (strong, nonatomic)NSString *url;

@property (strong, nonatomic) GCHttpData *data;

@end

@implementation GCExploreViewController
{
    NSInteger _currentPage;
}
- (IBAction)showMoreBtn:(id)sender {
    _currentPage++;
    NSString *url = [NSString stringWithFormat:@"%@?page=%ld", self.url, (long)_currentPage];
    //        NSDictionary *header = @{@"Authorization": [NSString stringWithFormat:@"bearer %@",self.token]};
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
        
        [self.shows addObjectsFromArray: shows];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}


static NSString *showCell = @"ShowCell";

-(void)viewDidLoad{
    _currentPage = 1;
    UINib *nib = [UINib nibWithNibName:@"GCShowViewCell" bundle: nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier: showCell];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shows.count;
}

-(void)addShowToWatchlist : (id)sender{
    
    UIButton *btn = (UIButton *) sender;
    NSString *showId = [[self.shows objectAtIndex:btn.tag] showId];
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSString *baseURL = del.baseUrl;
    NSString *url = [NSString stringWithFormat:@"%@/watch/%@",baseURL, showId];
    [self.data putAt:url withBody:nil headers:nil andCompletionHandler:^(NSDictionary *response, NSError *err) {
        NSLog(@"%@",response);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *img = [UIImage imageNamed:@"Watching"];
            [UIView animateWithDuration:0.5 animations:^{
                btn.alpha = 0.0;
            } completion:^(BOOL finished) {
                btn.enabled = NO;
                [btn setImage:img forState: UIControlStateDisabled];
                [btn setImage:img forState: UIControlStateNormal];
                //        btn.alpha = 1.0;
                [UIView animateWithDuration:1.0 animations:^{
                    btn.alpha = 1.0;
                } completion:^(BOOL finished) {
                    
                }];
            }];

        });
        
    }];
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GCShowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowCell"];
    
    
    cell.titleLabel.text = [[self.shows objectAtIndex:indexPath.row] title];
    
    NSURL *url = [NSURL URLWithString: [[self.shows objectAtIndex: indexPath.row] imageUrl]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    
    cell.imgBox.image =  img;
    cell.ratingLabel.text = [NSString stringWithFormat:@"%f", [[self.shows objectAtIndex:indexPath.row] communityRating] ] ;
    [cell.btnAdd addTarget:self action:@selector(addShowToWatchlist: ) forControlEvents:UIControlEventTouchUpInside];
    cell.btnAdd.tag = indexPath.row;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GCShowDetailViewController *showDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetailView"];
    
    showDetailsVC.showId = [self.shows[indexPath.row] showId];
    showDetailsVC.showTitle = [self.shows[indexPath.row] title];
    
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
        
        _url = [NSString stringWithFormat:@"%@/shows", delegate.baseUrl];
    }
    return _url;
}


-(NSMutableArray *)shows {
    AppDelegate *delegate =  [UIApplication sharedApplication].delegate;
    return delegate.shows;
}

-(void)setShows:(NSMutableArray *)shows {
    AppDelegate *delegate =  [UIApplication sharedApplication].delegate;
    delegate.shows = [NSMutableArray arrayWithArray:shows];
}
@end
