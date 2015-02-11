//
//  ViewController.m
//  SwipeActions
//
//  Created by Gabriel O'Flaherty-Chan on 2015-02-11.
//  Copyright (c) 2015 Gabrieloc. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SwipeableActions.h"

@interface ViewController () <UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *someView;
@property (strong, nonatomic) IBOutlet UIView *someOtherView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.someView setSwipeDeleteEnabled:YES];
	[self.someOtherView setSwipeDeleteEnabled:YES];
//	[self.tableView setSwipeDeleteEnabled:YES];
	
	self.tableView.dataSource = self;
	[self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	cell.textLabel.text = [NSString stringWithFormat:@"Cell %@", @(indexPath.row)];
	[cell setSwipeDeleteEnabled:YES];
	return cell;
}

@end
