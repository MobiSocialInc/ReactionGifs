//
//  CategoryViewController.h
//  AnimatedGifPicker
//
//  Created by Ian Vo on 3/20/13.
//  Copyright (c) 2013 Mobisocial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface CategoryViewController : UIViewController <PSTCollectionViewDelegateFlowLayout, PSTCollectionViewDataSource, MFMailComposeViewControllerDelegate>

- (void) setCategory:(NSInteger)category;

+ (NSInteger) numberOfImagesInCategory:(NSInteger)category;

@end
