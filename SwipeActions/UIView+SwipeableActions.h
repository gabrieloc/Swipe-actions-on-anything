//
//  UIView+SwipeableActions.h
//  SwipeActions
//
//  Created by Gabriel O'Flaherty-Chan on 2015-02-11.
//  Copyright (c) 2015 Gabrieloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwipeActions <NSObject>
@end

@interface UIView (SwipeableActions)

- (void)setSwipeDeleteEnabled:(BOOL)enabled;
- (void)endEditingAnimated:(BOOL)animated;

@property (strong, readonly) UIButton *actionButton;

@end
