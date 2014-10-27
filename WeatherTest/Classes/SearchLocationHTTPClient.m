//
//  SearchLocationHTTPClient.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "SearchLocationHTTPClient.h"
#import "Constants.h"

// My GeoNames Username
static NSString *const GeoNamesUSERNAME = GeoNamesUsername;

static NSString *const GeoNamesURLString = @"http://api.geonames.org/";

@implementation SearchLocationHTTPClient

+ (SearchLocationHTTPClient *)sharedSearchLocationHTTPClient
{
    static SearchLocationHTTPClient *_sharedSearchLocationHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSearchLocationHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:GeoNamesURLString]];
    });
    
    return _sharedSearchLocationHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)updateResultsWithString:(NSString *)cityName
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"q"] = cityName;
    parameters[@"maxRows"] = @"10";
    parameters[@"username"] = GeoNamesUSERNAME;
    
    [self GET:@"searchJSON?" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(searchLocationHTTPClient:didUpdateWithResults:)]) {
            [self.delegate searchLocationHTTPClient:self didUpdateWithResults:responseObject];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(searchLocationHTTPClient:didFailWithError:)]) {
            [self.delegate searchLocationHTTPClient:self didFailWithError:error];
        }
    }];
}

@end
