//
//  SearchLocationDictionaryParser.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (cities)

// Make some cool methods for NSDictionary (getting parts of JASONs file)
// Level 2 (Parts)
- (NSString *)cityName;
- (NSString *)countryName;
- (NSNumber *)latitude;
- (NSNumber *)longitude;


@end
