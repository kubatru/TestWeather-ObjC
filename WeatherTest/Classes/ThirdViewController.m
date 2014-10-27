//
//  ThirdViewController.m
//  WeatherTest
//
//  Created by Jakub Truhlar on 09.10.14.
//  Copyright (c) 2014 Jakub Truhlar. All rights reserved.
//

#import "ThirdViewController.h"
#import "Macros.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    
    // Change graphics
    [self applyAppearance];
    
    // Swipe gesture
    [self swipeGesture];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)applyAppearance
{
    // programmatically added image for selected state and set the font
    // [UITabBarItem alloc].selectedImage = [UIImage imageNamed:@"SettingsSelected"];
    [self.tabBarController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Semibold" size:10], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    // Title in the NavigationBar
    self.title = @"Settings";
    
    // Set navigationBar's title font, color and size
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ProximaNova-Semibold" size:18],NSFontAttributeName, UIColorWithRGB(333333),NSForegroundColorAttributeName, nil]];
    
    // NavigationBar
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"Line"];
    // setBackgroundImage must be defined to use to the image shadowImage method
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    // Footer Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-top"]];
    separator.frame = CGRectMake(0, 0, 736, 1); // max width (iP6+) is 736p so its easiest to do set is fixed since we dont have a landscape mod in the app
    self.tableView.tableFooterView = separator;
}

#pragma mark - tableView

// Section text
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Text
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 11, 320, 50);
    myLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14];
    myLabel.textColor = UIColorWithRGB(0x2f91ff); // Hexadecimal starts with 0x
    myLabel.text = @"GENERAL";
    
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-top"]];
    separator.frame = CGRectMake(0, 50, 736, 1); // max width (iP6+) is 736p so its easiest to do set is fixed since we dont have a landscape mod in the app
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    [headerView addSubview:separator];
    // Header background so the tableView can be dynamic and it will looks still great
    headerView.backgroundColor = [UIColor whiteColor];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Values
    NSString *CellIdentifier = @"Cell";
    _cellsTitle = [NSArray arrayWithObjects:@"Unit of length",@"Unit of temperature",nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *distanceValue = [defaults objectForKey:@"DistanceValue"];
    NSString *temperatureValue = [defaults objectForKey:@"TemperatureValue"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Pick up a cell style
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    // CONFIGURE A CELL
    // Separator
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divider-mid"]];
    separator.frame = CGRectMake(15, 0, 736, 1); // max width (iP6+) is 736p so its easiest to do set is fixed since we dont have a landscape mod in the app
    [cell.contentView addSubview:separator];
    
    // Size, Color, Font
    cell.textLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:17];
    cell.textLabel.textColor = UIColorWithRGB(333333); // Hexadecimal starts with 0x
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"ProximaNova-Regular" size:17];
    cell.detailTextLabel.textColor = UIColorWithRGB(0x2f91ff); // Hexadecimal starts with 0x
    
    // Text
    cell.textLabel.text = [_cellsTitle objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = distanceValue;
    }
    
    else {
        cell.detailTextLabel.text = temperatureValue;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Unselect a cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Change the settings
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    defaults = [NSUserDefaults standardUserDefaults];
    
    // ActionSheets iOS7
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        iOS7actionSheetcell = [tableView cellForRowAtIndexPath:indexPath];
        if ([tableView indexPathForCell:cell].row == 0) {
            
            // Length ActionSheet
            UIActionSheet *actionSheetLength = [[UIActionSheet alloc] initWithTitle:@"Unit of length" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Meters", @"Feet", nil];
            actionSheetLength.tag = 1;
            [actionSheetLength showInView:[UIApplication sharedApplication].keyWindow];
        }
        
        else if ([tableView indexPathForCell:cell].row == 1) {
            
            // Temperature ActionSheet
            UIActionSheet *actionSheetTemperature = [[UIActionSheet alloc] initWithTitle:@"Unit of temperature" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Celsius", @"Fahrenheit", nil];
            actionSheetTemperature.tag = 2;
            [actionSheetTemperature showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
    
    // ActionSheets iOS8+
    else {
        
        if ([tableView indexPathForCell:cell].row == 0) {
            
            // Length ActionSheet
            UIAlertController *actionSheetLength = [UIAlertController alertControllerWithTitle:@"Unit of length" message:@"Select your unit" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *meters = [UIAlertAction actionWithTitle:@"Meters" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                cell.detailTextLabel.text = @"Meters";
                [defaults setObject:@"Meters" forKey:@"DistanceValue"];
                [actionSheetLength dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction *feet = [UIAlertAction actionWithTitle:@"Feet" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.detailTextLabel.text = @"Feet";
                [defaults setObject:@"Feet" forKey:@"DistanceValue"];
                [actionSheetLength dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [actionSheetLength dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [actionSheetLength addAction:meters];
            [actionSheetLength addAction:feet];
            [actionSheetLength addAction:cancel];
            [self presentViewController:actionSheetLength animated:YES completion:nil];
        }
        
        else if ([tableView indexPathForCell:cell].row == 1) {
            
            // Temperature ActionSheet
            UIAlertController *actionSheetTemperature = [UIAlertController alertControllerWithTitle:@"Unit of temperature" message:@"Select your unit" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *celsius = [UIAlertAction actionWithTitle:@"Celsius" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                cell.detailTextLabel.text = @"Celsius";
                [defaults setObject:@"Celsius" forKey:@"TemperatureValue"];
                [actionSheetTemperature dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction *fahrenheit = [UIAlertAction actionWithTitle:@"Fahrenheit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                cell.detailTextLabel.text = @"Fahrenheit";
                [defaults setObject:@"Fahrenheit" forKey:@"TemperatureValue"];
                [actionSheetTemperature dismissViewControllerAnimated:YES completion:nil];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [actionSheetTemperature dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [actionSheetTemperature addAction:celsius];
            [actionSheetTemperature addAction:fahrenheit];
            [actionSheetTemperature addAction:cancel];
            [self presentViewController:actionSheetTemperature animated:YES completion:nil];
        }
    }
}

#pragma mark - iOS 7- ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    iOS7actionSheetcell.detailTextLabel.text = @"Meters";
                    [defaults setObject:@"Meters" forKey:@"DistanceValue"];
                    break;
                case 1:
                    iOS7actionSheetcell.detailTextLabel.text = @"Feet";
                    [defaults setObject:@"Feet" forKey:@"DistanceValue"];
                    break;
                default:
                    break;
            }
            break;
        }
        case 2: {
            switch (buttonIndex) {
                case 0:
                    iOS7actionSheetcell.detailTextLabel.text = @"Celsius";
                    [defaults setObject:@"Celsius" forKey:@"TemperatureValue"];
                    break;
                case 1:
                    iOS7actionSheetcell.detailTextLabel.text = @"Fahrenheit";
                    [defaults setObject:@"Fahrenheit" forKey:@"TemperatureValue"];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Gestures

- (void)swipeGesture {
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeftRecognizer];
}

- (void)swipeRight {
    [self.tabBarController setSelectedIndex:([self.tabBarController selectedIndex] - 1)];
}

- (void)swipeLeft {
    [self.tabBarController setSelectedIndex:([self.tabBarController selectedIndex] + 1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
