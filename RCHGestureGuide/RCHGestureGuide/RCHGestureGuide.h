//
//  RCHGestureGuide.h
//  RCHGestureGuide
//
//  Created by Rob Hayward on 04/06/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvailabilityMacros.h>

#define RCHGestureGuideDefaults @"RCHGestureGuideDefaults"

typedef enum {
  RCHGestureGuideBackdropGradient = 0,
  RCHGestureGuideBackdropNone,
  RCHGestureGuideBackdropBlack
} RCHGestureGuideBackdropType;



extern NSString *const RCHGesturePinch;
extern NSString *const RCHGestureDrag;
extern NSString *const RCHGestureTap;
extern NSString *const RCHGestureRotate;

@interface RCHGestureGuide : UIView

+ (void)showGestures:(NSArray *)gestures forKey:(NSString *)key;

+ (void)reset;

+ (void)cancel;

@end
