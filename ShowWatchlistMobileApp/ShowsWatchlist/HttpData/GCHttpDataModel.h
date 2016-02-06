//
//  GCHttpDataModel.h
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/6/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GCHttpDataModel <NSObject>

-(NSDictionary *) dict;

-(instancetype) initWithDict: (NSDictionary*) dict;
@end
