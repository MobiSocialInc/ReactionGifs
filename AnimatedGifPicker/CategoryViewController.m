//
//  CategoryViewController.m
//  AnimatedGifPicker
//
//  Created by Ian Vo on 3/20/13.
//  Copyright (c) 2013 Mobisocial. All rights reserved.
//

#import "CategoryViewController.h"
#import "AnimatedGifCell.h"
#import "CategoriesViewController.h"
#import "AppDelegate.h"
#import "JCNotificationBannerPresenter.h"

@implementation CategoryViewController {
    
    UIView* _containerView;
    PSUICollectionView* _gifCollectionView;
    NSInteger _category;
    BOOL _shareButtonsHidden;
    UIView* _shareButtonsView;
    NSIndexPath* _selectedGifIndexPath;
    
    UIView* _2plusView;
    UIView* _emailView;
    UIView* _iMessageView;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    _shareButtonsView = [[UIView alloc] init];
    [self.view addSubview:_shareButtonsView];
    
    _containerView = [[UIView alloc] init];
    [self.view addSubview:_containerView];
    
    
    PSUICollectionViewFlowLayout* flowLayout = [[PSUICollectionViewFlowLayout alloc] init];
    
    _gifCollectionView = [[PSUICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _gifCollectionView.backgroundColor = [UIColor whiteColor];
    [_gifCollectionView registerClass:[AnimatedGifCell class] forCellWithReuseIdentifier:@"AnimatedGifCell"];
    
    
    _gifCollectionView.delegate = self;
    _gifCollectionView.dataSource = self;
    _gifCollectionView.showsVerticalScrollIndicator = YES;
    _gifCollectionView.allowsSelection = YES;
    _gifCollectionView.allowsMultipleSelection = NO;
    
    [_containerView addSubview:_gifCollectionView];
    
    
    _shareButtonsHidden = YES;
    _selectedGifIndexPath = nil;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(_selectedGifIndexPath) {
        _containerView.frame = CGRectMake(0, 85, self.view.frame.size.width, self.view.frame.size.height-85);
        
    }
    else {
        _containerView.frame = self.view.frame;
    }
    _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _containerView.layer.shadowOffset = CGSizeMake(0, 0);
    _containerView.layer.shadowOpacity = .6f;
    _containerView.layer.shadowRadius = 3.0f;
    _containerView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:_containerView.bounds] CGPath];
    _containerView.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:255.0/255.0 alpha:1].CGColor;

    _gifCollectionView.frame = _containerView.bounds;
    
    _shareButtonsView.frame = CGRectMake(0, 0, self.view.frame.size.width, 85);
    _shareButtonsView.backgroundColor = [UIColor clearColor];
    
    if(!_2plusView) {
        _2plusView = [[UIView alloc] init];
        _2plusView.userInteractionEnabled = YES;
        UITapGestureRecognizer *twoPlusGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(open2Plus)];
        [_2plusView addGestureRecognizer:twoPlusGesture];
        
        _emailView = [[UIView alloc] init];
        _emailView.userInteractionEnabled = YES;
        UITapGestureRecognizer *emailGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMail)];
        [_emailView addGestureRecognizer:emailGesture];
        
        _iMessageView = [[UIView alloc] init];
        _iMessageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iMessageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMessage)];
        [_iMessageView addGestureRecognizer:iMessageGesture];
        
        [_shareButtonsView addSubview:_2plusView];
        [_shareButtonsView addSubview:_emailView];
        [_shareButtonsView addSubview:_iMessageView];
        
        
        _2plusView.frame = CGRectMake(self.view.frame.size.width/2 - 120, 0, 60, _shareButtonsView.frame.size.height);
        _2plusView.backgroundColor = [UIColor clearColor];
        
        UIView* _2plusIconContainer = [[UIView alloc] init];
        _2plusIconContainer.frame = CGRectMake(5, 9, 50, 50);
        _2plusIconContainer.layer.cornerRadius = 10.0f;
        _2plusIconContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        _2plusIconContainer.layer.shadowOffset = CGSizeMake(0, 0);
        _2plusIconContainer.layer.shadowOpacity = .3f;
        _2plusIconContainer.layer.shadowRadius = 3.0f;
        _2plusIconContainer.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:_2plusIconContainer.bounds cornerRadius:10.0f] CGPath];
        [_2plusView addSubview:_2plusIconContainer];
        
        UIImageView* _2plusIcon = [[UIImageView alloc] init];
        _2plusIcon.frame = CGRectMake(0, 0, 50, 50);
        _2plusIcon.image = [UIImage imageNamed:@"2plus_icon.png"];
        _2plusIcon.layer.cornerRadius = 10.0f;
        _2plusIcon.clipsToBounds = YES;
        [_2plusIconContainer addSubview:_2plusIcon];
        
        UILabel* _2plusLabel = [[UILabel alloc] init];
        _2plusLabel.frame = CGRectMake(0, 60, 60, 20);
        _2plusLabel.backgroundColor = [UIColor clearColor];
        _2plusLabel.text = @"2plus";
        _2plusLabel.textAlignment = NSTextAlignmentCenter;
        _2plusLabel.textColor = [UIColor blackColor];
        _2plusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
        [_2plusView addSubview:_2plusLabel];
        
        _emailView.frame = CGRectMake(self.view.frame.size.width/2 - 30, 0, 60, _shareButtonsView.frame.size.height);
        _emailView.backgroundColor = [UIColor clearColor];
        
        UIView* _emailIconContainer = [[UIView alloc] init];
        _emailIconContainer.frame = CGRectMake(5, 9, 50, 50);
        _emailIconContainer.layer.cornerRadius = 10.0f;
        _emailIconContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        _emailIconContainer.layer.shadowOffset = CGSizeMake(0, 0);
        _emailIconContainer.layer.shadowOpacity = .3f;
        _emailIconContainer.layer.shadowRadius = 3.0f;
        _emailIconContainer.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:_emailIconContainer.bounds cornerRadius:10.0f] CGPath];
        [_emailView addSubview:_emailIconContainer];
        
        UIImageView* _emailIcon = [[UIImageView alloc] init];
        _emailIcon.frame = CGRectMake(0, 0, 50, 50);
        _emailIcon.image = [UIImage imageNamed:@"Mail.png"];
        _emailIcon.layer.cornerRadius = 10.0f;
        _emailIcon.clipsToBounds = YES;
        [_emailIconContainer addSubview:_emailIcon];
        
        UILabel* _emailLabel = [[UILabel alloc] init];
        _emailLabel.frame = CGRectMake(0, 60, 60, 20);
        _emailLabel.backgroundColor = [UIColor clearColor];
        _emailLabel.text = @"Mail";
        _emailLabel.textAlignment = NSTextAlignmentCenter;
        _emailLabel.textColor = [UIColor blackColor];
        _emailLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
        [_emailView addSubview:_emailLabel];
        
        _iMessageView.frame = CGRectMake(self.view.frame.size.width/2 + 60, 0, 60, _shareButtonsView.frame.size.height);
        _iMessageView.backgroundColor = [UIColor clearColor];
        
        UIView* _iMessageIconContainer = [[UIView alloc] init];
        _iMessageIconContainer.frame = CGRectMake(5, 9, 50, 50);
        _iMessageIconContainer.layer.cornerRadius = 10.0f;
        _iMessageIconContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        _iMessageIconContainer.layer.shadowOffset = CGSizeMake(0, 0);
        _iMessageIconContainer.layer.shadowOpacity = .3f;
        _iMessageIconContainer.layer.shadowRadius = 3.0f;
        _iMessageIconContainer.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:_iMessageIconContainer.bounds cornerRadius:10.0f] CGPath];
        [_iMessageView addSubview:_iMessageIconContainer];
        
        UIImageView* _iMessageIcon = [[UIImageView alloc] init];
        _iMessageIcon.frame = CGRectMake(0, 0, 50, 50);
        _iMessageIcon.image = [UIImage imageNamed:@"imessage.png"];
        _iMessageIcon.layer.cornerRadius = 10.0f;
        _iMessageIcon.clipsToBounds = YES;
        [_iMessageIconContainer addSubview:_iMessageIcon];
        
        UILabel* _iMessageLabel = [[UILabel alloc] init];
        _iMessageLabel.frame = CGRectMake(0, 60, 60, 20);
        _iMessageLabel.backgroundColor = [UIColor clearColor];
        _iMessageLabel.text = @"Messages";
        _iMessageLabel.textAlignment = NSTextAlignmentCenter;
        _iMessageLabel.textColor = [UIColor blackColor];
        _iMessageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
        [_iMessageView addSubview:_iMessageLabel];
        
        
    
    }
    
}


- (void)open2Plus {
    NSString *stringURL = @"twoplus://share";
    NSURL *url = [NSURL URLWithString:stringURL];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSString* gifName = [NSString stringWithFormat:@"%@%d", [CategoriesViewController getCategorySuffix:_category], _selectedGifIndexPath.row+1];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
        NSData *GIFDATA = [NSData dataWithContentsOfFile:filePath];
        
        UIPasteboard* pb = [UIPasteboard pasteboardWithName:@"mobisocial.pasteboard" create:YES];
        [pb setItems:nil];
        [pb setData:GIFDATA forPasteboardType:@"com.compuserve.gif"];
        [pb setPersistent:YES];
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        NSURL *itunesUrl = [NSURL URLWithString:@"itms://itunes.apple.com/us/app/2plus/id586030310"];
        [[UIApplication sharedApplication] openURL:itunesUrl];
    }
}

- (void)openMail {
    if ([MFMailComposeViewController canSendMail]) {
        
        NSString* gifName = [NSString stringWithFormat:@"%@%d", [CategoriesViewController getCategorySuffix:_category], _selectedGifIndexPath.row+1];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
        NSData *GIFDATA = [NSData dataWithContentsOfFile:filePath];
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Checkout this funny gif!"];
        [controller setMessageBody:@"It's hilarious!" isHTML:NO];
        [controller addAttachmentData:GIFDATA mimeType:@"image/gif" fileName:[NSString stringWithFormat:@"%@.gif", gifName]];
        if (controller) [self presentModalViewController:controller animated:YES];
    } else {
        // Handle the error
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)openMessage {
    NSString *stringURL = @"sms:";
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)setCategory:(NSInteger)category {
    _category = category;
    self.title = [CategoriesViewController getCategoryName:_category];
}

- (void) showCopiedToast {
    UILabel* toast = [[UILabel alloc] init];
    toast.frame = CGRectMake(0, 0, self.view.frame.size.width - 100, 30);
    toast.center = CGPointMake(self.view.frame.size.width / 2, 25);
    toast.textAlignment = NSTextAlignmentCenter;
    toast.text = @"Copied to clipboard!";
    toast.backgroundColor = [UIColor whiteColor];
    toast.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:17.0f];
    toast.layer.cornerRadius = 15.0f;
    toast.layer.borderColor = [UIColor blackColor].CGColor;
    toast.layer.borderWidth = 1.0f;
    toast.alpha = 0;
    [_containerView addSubview: toast];
    
    [UIView animateWithDuration:.5 animations:^{
        toast.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.0f delay:.5f options:nil animations:^ {
                toast.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [toast removeFromSuperview];
                }
            }];
            
        }
    }];
}

- (void) showSharingOptions {
    _shareButtonsHidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y+_shareButtonsView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height-_shareButtonsView.frame.size.height);
        
        _gifCollectionView.frame = CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

- (void) hideSharingOptions {
    _shareButtonsHidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _containerView.frame = CGRectMake(_containerView.frame.origin.x, _containerView.frame.origin.y-_shareButtonsView.frame.size.height, _containerView.frame.size.width, _containerView.frame.size.height+_shareButtonsView.frame.size.height);
        
        _gifCollectionView.frame = CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* gifName = [NSString stringWithFormat:@"%@%d", [CategoriesViewController getCategorySuffix:_category], indexPath.row+1];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    NSData *GIFDATA = [NSData dataWithContentsOfFile:filePath];
    
    NSURL* returnURL = [((AppDelegate*)[UIApplication sharedApplication].delegate) callbackURLForSourceApp];
    if (returnURL) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate) setCallbackURLForSourceApp:nil];
        UIPasteboard* pb =  [UIPasteboard pasteboardWithName:@"mobisocial.pasteboard"
                                                      create:YES];
        [pb setItems:nil];
        [pb setData:GIFDATA forPasteboardType:@"com.compuserve.gif"];
        [pb setPersistent:YES];
        [[UIApplication sharedApplication] openURL:returnURL];
    }
    else {
        //selected one you already toggled, hide share buttons
        if([indexPath compare:_selectedGifIndexPath] == NSOrderedSame) {
            _selectedGifIndexPath = nil;
            [_gifCollectionView deselectItemAtIndexPath:indexPath animated:YES];
            [[_gifCollectionView cellForItemAtIndexPath:indexPath] setSelected:NO];
            [self hideSharingOptions];
        }
        else {
            _selectedGifIndexPath = indexPath;
            
            UIPasteboard* pb = [UIPasteboard generalPasteboard];
            [pb setItems:nil];
            [pb setData:GIFDATA forPasteboardType:@"com.compuserve.gif"];
            [pb setPersistent:YES];
            
            [self showCopiedToast];
            if(_shareButtonsHidden) {
                [self showSharingOptions];
            }
        }
    }
}

- (NSInteger)collectionView:(PSTCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [CategoryViewController numberOfImagesInCategory:_category];
}

- (NSInteger)numberOfSectionsInCollectionView:(PSTCollectionView *)collectionView
{
    return 1;
}

- (PSTCollectionViewCell*)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AnimatedGifCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnimatedGifCell" forIndexPath:indexPath];
    [cell prepareForReuse];
    
    [cell setCategory:_category index:indexPath.row+1];
    
    return cell;
}

- (CGSize)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake(160, 160);
    } else {
        return CGSizeMake(148, 148);
    }
}

- (UIEdgeInsets)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

+(NSInteger)numberOfImagesInCategory:(NSInteger)category {
    switch (category) {
        case Categories_Agreement:
            return 9;
        case Categories_Clapping:
            return 8;
        case Categories_Cool_Story_Bro:
            return 9;
        case Categories_Deal_With_It:
            return 3;
        case Categories_Disgust:
            return 11;
        case Categories_Laughing:
            return 4;
        case Categories_Mad:
            return 6;
        case Categories_Miscellaneous:
            return 11;
        case Categories_Excited:
            return 10;
        case Categories_Popcorn:
            return 4;
        case Categories_Upset:
            return 12;
        case Categories_What:
            return 5;
    }
    return 0;
}

@end
