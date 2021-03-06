		//
//  GCHttpData.m
//  ShowsWatchlist
//
//  Created by Geri Cookie on 2/6/16.
//  Copyright © 2016 Geri Cookie. All rights reserved.
//

#import "GCHttpData.h"
#import "AppDelegate.h"

@implementation GCHttpData

+(GCHttpData *)httpData {
    return [[GCHttpData alloc] init];
}

-(void)sendAt: (NSString *)urlStr
   withMethod: (NSString *)method
         body: (id<GCHttpDataModel>)body
      headers: (NSDictionary *)headersDict
andCompletionHadler: (void (^)(NSDictionary *, NSError *))completionHandler {
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [request setHTTPMethod: method];
    
    if (body) {
        NSDictionary *bodyDict  = [body dict];
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyDict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        [request setHTTPBody: bodyData];
    }
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    if(delegate.token){
        NSString *headerValue = [NSString stringWithFormat:@"bearer %@",delegate.token];
        [request addValue:headerValue forHTTPHeaderField:@"Authorization"];
    }
    
    if (headersDict) {
        for (id key in headersDict) {
            [request addValue:[headersDict objectForKey:key]
           forHTTPHeaderField:key];
        }
    }
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
     ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
         if (error) {
             completionHandler(nil, error);
             return;
         }
         
         NSError *err;
         
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:&err];
         
         if (err) {
             completionHandler(nil, err);
             return;
         }
         completionHandler(dict, nil);
     }]
     resume];
}

-(void)getFrom:(NSString *)urlStr headers:(NSDictionary *)headersDict withCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler{
    [self sendAt:urlStr withMethod:@"GET"
            body:nil headers:headersDict andCompletionHadler:completionHandler];
}

-(void)postAt:(NSString *)urlStr withBody:(id<GCHttpDataModel>)bodyDict headers:(NSDictionary *)headersDict andCompletionHandler:(void (^)(NSDictionary *, NSError *)) completionHandler {
    [self sendAt:urlStr withMethod:@"POST" body:bodyDict headers:headersDict andCompletionHadler:completionHandler];
}

-(void)putAt:(NSString *)urlStr withBody:(id<GCHttpDataModel>)bodyDict headers:(NSDictionary *)headersDict andCompletionHandler:(void (^)(NSDictionary *, NSError *))completionHandler {
    [self sendAt:urlStr withMethod:@"PUT" body:bodyDict headers:headersDict andCompletionHadler:completionHandler];
}


@end
