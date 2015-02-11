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

@interface UIImage(drawing)
+ (instancetype)imageWithView:(UIView *)view;
@end

@implementation UIView (SwipeableActions)

- (void)setSwipeDeleteEnabled:(BOOL)enabled
{
	if (enabled) {
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureTriggered:)];
		swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
		[self addGestureRecognizer:swipeGesture];
		
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTriggered:)];
		[self addGestureRecognizer:tapGesture];

		self.swipeScrollView.alpha = 0.0f;
	} else {
		[self setGestureRecognizers:nil];
		[self.swipeScrollView removeFromSuperview];
	}
}

- (UIScrollView *)swipeScrollView
{
	UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kSwipeScrollViewTag];
	if (!scrollView) {
		scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		scrollView.backgroundColor = [UIColor whiteColor];
		scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		scrollView.tag = kSwipeScrollViewTag;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.delegate = self;
		scrollView.delaysContentTouches = NO;
		[self addSubview:scrollView];
	}
	return scrollView;
}

- (UIImageView *)swipeImageView
{
	UIImageView *imageView = (UIImageView *)[self viewWithTag:kSwipeImageViewTag];
	if (!imageView) {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithView:self]];
		imageView.tag = kSwipeImageViewTag;
		[self.swipeScrollView addSubview:imageView];
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
		button.backgroundColor = [UIColor redColor];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button setTitle:@"Delete" forState:UIControlStateNormal];
		[button addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self.swipeScrollView insertSubview:button belowSubview:self.swipeImageView];
	}
	return button;
}

- (void)swipeGestureTriggered:(UISwipeGestureRecognizer *)sender
{
	[self.swipeImageView setNeedsDisplay];
	self.swipeScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kSwipeActionWidth, CGRectGetHeight(self.bounds));
	self.swipeScrollView.alpha = 1.0f;
}

- (void)tapGestureTriggered:(UITapGestureRecognizer *)sender
{
	UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kSwipeScrollViewTag];
	if (scrollView && scrollView.contentOffset.x >= kSwipeActionWidth) {
		[self closeScrollViewAnimated:YES];
	}
}

- (void)actionPressed:(id)sender
{
	[self closeScrollViewAnimated:YES];
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView.contentOffset.x < kSwipeActionWidth && !decelerate) {
		[self closeScrollViewAnimated:YES];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if (scrollView.contentOffset.x < kSwipeActionWidth) {
		[self closeScrollViewAnimated:YES];
	}
}

- (void)closeScrollViewAnimated:(BOOL)animated
{
	[UIView animateWithDuration:0.1f animations:^{
		self.swipeScrollView.alpha = 0.0f;
		self.swipeScrollView.contentOffset = CGPointZero;
	} completion:^(BOOL finished) {
		[self.swipeScrollView removeFromSuperview];
	}];
}

@end

@implementation UIImage(drawing)

+ (UIImage *)imageWithView:(UIView *)view
{
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

@end
