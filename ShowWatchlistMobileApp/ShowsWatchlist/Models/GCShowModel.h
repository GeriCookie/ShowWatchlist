//
//  GCShowModel.h
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/7/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCHttpDataModel.h"
#import <UIKit/UIKit.h>
@interface GCShowModel : NSObject<GCHttpDataModel>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *genres;
@property (strong, nonatomic) NSString *showDescription;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *showId;
@property BOOL isWatching;
@property CGFloat communityRating;

-(instancetype)initWithTitle: (NSString *) title
                   andGenres: (NSArray *) genres
          andShowDescription: (NSString *) showDescription
                   andimageUrl: (NSString *) imageUrl
                   andShowId: (NSString *) showId
          andCommunityRating: (CGFloat) communityRating
               andIsWatching: (BOOL) isWatching;

+(GCShowModel *) showWithTitle: (NSString *) title
                   andGenres: (NSArray *) genres
          andShowDescription: (NSString *) showDescription
                   andimageUrl: (NSString *) imageUrl
                   andShowId: (NSString *) showId
            andCommunityRating: (CGFloat) communityRating
                 andIsWatching: (BOOL) isWatching;




@end
