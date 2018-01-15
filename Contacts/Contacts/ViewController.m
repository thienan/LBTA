//
//  ViewController.m
//  Contacts
//
//  Created by Ihar Tsimafeichyk on 11/21/17.
//  Copyright © 2017 home. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static NSString *cellID = @"CellID";
NSArray *names = nil;

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Show IndexPath"           style:UIBarButtonItemStylePlain target:self action:@selector(handleShowIndexPath)];
    
    [self setupNavigationBarStyle];
    [self initData];
    [self.tableView registerClass:UITableViewCell.self forCellReuseIdentifier:cellID];
}

#pragma mark - Data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"Header"];
    [label setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:235.0/255.0 blue:243.0/255 alpha:1]];
    return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [names count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [names[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    
    if (showIndexPath) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ , Section: %@ Row: %@",
                                 [names[indexPath.section] objectAtIndex:indexPath.row],
                                 @(indexPath.section),
                                 @(indexPath.row)]];
    } else {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",
                                 [names[indexPath.section] objectAtIndex:indexPath.row]
                                 ]];
    }
    
    
    [cell setBackgroundColor:[UIColor colorWithRed:45.0/255.0 green:165.0/255.0 blue:183.0/255 alpha:1]];
    return cell;
}

#pragma mark - Private Methods

- (void) setupNavigationBarStyle {
    [self.navigationItem setTitle:@"Contacts"];
    [self.navigationController.navigationBar  setPrefersLargeTitles:YES];
    UIColor *navBarTintColor = [UIColor colorWithRed:255.0/255.0 green:35.0/255.0 blue:47.0/255.0 alpha:1];
    [self.navigationController.navigationBar setBarTintColor:navBarTintColor];
}

- (void) initData {
    names = @[
              @[@"Amy", @"Bill", @"Zack", @"Steve", @"Jack",@"Jill", @"Mary"],
              @[@"Carl", @"Chris", @"Christian", @"Cameron"],
              @[@"David", @"Dan"],
              @[@"Patrik", @"Patty"]
            ];
}

static BOOL showIndexPath = NO;

-(void) handleShowIndexPath {
    NSLog(@"Reload data");
    
    NSMutableArray *indexPathToReload = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < names.count; i++) {
        for (int j = 0 ; j < [names[i] count]; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [indexPathToReload addObject:indexPath];
        }
    }
    
    showIndexPath = !showIndexPath;
    
    UITableViewRowAnimation rowAnimation = showIndexPath ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
    
    [self.tableView reloadRowsAtIndexPaths:indexPathToReload withRowAnimation:rowAnimation];
}


@end
