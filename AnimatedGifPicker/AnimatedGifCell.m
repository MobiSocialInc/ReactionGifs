//
//  AnimatedGifCell.m
//  AnimatedGifPicker
//
//  Created by Ian Vo on 3/20/13.
//  Copyright (c) 2013 Mobisocial. All rights reserved.
//

#import "AnimatedGifCell.h"
#import "OLImage.h"
#import "OLImageView.h"
#import "CategoriesViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimatedGifCell {
    NSInteger _category;
    NSInteger _index;
    
    OLImageView* _animatedGifImageView;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _animatedGifImageView = [[OLImageView alloc] initWithFrame:self.bounds];
        _animatedGifImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_animatedGifImageView];
        
        self.contentView.backgroundColor = [UIColor blackColor];
        
        
        self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
        self.contentView.layer.shadowOpacity = .6f;
        self.contentView.layer.shadowRadius = 3.0f;
        self.contentView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.contentView.bounds] CGPath];
        self.contentView.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:114.0/255.0 blue:255.0/255.0 alpha:1].CGColor;
    }
    
    return self;
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setCategory:_category index:_index];
    
    if(selected) {
        self.contentView.layer.borderWidth = 2.0f;
    }
    else {
        self.contentView.layer.borderWidth = 0.0f;
    }
}


- (void)setCategory:(NSInteger)category index:(NSInteger)index {
    _category = category;
    _index = index;
    
    NSString* gifName = [NSString stringWithFormat:@"%@%d", [CategoriesViewController getCategorySuffix:_category], index];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    NSData *GIFDATA = [NSData dataWithContentsOfFile:filePath];
    
    NSLog(gifName);
    _animatedGifImageView.image = [OLImage imageWithData:GIFDATA];
    
}

-(void)prepareForReuse {
    [super prepareForReuse];
    //_animatedGifImageView.image = nil;
}


@end
