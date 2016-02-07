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

@interface GCShowDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labelTItle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelTItle.text = self.showTitle;
    self.seasonsTV.dataSource = self;
    self.seasonsTV.delegate = self;
    [self.seasonsTV registerClass: UITableViewCell.self forCellReuseIdentifier:@"DetailShowCell"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@", self.url, self.showId];
    [self.data getFrom:url headers:nil withCompletionHandler:^(NSDictionary *result, NSError *err) {
        NSLog(@"%@",result);
   self.showDetail = [[GCShowDetailModel alloc] initWithDict: [result objectForKey:@"result"]];
     dispatch_async(dispatch_get_main_queue(), ^{
         NSURL *url = [NSURL URLWithString: self.showDetail.imageUrl];
         NSData *data = [NSData dataWithContentsOfURL:url];
         UIImage *img = [UIImage imageWithData:data];
         
         self.imageView.image =  img;
         
         self.overviewTextVIew.text = self.showDetail.showDescription;
         [self.overviewTextVIew layoutIfNeeded];
         [self.seasonsTV reloadData];
         
     });
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailShowCell"];
    
    cell.textLabel.text = [[self.showDetail.seasons objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDetail.seasons.count;
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
