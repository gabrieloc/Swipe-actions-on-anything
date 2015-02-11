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
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@end

@interface UIImage(drawing)
+ (instancetype)imageWithView:(UIView *)view;
@end

@implementation UIView (SwipeableActions)

- (void)setSwipeDeleteEnabled:(BOOL)enabled
{
	if (enabled) {
		UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTriggered:)];
		swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
		[self addGestureRecognizer:swipeGesture];
		[self createSubviews];
		[self setSubviewsHidden:YES];
	} else {
		[self setGestureRecognizers:nil];
		[self destroySubviews];
	}
}

- (UIScrollView *)scrollView
{
	UIScrollView *scrollView = (UIScrollView *)[self viewWithTag:kSwipeScrollViewTag];
	if (!scrollView) {
		scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		scrollView.tag = kSwipeScrollViewTag;
		scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kSwipeActionWidth, CGRectGetHeight(self.bounds));
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.delegate = self;
	}
	return scrollView;
}

- (UIImageView *)imageView
{
	UIImageView *imageView = (UIImageView *)[self viewWithTag:kSwipeImageViewTag];
	if (!imageView) {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithView:self]];
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
		button.backgroundColor = [UIColor redColor];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button setTitle:@"Delete" forState:UIControlStateNormal];
		[button addTarget:self action:@selector(actionPressed:) forControlEvents:UIControlEventTouchUpInside];
	}
	return button;
}

- (void)createSubviews
{
//	[self addSubview:self.actionButton];
	[self addSubview:self.scrollView];
	[self.scrollView addSubview:self.imageView];
	[self.scrollView insertSubview:self.actionButton belowSubview:self.imageView];
}

- (void)destroySubviews
{
	[self.scrollView removeFromSuperview];
	[self.imageView removeFromSuperview];
	[self.actionButton removeFromSuperview];
}

- (void)setSubviewsHidden:(BOOL)hidden
{
	self.scrollView.hidden = hidden;
	self.actionButton.hidden = hidden;
}

- (void)gestureTriggered:(id)sender
{
	[self setSubviewsHidden:NO];
}

- (void)actionPressed:(id)sender
{
	[self setSubviewsHidden:YES];
	[self destroySubviews];
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

@end

@implementation UIImage(drawing)

+ (UIImage *)imageWithView:(UIView *)view
{
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return img;
}

@end
