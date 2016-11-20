//
//  SJRootTableViewController.m
//  SJLocation
//
//  Created by shejun.zhou on 15/10/12.
//  Copyright © 2015年 shejun.zhou. All rights reserved.
//

#import "SJRootTableViewController.h"
#import "SJDetailViewController.h"
#import "SJLocation.h"

@interface SJRootTableViewController ()

@property (nonatomic, strong, nonnull) NSArray *dataArray;

@end

@implementation SJRootTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _dataArray = [NSArray arrayWithObjects:@"GPS", nil];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SJRootTableViewCellIdentify" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _dataArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            __weak SJRootTableViewController *weakSelf = self;
            SJLocation *locationManager = [SJLocation sharedLocationManager];
            locationManager.autoStopLocation = YES;
            [locationManager requestLocationCompleteHandler:^(NSDictionary *addressDictionary) {
                
                NSString *street = nil;
                if ([[addressDictionary allKeys] containsObject:@"Street"]) {
                    street = [NSString stringWithFormat:@"%@", addressDictionary[@"Street"]];
                }else if ([[addressDictionary allKeys] containsObject:@"Name"]) {
                    street = [NSString stringWithFormat:@"%@", addressDictionary[@"Name"]];
                }
                NSString *location = [NSString stringWithFormat:@"%@-%@-%@-%@", addressDictionary[@"State"],
                                      addressDictionary[@"City"],
                                      addressDictionary[@"SubLocality"],
                                      street];
                
                NSLog(@"显示地址：%@", location);
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SJDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"SJDetailViewController"];
                detailVC.fileName = _dataArray[indexPath.row];
                detailVC.locationText = location;
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
