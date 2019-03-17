//
//  Toast.m
//  Kaidoora
//
//  Created by Arthur Chang on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "Toast.h"

@implementation Toast
@synthesize kaidooraLogo,title,text,timer;


-(id) initWithText: (NSString*) toastText Title: (NSString*) toastTitle
{
	//[super init];
    xPosition = 15;
    yPosition = 350;
	self = [self init];
	//[timer invalidate];
	timer =nil;
	
	timer = [NSTimer  scheduledTimerWithTimeInterval: 3 target:self selector:@selector(finshed:) userInfo:nil repeats: NO];	
	[self ToastText:toastText];
	[self ToastTitle:toastTitle];
	return self;
}

-(id) initWithText: (NSString*) toastText Title: (NSString*) toastTitle Seconds: (int) secs x: (int) xspot y: (int) yspot
{
    xPosition = xspot;
    yPosition = yspot;
    
	self = [self init];
	[timer invalidate];
	timer =nil;
	if (secs != -1)
    {
        timer = [NSTimer  scheduledTimerWithTimeInterval: secs target:self selector:@selector(finshed:) userInfo:nil repeats: NO];
    }
	[self ToastText:toastText];
	[self ToastTitle:toastTitle];


    
    return self;
}


-(id) initWithText: (NSString*) toastText Title: (NSString*) toastTitle Seconds: (int) secs
{
	
    xPosition = 15;
    yPosition = 350;
    
	self = [self init];
	[timer invalidate];
	timer =nil;
	if (secs != -1)
    {
        timer = [NSTimer  scheduledTimerWithTimeInterval: secs target:self selector:@selector(finshed:) userInfo:nil repeats: NO];
    }
	[self ToastText:toastText];
	[self ToastTitle:toastTitle];
	return self;
}

-(id) init
{
	self = [super initWithFrame:CGRectMake(xPosition, yPosition, 290, 100)];
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
	self.layer.backgroundColor = [UIColor clearColor].CGColor;
	
	[self setAlpha:0.60f];
	self.layer.opacity  = 1.0f;
	self.layer.cornerRadius = 10;
	
	
	seconds=3;
	
	kaidooraLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ruktv.png"]];
	kaidooraLogo.layer.opacity=1.0f;
	kaidooraLogo.frame = CGRectMake(15, 18, 57, 57);
	
	[self addSubview: kaidooraLogo];

	
	
	title = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 190, 25)];
	title.backgroundColor=[UIColor clearColor];
	title.textColor = [UIColor whiteColor];
	title.text = @"Ruk T.V";
	[title setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
	[self addSubview:title];

	
	text= [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 190, 78)];
	text.backgroundColor=[UIColor clearColor];
	text.textAlignment = UITextAlignmentLeft;
	text.textColor = [UIColor whiteColor];
	text.lineBreakMode = UILineBreakModeWordWrap;
	text.numberOfLines=4;
	[text setFont:[UIFont fontWithName:@"Arial" size:12]];
	

	text.text = @"Thank you for downloading our App.";
		[self addSubview:text];
		
	timer = [NSTimer  scheduledTimerWithTimeInterval: seconds target:self selector:@selector(finshed:) userInfo:nil repeats: NO];	
	
	
	return self;
}

-(void) finshed: (NSTimer*) thetimer
{
	[self removeFromSuperview];
}

-(void) ToastText: (NSString*) ttoast
{
	[text setText:ttoast];
}

-(void) ToastTitle: (NSString*) ttitle
{
	[title setText:ttitle];
}


-(void) dealloc
{
    
	//[kaidooraLogo release];
	//kaidooraLogo=nil;
     /*
	[title release];
	title=nil;
      */
}



@end
