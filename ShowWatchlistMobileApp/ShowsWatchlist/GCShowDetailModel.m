//
//  GCShowDetailModel.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/7/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "GCShowDetailModel.h"
#import "GCHttpDataModel.h"


@implementation GCShowDetailModel

-(instancetype)initWithTitle:(NSString *)title andGenres:(NSArray *)genres andShowDescription:(NSString *)showDescription andimageUrl:(NSString *)imageUrl andShowId:(NSString *)showId andCommunityRating:(CGFloat)communityRating andRating:(NSNumber *)rating andActors:(NSArray *)actors andSeasons:(NSArray *)seasons andComments:(NSArray *)comments andIsWatiching:(BOOL)isWatchng{

    if(self = [super init]){
        self.title = title;
        self.genres = genres;
        self.showDescription = showDescription;
        self.imageUrl = imageUrl;
        self.showId = showId;
        self.communityRating = communityRating;
        self.rating = rating;
        self.actors = actors;
        self.seasons = seasons;
        self.comments = comments;
        self.isWatching = isWatchng;
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    return [self initWithTitle:[dict objectForKey:@"title"] andGenres:[dict objectForKey:@"genres"] andShowDescription:[dict objectForKey:@"description"] andimageUrl:[dict objectForKey:@"imageUrl"] andShowId:[dict objectForKey:@"_id"] andCommunityRating:[[dict objectForKey:@"communityRating"] floatValue] andRating:[dict objectForKey:@"rating"] andActors:[dict objectForKey:@"actors"] andSeasons:[dict objectForKey:@"seasons"] andComments:[dict objectForKey:@"comments"] andIsWatiching:[[dict objectForKey:@"isWatching"] boolValue]];
}

+(GCShowDetailModel *)showWithTitle:(NSString *)title andGenres:(NSArray *)genres andShowDescription:(NSString *)showDescription andimageUrl:(NSString *)imageUrl andShowId:(NSString *)showId andCommunityRating:(CGFloat)communityRating andRating:(NSNumber *)rating andActors:(NSArray *)actors andSeasons:(NSArray *)seasons andComments:(NSArray *)comments andIsWatiching:(BOOL)isWatchng{
    return [[GCShowDetailModel alloc] initWithTitle:title andGenres:genres andShowDescription:showDescription andimageUrl:imageUrl andShowId:showId andCommunityRating:communityRating andRating:rating andActors:actors andSeasons:seasons andComments:comments andIsWatiching:isWatchng];
}


-(NSDictionary *)dict{
    return @{
             @"title": self.title,
             @"genres": self.genres,
             @"description": self.showDescription,
             @"imageUrl": self.imageUrl,
             @"_id": self.showId,
             @"communityRating": [NSNumber numberWithFloat: self.communityRating],
             @"rating": self.rating,
             @"actors": self.actors,
             @"seasons": self.seasons,
             @"comments": self.comments,@"isWatching": [NSNumber numberWithBool:self.isWatching]
             };
}
@end
