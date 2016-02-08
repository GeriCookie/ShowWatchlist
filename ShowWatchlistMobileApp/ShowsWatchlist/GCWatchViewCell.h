//
//  GCWatchViewCell.h
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/8/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCWatchViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
