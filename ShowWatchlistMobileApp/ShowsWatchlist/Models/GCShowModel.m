//
//  GCShowModel.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/7/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "GCShowModel.h"

@implementation GCShowModel

-(instancetype) initWithTitle:(NSString *)title andGenres:(NSArray *)genres andShowDescription:(NSString *)showDescription andimageUrl:(NSString *)imageUrl andShowId:(NSString *)showId andCommunityRating:(CGFloat)communityRating{
    
    if (self = [super init]) {
        self.title = title;
        self.genres = genres;
        self.showDescription = showDescription;
        self.imageUrl = imageUrl;
        self.showId = showId;
        self.communityRating = communityRating;
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    return [self initWithTitle:[dict objectForKey:@"title"] andGenres:[dict objectForKey:@"genres"] andShowDescription:[dict objectForKey:@"description"] andimageUrl:[dict objectForKey:@"imageUrl"] andShowId:[dict objectForKey:@"_id"] andCommunityRating: [[dict objectForKey:@"communityRating"] floatValue]];
}

+(GCShowModel *)showWithTitle:(NSString *)title andGenres:(NSArray *)genres andShowDescription:(NSString *)showDescription andimageUrl:(NSString *)imageUrl andShowId:(NSString *)showId andCommunityRating:(CGFloat)communityRating {
    return [[GCShowModel alloc] initWithTitle:title andGenres:genres andShowDescription:showDescription andimageUrl:imageUrl andShowId:showId andCommunityRating:communityRating];
}


-(NSDictionary *)dict{
    return @{
             @"title": self.title,
             @"genres": self.genres,
             @"description": self.showDescription,
             @"imageUrl": self.imageUrl,
             @"_id": self.showId,
             @"communityRating": [NSNumber numberWithFloat: self.communityRating]
             };
}
@end
