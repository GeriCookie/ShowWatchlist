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

@interface GCExploreViewController()

@property (strong, nonatomic)NSMutableArray *shows;

@property (strong, nonatomic)NSString *url;

@property (strong, nonatomic) GCHttpData *data;

@end

@implementation GCExploreViewController
{
    NSInteger _currentPage;
}


static NSString *showCell = @"ShowCell";

-(void)viewWillAppear:(BOOL)animated {
    self.shows = [NSMutableArray array];
    _currentPage = 1;
    
    NSString *url = [NSString stringWithFormat:@"%@?page=%ld", self.url, _currentPage];
    [self.data getFrom:url headers:nil withCompletionHandler:^(NSDictionary *result, NSError *err) {
        NSArray *showsDicts = [result objectForKey:@"result"];
        if (err) {
            NSLog(@"Fuck");
        }
        NSLog(@"%@", result);
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

-(void)viewDidLoad{
    [self.tableView registerClass: GCShowViewCell.self forCellReuseIdentifier: showCell];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GCShowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowCell"];
    
    cell.textLabel.text = [[self.shows objectAtIndex:indexPath.row] title];
    
    return cell;
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
@end
