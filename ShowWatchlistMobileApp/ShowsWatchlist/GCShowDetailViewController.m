//
//  GCShowDetailViewController.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/7/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "GCShowDetailViewController.h"
#import "GCHttpData.h"
#import "AppDelegate.h"
#import "GCShowDetailModel.h"
#import "GCSeasonViewCell.h"
#import "iToast.h"
#import <UIKit/UIKit.h>

@interface GCShowDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *kopche;
@property (weak, nonatomic) IBOutlet UILabel *labelTItle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;
@property (weak, nonatomic) IBOutlet UITextView *overviewTextVIew;
@property (weak, nonatomic) IBOutlet UITableView *seasonsTV;
@property (weak, nonatomic) IBOutlet UILabel *yourRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *genresLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityRatingLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (strong, nonatomic)NSString *url;

@property (strong, nonatomic) GCHttpData *data;

@end

@implementation GCShowDetailViewController
- (IBAction)kopchetooo:(id)sender {
    UIButton *btn = (UIButton *) sender;
    NSString *showId = self.showDetail.showId;
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSString *baseURL = del.baseUrl;
    NSString *url = [NSString stringWithFormat:@"%@/watch/%@",baseURL, showId];
    NSString *title = self.showDetail.title;
    [self.data putAt:url withBody:nil headers:nil andCompletionHandler:^(NSDictionary *response, NSError *err) {
        NSLog(@"%@",response);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = [response objectForKey:@"message"];
            BOOL isWatchingCurrShow = self.showDetail.isWatching;
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
                            }];
                        }];
                    }];
                }];
            } else {
                [UIView animateWithDuration:0.5 animations:^{
                    btn.alpha = 0.0;
                } completion:^(BOOL finished) {
                    [btn setImage:img forState: UIControlStateNormal];
                    //        btn.alpha = 0.5;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelTItle.text = self.showTitle;
    self.seasonsTV.dataSource = self;
    self.seasonsTV.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:@"GCSeasonViewCell" bundle: nil];
    
    [self.seasonsTV registerNib:nib forCellReuseIdentifier: @"SeasonShowCell"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", self.url, self.showId];
    [self.data getFrom:url headers:nil withCompletionHandler:^(NSDictionary *result, NSError *err) {
        NSLog(@"%@",result);
   self.showDetail = [[GCShowDetailModel alloc] initWithDict: [result objectForKey:@"result"]];
     dispatch_async(dispatch_get_main_queue(), ^{
         NSURL *url = [NSURL URLWithString: self.showDetail.imageUrl];
         NSData *data = [NSData dataWithContentsOfURL:url];
         UIImage *img = [UIImage imageWithData:data];
         
         self.imageView.image =  img;
         
         UIImage *img2 = [UIImage imageNamed:@"Watching"];
         UIImage *img3 = [UIImage imageNamed:@"Add"];

         self.overviewTextVIew.text = self.showDetail.showDescription;
         if (self.showDetail.isWatching) {
             [self.kopche setImage:img2 forState: UIControlStateDisabled];
             [self.kopche setImage:img2 forState: UIControlStateNormal];
             
         } else {
             
             [self.kopche setImage:img3 forState: UIControlStateDisabled];
             [self.kopche setImage:img3 forState: UIControlStateNormal];
             
             
         }

         [self.overviewTextVIew layoutIfNeeded];
         [self.seasonsTV reloadData];
         
     });
    }];
}

-(void)addSeasonToWatched : (id)sender{
    
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCSeasonViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeasonShowCell"];
    
    cell.seasonName.text = [[self.showDetail.seasons objectAtIndex:indexPath.row] objectForKey:@"title"];
    BOOL isWatched = [[self.showDetail.seasons objectAtIndex:indexPath.row] objectForKey:@"isWatched"];
    NSLog(@"%d",isWatched);
    UIImage *img2 = [UIImage imageNamed:@"Watching"];
    UIImage *img3 = [UIImage imageNamed:@"Add"];
    if (isWatched) {
        
        [cell.addButton setImage:img2 forState: UIControlStateDisabled];
        [cell.addButton setImage:img2 forState: UIControlStateNormal];
        [cell.addButton addTarget:self action:@selector(addSeasonToWatched: ) forControlEvents:UIControlEventTouchUpInside];
        cell.addButton.tag = indexPath.row;
    } else {
        
        [cell.addButton setImage:img3 forState: UIControlStateDisabled];
        [cell.addButton setImage:img3 forState: UIControlStateNormal];
        [cell.addButton addTarget:self action:@selector(addSeasonToWatched: ) forControlEvents:UIControlEventTouchUpInside];
        cell.addButton.tag = indexPath.row;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDetail.seasons.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
