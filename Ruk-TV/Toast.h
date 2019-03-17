//
//  Toast.h
//  Kaidoora
//
//  Created by Arthur Chang on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Toast : UILabel
{
	UIImageView* kaidooraLogo;
	UILabel* title;
	UILabel* text;
	NSTimer* timer;
	float seconds;
    int xPosition;
    int yPosition;
}

-(void) ToastText: (NSString*) ttoast;
-(void) ToastTitle: (NSString*) ttitle;
-(id) initWithText: (NSString*) toastText Title: (NSString*) toastTitle;
-(id) initWithText: (NSString*) toastText Title: (NSString*) toastTitle Seconds: (int) secs;
-(id) initWithText: (NSString*) toastText Title: (NSString*) toastTitle Seconds: (int) secs x: (int) xspot y: (int) yspot;


@property (retain, nonatomic) UIImageView* kaidooraLogo;
@property (retain, nonatomic)	UILabel* title;
@property (retain, nonatomic)	UILabel* text;
@property (retain, nonatomic) NSTimer* timer;

@end
