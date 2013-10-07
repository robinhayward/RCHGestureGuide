//
//  RCHButton.m
//  RCHGestureGuide
//
//  Created by Rob Hayward on 07/10/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import "RCHButton.h"

@implementation RCHButton

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    [self setBackgroundColor:[UIColor blueColor]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitle:@"Show Gesture Guide" forState:UIControlStateNormal];
    [[self layer] setCornerRadius:5.0f];
  }
  return self;
}

- (void)didMoveToSuperview
{
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  id a = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  id b = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  id c = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeWidth multiplier:1 constant:-60];
  id d = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight   multiplier:1 constant:44];
  [self.superview addConstraints:@[a, b, c, d]];
}


@end
