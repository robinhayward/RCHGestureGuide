//
//  RCHAppDelegate.h
//  RCHGestureGuide
//
//  Created by Rob Hayward on 04/06/2013.
//  Copyright (c) 2013 Robin Hayward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCHViewController;

@interface RCHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RCHViewController *viewController;

@end
