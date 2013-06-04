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
    [self setBackgroundColor:[UIColor blackColor]];
    [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self setTitle:@"Stop showing these gestures" forState:UIControlStateNormal];
    [[self layer] setCornerRadius:5.0f];
    [self setClipsToBounds:YES];
  }
  return self;
}

@end
