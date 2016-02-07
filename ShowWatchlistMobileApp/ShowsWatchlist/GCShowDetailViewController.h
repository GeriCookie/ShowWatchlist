//
//  GCShowDetailViewController.h
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/7/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCShowDetailModel.h"

@interface GCShowDetailViewController : UIViewController
@property (strong, nonatomic) NSString *showId;
@property (strong, nonatomic) NSString *showTitle;
@property (strong, nonatomic) GCShowDetailModel *showDetail;
@end
