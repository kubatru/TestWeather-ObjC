//
//  SearchLocationHTTPClient.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "CoreLocation/CoreLocation.h"

@protocol SearchLocationHTTPClientDelegate;

@interface SearchLocationHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<SearchLocationHTTPClientDelegate>delegate;

+ (SearchLocationHTTPClient *)sharedSearchLocationHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)updateResultsWithString:(NSString *)cityName;

@end

@protocol SearchLocationHTTPClientDelegate <NSObject>

@optional
- (void)searchLocationHTTPClient:(SearchLocationHTTPClient *)client didUpdateWithResults:(id)results;
- (void)searchLocationHTTPClient:(SearchLocationHTTPClient *)client didFailWithError:(NSError *)error;

@end
