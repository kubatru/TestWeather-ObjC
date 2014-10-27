//
//  SearchLocationDictionaryPackageParser.h
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (citiesPackage)

// Make some cool methods for NSDictionary (getting parts of JASONs file)
// Level 1 (All 10 results into array)
- (NSArray *)currentResults;

@end
