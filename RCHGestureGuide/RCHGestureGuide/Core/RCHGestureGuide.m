//
//  RCHGestureGuide.m
//  RCHGestureGuide
//
//  Created by Rob Hayward on 04/06/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import "RCHGestureGuide.h"
#import "RCHGestureGuideView.h"
#import "RCHGestureGuideButton.h"
#import <QuartzCore/QuartzCore.h>
#import <AvailabilityMacros.h>

#define RCH_SCREEN_ANIMATION_DELAY 0.15
#define RCH_GESTURE_ON_SCREEN 1.25
#define RCH_GESTURE_ANIMATION_DURATION_FADE_IN 0.3
#define RCH_GESTURE_ANIMATION_DURATION_FADE_OUT 0.2

NSString *const RCHGestureGuideDefaults = @"RCHGestureGuideDefaults";
NSString *const RCHGesturePinch = @"RCHGesturePinch";
NSString *const RCHGestureSwipe = @"RCHGestureSwipe";
NSString *const RCHGestureSpread = @"RCHGestureSpread";
NSString *const RCHGestureTap = @"RCHGestureTap";
NSString *const RCHGestureRotate = @"RCHGestureRotate";

@interface RCHGestureGuide ()
{
  BOOL _isPresenting;
  BOOL _shouldCancelPresenting;
  BOOL _shouldRestart;
  RCHGestureGuideBackdropType _backdropType;
  UIDeviceOrientation _orientation;
}

@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIView *applicationTopMostView;
@property (strong, nonatomic) UIWindow *overlayWindow;
@property (strong, nonatomic) UIButton *stopButton;
@property (strong, nonatomic) NSString *interfaceKey;
@property (strong, nonatomic) NSArray *requestedGestures;
@property (strong, nonatomic) NSMutableArray *animations;
@property (strong, nonatomic) UIImageView *currentGestureView;

@end

@implementation RCHGestureGuide

#pragma mark - Class Methods

+ (RCHGestureGuide *)shared
{
  static dispatch_once_t once;
  static RCHGestureGuide *shared;
  dispatch_once(&once, ^ { shared = [[RCHGestureGuide alloc] init]; });
  return shared;
}

+ (void)showGestures:(NSArray *)gestures forKey:(NSString *)key
{
  [[RCHGestureGuide shared] showWithGestures:gestures forInterfaceKey:key];
}

+ (void)reset
{
  [[RCHGestureGuide shared] reset];
}

- (void)restart
{
  _shouldRestart = YES;
  [self cancel];
}

- (void)willRestart
{
  _shouldRestart = NO;
  [self showWithGestures:_requestedGestures forInterfaceKey:_interfaceKey];
}

#pragma mark - Instance Methods

- (id)init
{
  self = [super init];
  if (self)
  {
    [self defaults];
    [self notifications];
  }
  return self;
}

- (void)defaults
{
  _backdropType = RCHGestureGuideBackdropGradient;
  _shouldCancelPresenting = NO;
  _isPresenting = NO;
  _dismissButtonTitle = @"Stop showing these gestures";
  _screenAnimationDelayDuration = RCH_SCREEN_ANIMATION_DELAY;
  _gestureOnScreenDuration = RCH_GESTURE_ON_SCREEN;
  _gestureAnimationDurationIn = RCH_GESTURE_ANIMATION_DURATION_FADE_IN;
  _gestureAnimationDurationOut = RCH_GESTURE_ANIMATION_DURATION_FADE_OUT;
}

#pragma mark - Notifications

- (void)notifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationDidChange:(NSNotification *)notification
{
  UIDeviceOrientation newOrientation = [[UIDevice currentDevice] orientation];
  switch (newOrientation)
  {
    case UIDeviceOrientationUnknown:
    case UIDeviceOrientationFaceDown:
    case UIDeviceOrientationFaceUp:
      break;
    default:
    {
      if (_orientation != newOrientation)
      {
        _orientation = newOrientation;
        [self restart];
      }
    }
      break;
  }
}

#pragma mark - Getters

- (UIView *)applicationTopMostView
{
  if (_applicationTopMostView != nil) { return _applicationTopMostView; }
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  UIViewController *viewController = [window rootViewController];
  self.applicationTopMostView  = viewController.view;
  return _applicationTopMostView;
}

- (UIView *)view
{
  if (_view != nil) { return _view; }
  _view = [[RCHGestureGuideView alloc] init];
  return _view;
}

#pragma mark - Actions

- (void)reset
{
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCHGestureGuideDefaults];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cancel
{
  if (!_isPresenting) { return; }
  
  _shouldCancelPresenting = YES;
  
  [[_view layer] removeAllAnimations];
  [_view removeFromSuperview];
  [[_currentGestureView layer] removeAllAnimations];
  if (!_shouldRestart)
  {
    _interfaceKey = nil;
    _requestedGestures = nil;
  }
}

- (void)cancelDidComplete
{
  _shouldCancelPresenting = NO;
  _isPresenting = NO;
  if (_shouldRestart)
  {
    [self willRestart];
  }
}

- (void)dismiss
{
  [_view removeFromSuperview];
  _view = nil;
  _applicationTopMostView = nil;
  _stopButton = nil;
  _animations = nil;
}

- (void)showWithGestures:(NSArray *)gestures forInterfaceKey:(NSString *)key
{
  if (gestures == nil) { return; }
  if (_isPresenting) { return; }
  if (![self shouldShowGesturesForKey:key]) { return; }
  
  self.interfaceKey = key;
  self.requestedGestures = gestures;
  
  _isPresenting = YES;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    if(!self.view.superview) {
      
      [self.applicationTopMostView addSubview:_view];
    }
    [self.applicationTopMostView setHidden:NO];
    [self.stopButton setHidden:NO];
    
    if(_view.alpha != 1) {
      
      [UIView animateWithDuration:_screenAnimationDelayDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _view.alpha = 1;
        
      } completion:^(BOOL finished){
        
        [self animateGestures:_requestedGestures];
        
      }];
    }
    
    [_view setNeedsDisplay];
  });
}

#pragma mark - Animate Gestures

- (void)animateGestures:(NSArray *)gestures
{
  if (gestures != nil)
  {
    self.animations = [NSMutableArray arrayWithArray:gestures];
  }
  NSInteger count = [_animations count];
  if (count > 0)
  {
    NSString *key = [_animations objectAtIndex:0];
    [self showGestureForKey:key withCompletion:^(BOOL finished) {
      
      if (!_shouldCancelPresenting)
      {
        [_animations removeObjectAtIndex:0];
        [self animateGestures:nil];
      }
      else {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.0f];
        [self cancelDidComplete];
      }
      
    }];
    return;
  }
  [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.0f];
  [self cancelDidComplete];
}

- (void)showGestureForKey:(NSString *)key withCompletion:(void (^)(BOOL finished))completion
{
  dispatch_async(dispatch_get_main_queue(), ^{

    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", key]];
    self.currentGestureView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [_currentGestureView setImage:image];
    [_currentGestureView setCenter:_view.center];
    [[_currentGestureView layer] setOpacity:0.0f];
    [_view addSubview:_currentGestureView];
    
    [UIView animateWithDuration:_gestureAnimationDurationIn delay:0.0f options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
      
      [[_currentGestureView layer] setOpacity:1.0f];
      
    } completion:^(BOOL finished) {
      
      [UIView animateWithDuration:_gestureAnimationDurationOut delay:_gestureOnScreenDuration options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        [[_currentGestureView layer] setOpacity:0.0f];
        
      } completion:^(BOOL finished) {
        
        completion(YES);
        
      }];
      
    }];
    
  });
}

#pragma mark - Getters

- (UIButton *)stopButton
{  
  if (_stopButton != nil) { return _stopButton; }
  
  self.stopButton = [[RCHGestureGuideButton alloc] init];
  [_stopButton addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
  [_stopButton setTitle:_dismissButtonTitle forState:UIControlStateNormal];
  [_view addSubview:_stopButton];
  return _stopButton;
}

- (BOOL)shouldShowGesturesForKey:(NSString *)key
{ 
  NSMutableDictionary *settings = [[NSUserDefaults standardUserDefaults] objectForKey:RCHGestureGuideDefaults];
  if (!settings) {
    return YES;
  }
  
  NSNumber *setting = [settings objectForKey:key];
  if (setting) {
    if ([setting boolValue] == NO) {
      return NO;
    }
  }
  return YES;
}

#pragma mark - Actions

- (void)stopAction:(id)sender
{  
  NSDictionary *savedSettings = [[NSUserDefaults standardUserDefaults] objectForKey:RCHGestureGuideDefaults];
  if (!savedSettings) {
    savedSettings = [NSMutableDictionary dictionaryWithCapacity:0];
  }
  
  NSMutableDictionary *settings = [savedSettings mutableCopy];
  
  [settings setObject:[NSNumber numberWithBool:NO] forKey:_interfaceKey];
  [[NSUserDefaults standardUserDefaults] setObject:settings forKey:RCHGestureGuideDefaults];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [self cancel];
}

@end
