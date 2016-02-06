//
//  GCUserModel.h
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/6/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCHttpDataModel.h"

@interface GCUserModel : NSObject<GCHttpDataModel>

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *passHash;

-(instancetype) initWithUsername: (NSString *) username
                        andPassHash: (NSString *) passHash;

+(GCUserModel *) userWithUsername: (NSString *) username
                         andPassHash: (NSString *) passHash;
@end
