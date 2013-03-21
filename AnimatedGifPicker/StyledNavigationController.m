//
//  StyledNavigationController.m
//  gifpicker
//
//  Created by Ian Vo on 3/21/13.
//  Copyright (c) 2013 Mobisocial. All rights reserved.
//

#import "StyledNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPAD ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )


@interface StyledNavigationController ()

@end

@implementation StyledNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setTitle:(NSString *)title {
    UILabel *titleView = [[UILabel alloc] init];
    titleView.frame = CGRectMake(0, 0, self.visibleViewController.view.frame.size.width-160, 44);
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:16];
    titleView.textColor = [UIColor whiteColor];
    self.visibleViewController.navigationItem.titleView = titleView;
    
    titleView.text = title;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UINavigationBar *navBar = [navigationController navigationBar];
    UIImage *backgroundImage;
    if (IS_IPHONE_5) {
        backgroundImage = [UIImage imageNamed:@"roundedNavBar.png"];
    } else if (IS_IPAD) {
        backgroundImage = [[UIImage imageNamed:@"roundedNavBar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,16,0,16)];
    } else {
        backgroundImage = [UIImage imageNamed:@"roundedNavBar.png"];
    }
    
    
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    navBar.layer.shadowOffset = CGSizeMake(0, 0);
    navBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    navBar.layer.shadowRadius = 1.5f;
    navBar.layer.shadowOpacity = .4f;
    navBar.layer.masksToBounds = NO;
    navBar.shadowImage = [[UIImage alloc] init];
    
    navBar.tintColor = [UIColor darkGrayColor];
    
    NSString* title = viewController.navigationItem.title;
    
    [self setTitle:title];
    
    if ([viewController respondsToSelector:@selector(hidesNavigation)]) {
        [viewController.navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        [viewController.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
