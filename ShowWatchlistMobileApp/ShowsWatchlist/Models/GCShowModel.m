//
//  GCShowModel.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/7/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "GCShowModel.h"

@implementation GCShowModel

-(instancetype) initWithTitle:(NSString *)title andGenres:(NSArray *)genres andShowDescription:(NSString *)showDescription andImgUrl:(NSString *)imgUrl andShowId:(NSString *)showId {
    
    if (self = [super init]) {
        self.title = title;
        self.genres = genres;
        self.showDescription = showDescription;
        self.imgUrl = imgUrl;
        self.showId = showId;
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary *)dict{
    return [self initWithTitle:[dict objectForKey:@"title"] andGenres:[dict objectForKey:@"genres"] andShowDescription:[dict objectForKey:@"description"] andImgUrl:[dict objectForKey:@"imgUrl"] andShowId:[dict objectForKey:@"_id"]];
}

+(GCShowModel *)showWithTitle:(NSString *)title andGenres:(NSArray *)genres andShowDescription:(NSString *)showDescription andImgUrl:(NSString *)imgUrl andShowId:(NSString *)showId {
    return [[GCShowModel alloc] initWithTitle:title andGenres:genres andShowDescription:showDescription andImgUrl:imgUrl andShowId:showId];
}


-(NSDictionary *)dict{
    return @{
             @"title": self.title,
             @"genres": self.genres,
             @"description": self.showDescription,
             @"imgUrl": self.imgUrl,
             @"_id": self.showId
             };
}
@end
