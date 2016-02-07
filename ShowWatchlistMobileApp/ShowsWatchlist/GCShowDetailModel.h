//
//  GCShowDetailModel.h
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/7/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCHttpDataModel.h"
#import <UIKit/UIKit.h>

@interface GCShowDetailModel : NSObject<GCHttpDataModel>
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *genres;
@property (strong, nonatomic) NSString *showDescription;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *showId;
@property CGFloat communityRating;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSArray *actors;
@property (strong, nonatomic) NSArray *seasons;
@property (strong, nonatomic) NSArray *comments;

-(instancetype)initWithTitle: (NSString *) title
                   andGenres: (NSArray *) genres
          andShowDescription: (NSString *) showDescription
                 andimageUrl: (NSString *) imageUrl
                   andShowId: (NSString *) showId
          andCommunityRating: (CGFloat) communityRating
                   andRating: (NSNumber *) rating
                   andActors: (NSArray *) actors
                  andSeasons: (NSArray *) seasons
                 andComments: (NSArray *) comments;


+(GCShowDetailModel *) showWithTitle: (NSString *) title
                     andGenres: (NSArray *) genres
            andShowDescription: (NSString *) showDescription
                   andimageUrl: (NSString *) imageUrl
                     andShowId: (NSString *) showId
            andCommunityRating: (CGFloat) communityRating
                     andRating: (NSNumber *) rating
                     andActors: (NSArray *) actors
                    andSeasons: (NSArray *) seasons
                   andComments: (NSArray *) comments;
@end
