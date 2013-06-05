RCHGestureGuide
===============

A tool to display gesture hints to your users on any screen or interface area of your application.

# Usage

  - (void)viewDidAppear:(BOOL)animated
  {
    [super viewDidAppear:animated];
    [RCHGestureGuide showGestures:@[RCHGesturePinch, RCHGestureSwipe, RCHGestureSpread, RCHGestureRotate, RCHGestureTap] forKey:@"Home"];
  }

## Icons

The sample icons are from the free set at MobileTuxedo.com, you must not use these icons without contacting them for permission, always replace with your own icons for production.

If any designers out there want to create an icon set for me that can be shared with this tool freely please get in touch.

### Contact

@robhayward

hello@robhayward.co.uk
