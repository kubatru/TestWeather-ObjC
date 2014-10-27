//
//  SearchLocationDictionaryPackageParser
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "SearchLocationDictionaryPackageParser.h"

@implementation NSDictionary (citiesPackage)

- (NSArray *)currentResults
{
    return self[@"geonames"];
}

@end
