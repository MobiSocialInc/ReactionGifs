//
//  AppDelegate.h
//  AnimatedGifPicker
//
//  Created by Ian Vo on 3/20/13.
//  Copyright (c) 2013 Mobisocial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoriesViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CategoriesViewController *viewController;

@property (strong, nonatomic) NSURL* callbackURLForSourceApp;
@end
