//
//  AgileSideMenuViewController.m

//
//  AgileSideMenuViewController.m
//  BodyToDress
//
//  Created by Michal Cisarik on 5/27/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "AgileSideMenuViewController.h"
#import "AlphaGradientView.h"
#import "AgileSideMenuView.h"
#import "TWTSideMenuViewController.h" // needed for self.sideMenuViewController calls
#import "FunctionsViewController.h"
#import "BouncyTransition.h"
#import "DismissGravity.h"

@interface AgileSideMenuViewController ()
@property (strong,nonatomic)AgileSideMenuView* sideMenuView;
@property (strong,nonatomic)FunctionsViewController *functionsVC;
@end

@implementation AgileSideMenuViewController

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    BouncyTransition *transition=[[BouncyTransition alloc]init];
    return transition;
    
}

-(void)handleTap {
    [self.functionsVC dismissViewControllerAnimated:YES completion:nil];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    DismissGravity *transition=[[DismissGravity alloc]init];
    return transition;
}

-(void)showFunctions:(id)sender{
    self.functionsVC=[[FunctionsViewController alloc]init];
    
    self.functionsVC.modalPresentationStyle=UIModalPresentationCustom;
    self.functionsVC.transitioningDelegate=self;
    
    [self presentViewController:self.functionsVC animated:YES completion:^{
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        
        [self.functionsVC.functionsButton addGestureRecognizer:tapGesture];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog( @"viewDidAppear" );
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    _sideMenuView=[[AgileSideMenuView alloc]init];
    self.view=_sideMenuView;
    
    UIView *patternView = [[UIView alloc]initWithFrame:self.view.frame];
    patternView.backgroundColor=[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"analytical.png"]];
    [self.view addSubview:patternView];
    
//    AlphaGradientView* gradient = [[AlphaGradientView alloc] initWithFrame:
//                                   CGRectMake(self.view.frame.size.width - 150, 0, 150,
//                                              self.view.frame.size.height)];
//    
//    gradient.color = [UIColor yellowColor];
//    gradient.direction = GRADIENT_RIGHT;
//    [self.view addSubview:gradient];
    
    
    [_sideMenuView.logoutButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_sideMenuView.myWardrobeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *functionsButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    functionsButton.tintColor = [UIColor whiteColor];
    functionsButton.backgroundColor = [UIColor blackColor];
    functionsButton.frame=CGRectMake(0, 18, self.view.frame.size.width, 40);
    [functionsButton setTitle:@"Settings" forState:UIControlStateNormal];
    
    [functionsButton addTarget:self action:@selector(showFunctions:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:functionsButton];
}

-(void)buttonPressed:(AgileButton*)sender{
    if ([sender isEqual:_sideMenuView.logoutButton]) {
        //        AgileLoginMenuViewController *loginViewController = [[AgileLoginMenuViewController alloc] init];
        //        [loginViewController logOut];
        //
        //        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        //        [self.sideMenuViewController setMainViewController:navigationController animated:YES closeMenu:YES];
        
    } else if ([sender isEqual:_sideMenuView.myWardrobeButton]) {
        
        //        AgileClosetViewController *closetViewController = [[AgileClosetViewController alloc]init];
        //
        //        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:closetViewController];
        //        [self.sideMenuViewController setMainViewController:navigationController animated:YES closeMenu:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end



