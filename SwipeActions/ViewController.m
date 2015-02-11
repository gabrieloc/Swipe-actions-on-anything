//
//  ViewController.m
//  SwipeActions
//
//  Created by Gabriel O'Flaherty-Chan on 2015-02-11.
//  Copyright (c) 2015 Gabrieloc. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SwipeableActions.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *someView;
@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.someView setSwipeDeleteEnabled:YES];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
