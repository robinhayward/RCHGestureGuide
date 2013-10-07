//
//  RCHViewController.m
//  RCHGestureGuide
//
//  Created by Rob Hayward on 04/06/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import "RCHViewController.h"
#import "RCHGestureGuide.h"
#import "RCHButton.h"

@implementation RCHViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.button = [[RCHButton alloc] init];
  [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:_button];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self showGestureGuide];
}

- (void)showGestureGuide
{
  [RCHGestureGuide showGestures:@[RCHGesturePinch, RCHGestureSwipe, RCHGestureSpread, RCHGestureRotate, RCHGestureTap] forKey:@"Home"];
}

#pragma mark - Action

- (void)buttonAction
{
  [RCHGestureGuide reset];
  [self showGestureGuide];
}

@end
