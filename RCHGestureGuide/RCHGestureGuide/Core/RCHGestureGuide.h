//
//  RCHGestureGuide.h
//  RCHGestureGuide
//
//  Created by Rob Hayward on 04/06/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCHGestureGuideInterface.h"

/**
 
 RCHGestureGuide is used to display gesture hint images (as icons) on screen to the user, one by one, when they first visit a screen and may need help.
 
 For example, if a screen (or user interface) responds to six different gestures, you could use this to show an icon depicting each one in turn when users first arrive.
 
 Whenever you show gestures on screen each presentation act requires a key to reference that specific state or area of interface and whether to show guides for it. This is useful so users can press the 'Stop showing this message' button for one screen but the guides are still shown on other interfaces the user might not yet have visited. You may also reset to make sure all guides are shown again until dismissed.
 
*/

@interface RCHGestureGuide : NSObject

@property (strong, nonatomic) NSString *dismissButtonTitle;
@property (assign, nonatomic) CGFloat screenAnimationDelayDuration;
@property (assign, nonatomic) CGFloat gestureOnScreenDuration;
@property (assign, nonatomic) CGFloat gestureAnimationDurationIn;
@property (assign, nonatomic) CGFloat gestureAnimationDurationOut;

/**
 Show the gesture guides on screen one by one if they are enabled for the key passed.
 @param gestures An array of the available string constants representing types of gesture, eg. @[RCHGesturePinch, RCHGestureTap]
 @param key This should be a unique key for the name of the interface eg. @"ProductViewController"
 */
+ (void)showGestures:(NSArray *)gestures forKey:(NSString *)key;

/**
 Resets all gestures so they will all be shown again until the user dismisses them, by pressing the stop showing button.
*/
+ (void)reset;

@end
