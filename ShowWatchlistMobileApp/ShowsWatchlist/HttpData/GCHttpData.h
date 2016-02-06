//
//  GCHttpData.h
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/6/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GCHttpDataModel.h"
@interface GCHttpData : NSObject

+(GCHttpData *) httpData;

-(void) getFrom: (NSString*) urlStr
        headers: (NSDictionary *) headersDict
withCompletionHandler: (void(^)(NSDictionary*, NSError*)) completionHandler;

-(void) postAt: (NSString*) urlStr
      withBody: (id<GCHttpDataModel>) bodyDict
       headers: (NSDictionary *) headersDict
andCompletionHandler: (void(^)(NSDictionary*, NSError*)) completionHandler;

-(void) putAt: (NSString*) urlStr
     withBody: (id<GCHttpDataModel>) bodyDict
      headers: (NSDictionary *)headersDict
andCompletionHandler: (void(^)(NSDictionary*, NSError*)) completionHandler;

@end
