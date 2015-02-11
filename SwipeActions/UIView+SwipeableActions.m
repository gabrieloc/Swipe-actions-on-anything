//
//  UIView+SwipeableActions.m
//  SwipeActions
//
//  Created by Gabriel O'Flaherty-Chan on 2015-02-11.
//  Copyright (c) 2015 Gabrieloc. All rights reserved.
//

#import "UIView+SwipeableActions.h"

static NSUInteger const kSwipeScrollViewTag = 100;
static NSUInteger const kSwipeImageViewTag = 101;
static NSUInteger const kSwipeButtonTag = 102;
static CGFloat const kSwipeActionWidth = 60.0f;

@interface UIView() <UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *swipeScrollView;
@property (strong, nonatomic) UIImageView *swipeImageView;
@end

@implementation UIView (SwipeableActions)

- (void)setSwipeDeleteEnabled:(BOOL)enabled
{
	if (enabled) {
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTriggered:)];
		tapGesture.cancelsTouchesInView = NO;
		[self addGestureRecognizer:tapGesture];

		[self addSubview:self.swipeScrollView];
		[self.swipeScrollView addSubview:self.swipeImageView];
		self.swipeImageView.hidden = YES;
		[self.swipeScrollView insertSubview:self.actionButton belowSubview:self.swipeImageView];
		self.actionButton.hidden = YES;
	} else {
		[self setGestureRecognizers:nil];
		[[self viewWithTag:kSwipeButtonTag] removeFromSuperview];
		[[self viewWithTag:kSwipeImageViewTag] removeFromSuperview];
		[[self viewWithTag:kSwipeScrollViewTag] removeFromSuperview];
	}
}

- (UIScrollView *)swipeScrollView
{
	UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kSwipeScrollViewTag];
	if (!scrollView) {
		scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		scrollView.backgroundColor = [UIColor clearColor];
		scrollView.tag = kSwipeScrollViewTag;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.delegate = self;
		scrollView.delaysContentTouches = NO;
		scrollView.contentSize = CGSizeMake(HUGE_VALF, 0); // Fixes issue with UITableViewCells
	}
	return scrollView;
}

- (UIImageView *)swipeImageView
{
	UIImageView *imageView = (UIImageView *)[self viewWithTag:kSwipeImageViewTag];
	if (!imageView) {
		imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		imageView.tag = kSwipeImageViewTag;
	}
	return imageView;
}

- (UIButton *)actionButton
{
	UIButton *button = (UIButton *)[self viewWithTag:kSwipeButtonTag];
	if (!button) {
		button = [UIButton buttonWithType:UIButtonTypeSystem];
		button.frame = CGRectMake(CGRectGetWidth(self.bounds) - kSwipeActionWidth, 0.0f, kSwipeActionWidth, CGRectGetHeight(self.bounds));
		button.tag = kSwipeButtonTag;
		button.backgroundColor = [UIColor blueColor];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button setTitle:@"Action" forState:UIControlStateNormal];
		[button addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
	return button;
}

- (void)tapGestureTriggered:(UITapGestureRecognizer *)sender
{
	UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kSwipeScrollViewTag];
	if (scrollView && scrollView.contentOffset.x >= kSwipeActionWidth) {
		[self endEditingAnimated:YES];
	}
}

- (void)actionPressed:(id)sender
{
	[self endEditingAnimated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.x < 0) {
		scrollView.contentOffset = CGPointZero;
	}
 
	self.actionButton.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - kSwipeActionWidth),
										 0.0f,
										 kSwipeActionWidth,
										 CGRectGetHeight(self.bounds));
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.x == 0) {
		[self updateImageViewRaster];
		self.swipeImageView.hidden = NO;
		self.actionButton.hidden = NO;
		self.swipeScrollView.backgroundColor = [UIColor whiteColor];
		
		self.swipeScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kSwipeActionWidth, CGRectGetHeight(self.bounds));
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView.contentOffset.x < kSwipeActionWidth && !decelerate) {
		[self endEditingAnimated:YES];
	}
}

- (void)endEditingAnimated:(BOOL)animated
{
	[UIView animateWithDuration:0.2f animations:^{
		self.swipeScrollView.contentOffset = CGPointZero;
	} completion:^(BOOL finished) {
		self.swipeImageView.hidden = YES;
		self.actionButton.hidden = YES;
		self.swipeScrollView.backgroundColor = [UIColor clearColor];
	}];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

#pragma mark - Helpers

- (void)updateImageViewRaster
{
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	self.swipeImageView.image = image;
}

@end

