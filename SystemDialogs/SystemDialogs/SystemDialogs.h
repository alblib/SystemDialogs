//
//  SystemDialogs.h
//  SystemDialogs
//
//  Created by Albertus Liberius on 14/07/2019.
//  Copyright © 2019 Albertus Liberius. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#elif TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#else
#import <UIKit/UIKit.h>
#endif


//! Project version number for SystemDialogs.
FOUNDATION_EXPORT double SystemDialogsVersionNumber;

//! Project version string for SystemDialogs.
FOUNDATION_EXPORT const unsigned char SystemDialogsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SystemDialogs/PublicHeader.h>


