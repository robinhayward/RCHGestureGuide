//
//  RCHViewController.m
//  RCHGestureGuide
//
//  Created by Rob Hayward on 04/06/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import "RCHViewController.h"
#import "RCHGestureGuide.h"

@implementation RCHViewController

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self showGestureGuide];
}

- (void)showGestureGuide
{
  [RCHGestureGuide showGestures:@[RCHGesturePinch, RCHGestureSwipe, RCHGestureSpread, RCHGestureRotate, RCHGestureTap] forKey:@"Home"];
}

- (IBAction)showGestureGuideButtonAction:(id)sender
{
  [RCHGestureGuide reset];
  [self showGestureGuide];
}

@end
