//
//  ViewController.m
//  AnimatedGifPicker
//
//  Created by Ian Vo on 3/20/13.
//  Copyright (c) 2013 Mobisocial. All rights reserved.
//

#import "CategoriesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CategoryViewController.h"
#import "AppDelegate.h"

@implementation CategoriesViewController {
    UITableView* _tableView;
}

- (void)loadView {
    [super loadView];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];
    
    self.title = @"Pick a category";
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([((AppDelegate*)[UIApplication sharedApplication].delegate) callbackURLForSourceApp]) {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(returnToApp)];
        self.navigationItem.leftBarButtonItem = backButton;
        
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    _tableView.frame = self.view.frame;
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)returnToApp {
    NSURL* returnURL = [((AppDelegate*)[UIApplication sharedApplication].delegate) callbackURLForSourceApp];
    [((AppDelegate*)[UIApplication sharedApplication].delegate) setCallbackURLForSourceApp:nil];
    self.navigationItem.leftBarButtonItem = nil;
    UIPasteboard* pb =  [UIPasteboard pasteboardWithName:@"mobisocial.pasteboard"
                                                  create:YES];
        
    [pb setItems:nil];
    [pb setPersistent:YES];
    [[UIApplication sharedApplication] openURL:returnURL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return Categories_MAX;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    
    UIView* iconFrame = [[UIView alloc] init];
    iconFrame.frame = CGRectMake(15, 15, 40, 40);
    iconFrame.layer.cornerRadius = 5.0f;
    iconFrame.layer.shadowColor = [UIColor blackColor].CGColor;
    iconFrame.layer.shadowOffset = CGSizeMake(0, 0);
    iconFrame.layer.shadowOpacity = .3f;
    iconFrame.layer.shadowRadius = 7.0f;
    iconFrame.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:iconFrame.bounds cornerRadius:4.0f] CGPath];
    [cell.contentView addSubview:iconFrame];
    
    UIImageView* icon = [[UIImageView alloc] init];
    icon.frame = CGRectMake(0, 0, 40, 40);
    icon.layer.cornerRadius = 5.0f;
    icon.backgroundColor = [UIColor grayColor];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.clipsToBounds = YES;
    [iconFrame addSubview:icon];
    
    UILabel* title = [[UILabel alloc] init];
    title.frame = CGRectMake(70, 0, 130, 70);
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:17.0f];
    title.textColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1];
    [cell.contentView addSubview:title];
    
    UILabel* imageCount = [[UILabel alloc] init];
    imageCount.frame = CGRectMake(220, 0, 100, 70);
    imageCount.backgroundColor = [UIColor clearColor];
    imageCount.font = [UIFont fontWithName:@"STHeitiTC-Light" size:13.0f];
    imageCount.textColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1];
    [cell.contentView addSubview:imageCount];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    title.text = [CategoriesViewController getCategoryName:indexPath.row];
    icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@1.gif", [CategoriesViewController getCategorySuffix:indexPath.row]]];
    imageCount.text = [NSString stringWithFormat:@"%d images", [CategoryViewController numberOfImagesInCategory:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CategoryViewController* categoryVC = [[CategoryViewController alloc] init];
    [categoryVC setCategory:indexPath.row];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Back"
                                   style: UIBarButtonItemStyleBordered
                                   target: nil action: nil];
    
    [self.navigationItem setBackBarButtonItem: backButton];
    
    [self.navigationController pushViewController:categoryVC animated:YES];
}

+(NSString*)getCategorySuffix:(NSInteger)category {
    switch (category) {
        case Categories_Agreement:
            return @"agreement";
        case Categories_Clapping:
            return @"clapping";
        case Categories_Cool_Story_Bro:
            return @"coolstory";
        case Categories_Deal_With_It:
            return @"dealwithit";
        case Categories_Disgust:
            return @"disgust";
        case Categories_Laughing:
            return @"laughing";
        case Categories_Miscellaneous:
            return @"miscellaneous";
        case Categories_Mad:
            return @"mad";
        case Categories_Excited:
            return @"excited";
        case Categories_Popcorn:
            return @"popcorn";
        case Categories_Upset:
            return @"upset";
        case Categories_What:
            return @"wat";
    }
    
    return nil;
}

+(NSString*)getCategoryName:(NSInteger)category {
    switch (category) {
        case Categories_Agreement:
            return @"Agreement";
        case Categories_Clapping:
            return @"Clapping";
        case Categories_Cool_Story_Bro:
            return @"Cool Story Bro";
        case Categories_Deal_With_It:
            return @"Deal With It";
        case Categories_Disgust:
            return @"Disgust";
        case Categories_Laughing:
            return @"Laughing";
        case Categories_Mad:
            return @"Mad";
        case Categories_Miscellaneous:
            return @"Miscellaneous";
        case Categories_Excited:
            return @"Excited";
        case Categories_Popcorn:
            return @"Popcorn";
        case Categories_Upset:
            return @"Upset";
        case Categories_What:
            return @"Wat.";
    }
    
    return nil;
}

@end
