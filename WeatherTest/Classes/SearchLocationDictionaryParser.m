//
//  SearchLocationDictionaryParser.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "SearchLocationDictionaryParser.h"

@implementation NSDictionary (cities)

-(NSString *)cityName
{
    return self[@"toponymName"];
}

-(NSString *)countryName
{
    return self[@"countryName"];
}

- (NSNumber *)latitude
{
    NSString *cc = self[@"lat"];
    NSNumber *n = @([cc doubleValue]);
    return n;
}

- (NSNumber *)longitude
{
    NSString *cc = self[@"lng"];
    NSNumber *n = @([cc doubleValue]);
    return n;
}

@end
