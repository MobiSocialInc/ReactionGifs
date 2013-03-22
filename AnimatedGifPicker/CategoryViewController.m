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
    
    PSUICollectionView* _gifCollectionView;
    NSInteger _category;
}

- (void)loadView {
    [super loadView];
    
    PSUICollectionViewFlowLayout* flowLayout = [[PSUICollectionViewFlowLayout alloc] init];
    
    _gifCollectionView = [[PSUICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _gifCollectionView.backgroundColor = [UIColor whiteColor];
    [_gifCollectionView registerClass:[AnimatedGifCell class] forCellWithReuseIdentifier:@"AnimatedGifCell"];
    
    _gifCollectionView.delegate = self;
    _gifCollectionView.dataSource = self;
    _gifCollectionView.showsVerticalScrollIndicator = YES;
    _gifCollectionView.allowsSelection = YES;
    _gifCollectionView.allowsMultipleSelection = NO;
    
    [self.view addSubview:_gifCollectionView];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _gifCollectionView.frame = self.view.frame;
}

- (void)setCategory:(NSInteger)category {
    _category = category;
    self.title = [CategoriesViewController getCategoryName:_category];
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
        UIPasteboard* pb = [UIPasteboard generalPasteboard];
        [pb setItems:nil];
        [pb setData:GIFDATA forPasteboardType:@"com.compuserve.gif"];
        [pb setPersistent:YES];
        [JCNotificationBannerPresenter enqueueNotificationWithTitle:@"Reaction Gifs" message:@"Copied to clipboard!" icon:[UIImage imageWithData:GIFDATA] tapHandler:nil];
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
        case Categories_Miscellaneous:
            return 11;
        case Categories_Excited:
            return 10;
        case Categories_Popcorn:
            return 4;
        case Categories_What:
            return 5;
    }
    return 0;
}

@end
