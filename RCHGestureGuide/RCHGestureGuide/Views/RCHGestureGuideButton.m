//
//  RCHGestureGuideButton.m
//  RCHGestureGuide
//
//  Created by Rob Hayward on 04/06/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import "RCHGestureGuideButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation RCHGestureGuideButton

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    [self setBackgroundColor:[UIColor redColor]];
    [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [[self layer] setCornerRadius:5.0f];
    [self setClipsToBounds:YES];
  }
  return self;
}

- (void)didMoveToSuperview
{
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  id a = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  id b = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-64];
  id c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:-60];
  id d = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:44];
  [self.superview addConstraints:@[a, b, c, d]];
}

@end
