//
//  GCShowViewCell.h
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/6/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCShowViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgBox;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end
