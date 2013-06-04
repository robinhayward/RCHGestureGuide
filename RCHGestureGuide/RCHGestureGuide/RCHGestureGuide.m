//
//  RCHGestureGuide.m
//  RCHGestureGuide
//
//  Created by Rob Hayward on 04/06/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import "RCHGestureGuide.h"
#import <QuartzCore/QuartzCore.h>

#define SCREEN_ANIMATION_DELAY 0.15
#define GESTURE_ON_SCREEN 1.25f
#define GESTURE_ANIMATION_DURATION_FADE_IN 0.3
#define GESTURE_ANIMATION_DURATION_FADE_OUT 0.2

NSString *const RCHGesturePinch = @"RCHGesturePinch";
NSString *const RCHGestureDrag = @"RCHGestureDrag";
NSString *const RCHGestureTap = @"RCHGestureTap";
NSString *const RCHGestureRotate = @"RCHGestureRotate";

@interface RCHGestureGuide ()
{
  BOOL _isPresenting;
  BOOL _shouldCancelPresenting;
  RCHGestureGuideBackdropType _backdropType;
}
@property (strong, nonatomic) UIWindow *overlayWindow;
@property (strong, nonatomic) UIButton *stopButton;
@property (strong, nonatomic) NSString *interfaceKey;
@property (strong, nonatomic) NSMutableArray *animations;

@end

@implementation RCHGestureGuide

#pragma mark - Class Methods

+ (RCHGestureGuide *)shared
{
  static dispatch_once_t once;
  static RCHGestureGuide *sharedInstance;
  dispatch_once(&once, ^ { sharedInstance = [[RCHGestureGuide alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
  return sharedInstance;
}

+ (void)showGestures:(NSArray *)gestures forKey:(NSString *)key
{
  [[RCHGestureGuide shared] showWithGestures:gestures forInterfaceKey:key];
}

+ (void)reset
{
  [[RCHGestureGuide shared] reset];
}

+ (void)cancel
{
  [[RCHGestureGuide shared] cancel];
}

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backdropType = RCHGestureGuideBackdropGradient;
    _shouldCancelPresenting = NO;
    _isPresenting = NO;
  }
  return self;
}

- (void)reset
{
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:RCHGestureGuideDefaults];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cancel
{
  if (!_isPresenting) { return; }
  
  _shouldCancelPresenting = YES;
}

- (void)cancelDidComplete
{
  _shouldCancelPresenting = NO;
  _isPresenting = NO;
}

- (void)showWithGestures:(NSArray *)gestures forInterfaceKey:(NSString *)key
{
  if (gestures == nil) { return; }
  if (_isPresenting) { return; }
  if (![self shouldShowGesturesForKey:key]) { return; }
  
  self.interfaceKey = key;
  
  _isPresenting = YES;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    
    if(!self.superview) {
      
      [self.overlayWindow addSubview:self];
    }
    [self.overlayWindow makeKeyAndVisible];
    [self.overlayWindow setHidden:NO];
    [self.stopButton setHidden:NO];
    
    if(self.alpha != 1) {
      
      [UIView animateWithDuration:SCREEN_ANIMATION_DELAY delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.alpha = 1;
        
      } completion:^(BOOL finished){
        
        [self animateGestures:gestures];
        
      }];
    }
    
    [self setNeedsDisplay];
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
        [self cancelDidComplete];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.0f];
      }
      
    }];
    return;
  }
  [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.0f];
}

- (void)showGestureForKey:(NSString *)key withCompletion:(void (^)(BOOL finished))completion
{
  dispatch_async(dispatch_get_main_queue(), ^{

    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",key]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [imageView setImage:image];
    [imageView setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [[imageView layer] setOpacity:0.0f];
    [self addSubview:imageView];
    
    [UIView animateWithDuration:GESTURE_ANIMATION_DURATION_FADE_IN delay:0.0f options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
      
      [[imageView layer] setOpacity:1.0f];
      
    } completion:^(BOOL finished) {
      
      [UIView animateWithDuration:GESTURE_ANIMATION_DURATION_FADE_OUT delay:GESTURE_ON_SCREEN options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        [[imageView layer] setOpacity:0.0f];
        
      } completion:^(BOOL finished) {
        
        completion(YES);
        
      }];
      
    }];
    
  });
}

- (void)dismiss
{  
  [[self layer] removeAllAnimations];
  [self setAlpha:0.0f];
  [self setInterfaceKey:nil];
  [self setAnimations:nil];
  [self.overlayWindow setHidden:YES];
  
  if (!_shouldCancelPresenting) {
    [self cancelDidComplete];
  }
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  switch (_backdropType)
  {
    case RCHGestureGuideBackdropBlack:
    {
      [[UIColor colorWithWhite:0 alpha:0.5] set];
      CGContextFillRect(context, self.bounds);
      break;
    }
    case RCHGestureGuideBackdropGradient:
    {  
      size_t locationsCount = 2;
      CGFloat locations[2] = {0.0f, 1.0f};
      CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
      CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
      CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
      CGColorSpaceRelease(colorSpace);
      
      CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
      float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
      CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
      CGGradientRelease(gradient);
      
      break;
    }
     case RCHGestureGuideBackdropNone:
      break;
  }
}

#pragma mark - Getters

- (UIWindow *)overlayWindow
{
  if(_overlayWindow != nil) { return _overlayWindow; }
  
  self.overlayWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _overlayWindow.backgroundColor = [UIColor clearColor];
  _overlayWindow.userInteractionEnabled = YES;
  
  return _overlayWindow;
}

- (UIButton *)stopButton
{  
  if (_stopButton != nil) { return _stopButton; }

  self.stopButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 40.0f)];
  [_stopButton setBackgroundColor:[UIColor blackColor]];
  [[_stopButton titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0f]];
  [[_stopButton titleLabel] setTextAlignment:NSTextAlignmentCenter];
  [_stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [_stopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [_stopButton setTitle:@"Stop showing these gestures" forState:UIControlStateNormal];
  [_stopButton setCenter:CGPointMake(self.frame.size.width / 2, (self.frame.size.height - (_stopButton.frame.size.height * 1)))];
  [_stopButton addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
  [[_stopButton layer] setCornerRadius:5.0f];
  [_stopButton setClipsToBounds:YES];
  if(!_stopButton.superview) {
    [self addSubview:_stopButton];
  }
  
  return _stopButton;
}

- (BOOL)shouldShowGesturesForKey:(NSString *)key
{  
  if (_interfaceKey) { return NO; }
  
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
  
  [settings setObject:[NSNumber numberWithBool:NO] forKey:self.interfaceKey];
  [[NSUserDefaults standardUserDefaults] setObject:settings forKey:RCHGestureGuideDefaults];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [self cancel];
}

@end
