//
//  AppDelegate.h
//  Ruk-TV
//
//  Created by code on 3/20/14.
//  Copyright (c) 2014 nomication. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>
{
    UINavigationController* navigationController;
    ViewController* vController;
    UIView* newView;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) ViewController* vController;
@end
