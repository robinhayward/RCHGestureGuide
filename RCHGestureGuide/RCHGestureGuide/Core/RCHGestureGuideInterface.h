//
//  RCHGestureGuideInterface.h
//  RCHGestureGuide
//
//  Created by Rob Hayward on 05/06/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import <Foundation/Foundation.h>

/**

 Optional types of background to lay over the interface which the guides will be shown over.
 The default being a gradient effect.
 
 */
typedef enum {
  RCHGestureGuideBackdropGradient = 0,
  RCHGestureGuideBackdropNone,
  RCHGestureGuideBackdropBlack
} RCHGestureGuideBackdropType;

/**
 
 The key used to store the dismissed guides in NSUserDefaults
 
*/
extern NSString *const RCHGestureGuideDefaults;

/**
 
 Available gestures to show guides for.
 You may wish to add to these or request more.
 
*/
extern NSString *const RCHGesturePinch;
extern NSString *const RCHGestureSwipe;
extern NSString *const RCHGestureSpread;
extern NSString *const RCHGestureTap;
extern NSString *const RCHGestureRotate;
