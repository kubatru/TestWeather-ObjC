//
//  SearchViewController.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 22.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "SearchViewController.h"
#import "Macros.h"
#import "SearchLocationDictionaryPackageParser.h"
#import "SearchLocationDictionaryParser.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    
    // Change graphics
    [self applyAppearance];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    // First responder (keyboard)
    [self.searchDisplayController.searchBar becomeFirstResponder];
    [self.searchDisplayController setActive:YES];
}

- (void)applyAppearance
{
    // SearchBar
    // In navigationBar
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES; // Since the searchBar is in navBar, use self.navigationController.searchDisplayController hierarchy!
    // Change icons
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"Search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchDisplayController.searchBar setImage:[UIImage imageNamed:@"Close"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    // Background of the textField in searchBar
    [self.searchDisplayController.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"Input"] forState:UIControlStateNormal];
    // Change text color and font (Obecný zápis, každá TextField v tomto searchBaru bude nastaven touto hodnotou)
    [[UITextField appearanceWhenContainedIn:[self.navigationController.searchDisplayController.searchBar class], nil] setTextColor:UIColorWithRGB(0x2f91ff)];
    [[UITextField appearanceWhenContainedIn:[self.navigationController.searchDisplayController.searchBar class], nil] setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:16]];
    
    // Placeholder color
    // [[UILabel appearanceWhenContainedIn:[self.navigationController.searchDisplayController.searchBar class], nil] setTextColor:UIColorWithRGB(0x2f91ff)];
    
    // Cursor color
    [[UITextField appearanceWhenContainedIn:[self.navigationController.searchDisplayController.searchBar class], nil] setTintColor:UIColorWithRGB(0x2f91ff)];
    
    // NavigationBar
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"Line"];
    // setBackgroundImage must be defined to use to the image shadowImage method
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    // No translucency (Do NOT forget to extend edges under opaqueBars -extendedLayoutIncludesOpaqueBars, i already set it in storyBoard). Dojde k rozšíření hran pod neprůhledné bary, kterým je i navigationBar (potom co ho tak nastavím)
    [self.navigationController.navigationBar setTranslucent:false];
    
    // Add custom button next to searchBar
    _closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
    [_closeBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Rugular" size:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:_closeBtn];
}

- (void)close
{
    // Vertical transition backwards
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Hide the keyboard now
    [self.searchDisplayController.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - SearchLocation client + searchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // Get the JSON GeoNames record
    SearchLocationHTTPClient *client = [SearchLocationHTTPClient sharedSearchLocationHTTPClient];
    client.delegate = self;
    [client updateResultsWithString:searchText];
    
    // Will highlight text in cells by this string
    _searchBarText = searchText;
}

- (void)searchLocationHTTPClient:(SearchLocationHTTPClient *)client didUpdateWithResults:(id)results
{
    self.cities = results;
    
    // Reload tableView after a new JSON record
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    // NSDictionary *firstResult = self.cities.currentResults[0];
    // NSLog(@"City: %@, Country: %@, lat: %@, lng: %@", firstResult.cityName, firstResult.countryName, firstResult.latitude, firstResult.longitude);
}

#pragma mark - Table view

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-top"]];
    separator.frame = CGRectMake(0, 0, 736, 1); // max width (iP6+) is 736p so its easiest to do set is fixed since we dont have a landscape mod in the app
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:separator];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-top"]];
    separator.frame = CGRectMake(0, 0, 736, 1); // max width (iP6+) is 736p so its easiest to do set is fixed since we dont have a landscape mod in the app
    
    UIView *footerView = [[UIView alloc] init];
    [footerView addSubview:separator];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cities.currentResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Values
    NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Pick up a cell style
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    // CONFIGURE A CELL
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-mid"]];
    separator.frame = CGRectMake(0, 0, 736, 0); // max width (iP6+) is 736p so its easiest to do set is fixed since we dont have a landscape mod in the app
    [cell.contentView addSubview:separator];
    
    // Size, Color, Font
    cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Light" size:17];
    cell.textLabel.textColor = UIColorWithRGB(333333); // Hexadecimal starts with 0x
    
    // Text
    NSDictionary *resultAtPosition = self.cities.currentResults[indexPath.row];
    // cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", resultAtPosition.cityName, resultAtPosition.countryName];
    
    // Highlight match in city name
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:resultAtPosition.cityName];
    NSRange range = [resultAtPosition.cityName rangeOfString:_searchBarText];
    [attributedString addAttribute: NSFontAttributeName value:[UIFont fontWithName:@"ProximaNova-Semibold" size:17] range:range];
    NSAttributedString *makeAttStringFromString = [[NSAttributedString alloc] initWithString:resultAtPosition.countryName attributes:nil];
    // Missing format method for NSAttributedString so
    [[attributedString mutableString] appendString:@", "];
    [attributedString appendAttributedString:makeAttStringFromString];
    
    cell.textLabel.attributedText = attributedString;
    
    // Footer
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Unselect a cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Selected result
    NSDictionary *resultAtPosition = self.cities.currentResults[indexPath.row];
    
    // Set NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Create local array
    NSMutableArray *cities = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"Cities"]];
    // Add a new record
    [cities addObject:resultAtPosition];
    // Save it to NSUserDefaults
    [defaults setObject:cities forKey:@"Cities"];
    
    // NSLog(@"Cell with lat:%@ and lng:%@", resultAtPosition.latitude, resultAtPosition.longitude);
    
    // Close the searchBar
    [self close];
}

@end
