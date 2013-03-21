//
//  ViewController.h
//  AnimatedGifPicker
//
//  Created by Ian Vo on 3/20/13.
//  Copyright (c) 2013 Mobisocial. All rights reserved.
//

#import <UIKit/UIKit.h>

enum CategoriesViewCellIds : int
{
    Categories_Clapping,
    Categories_Popcorn,
    Categories_Laughing,
    Categories_Disgust,
    Categories_Agreement,
    Categories_Excited,
    Categories_What,
    Categories_Cool_Story_Bro,
    Categories_Deal_With_It,
    Categories_Miscellaneous,
    Categories_MAX,
    //if you want to disable something, just move it past here
};

@interface CategoriesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
+(NSString*)getCategorySuffix:(NSInteger)category;
+(NSString*)getCategoryName:(NSInteger)category;
@end
