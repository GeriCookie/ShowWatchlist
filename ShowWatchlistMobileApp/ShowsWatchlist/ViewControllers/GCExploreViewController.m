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

@interface GCExploreViewController()



@property (strong, nonatomic)NSString *url;

@property (strong, nonatomic) GCHttpData *data;

@end

@implementation GCExploreViewController
{
    NSInteger _currentPage;
}


static NSString *showCell = @"ShowCell";

-(void)viewDidLoad{
    UINib *nib = [UINib nibWithNibName:@"GCShowViewCell" bundle: nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier: showCell];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shows.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GCShowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShowCell"];
    
    
    cell.titleLabel.text = [[self.shows objectAtIndex:indexPath.row] title];
    
    NSURL *url = [NSURL URLWithString: [[self.shows objectAtIndex: indexPath.row] imageUrl]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    
    cell.imgBox.image =  img;
    cell.ratingLabel.text = [NSString stringWithFormat:@"%f", [[self.shows objectAtIndex:indexPath.row] communityRating] ] ;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
