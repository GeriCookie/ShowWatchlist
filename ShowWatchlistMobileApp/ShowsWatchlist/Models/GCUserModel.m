//
//  GCUserModel.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/6/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "GCUserModel.h"

@implementation GCUserModel

-(instancetype)initWithUsername:(NSString *)username andPassHash:(NSString *)passHash {

    if (self = [super init]) {
        self.username = username;
        self.passHash = passHash;
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary *)dict {
    return [self initWithUsername:[dict objectForKey:@"username"] andPassHash: [dict objectForKey:@"passHash"]];
}

+(GCUserModel *)userWithUsername:(NSString *)username andPassHash:(NSString *)passHash {
    return [[GCUserModel alloc] initWithUsername:username andPassHash: passHash];
}

-(NSDictionary *)dict{
    return @{
             @"username": self.username,
             @"passHash": self.passHash
             };
}
@end
