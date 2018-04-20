//
//  FunctionsViewController.m
//  03.02
//
//  Created by Michal Cisarik on 3/12/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "FunctionsViewController.h"

@interface FunctionsViewController ()

@end

@implementation FunctionsViewController

-(void)hideFunctions:(id)sender{
    NSLog(@"hideFunctions called");
}

-(void)changeSwitch:(id)sender{
    NSLog(@"changeSwitch called");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    self.view.alpha=0.6;
    
    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(230, 55, 0, 0)];
    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:mySwitch];
    
    self.functionsButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.functionsButton.tintColor = [UIColor blackColor];
    self.functionsButton.backgroundColor = [UIColor whiteColor];
    self.functionsButton.frame=CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width, 40);
    [self.functionsButton setTitle:@"Hide" forState:UIControlStateNormal];
    
    //[self.functionsButton addTarget:self action:@selector(hideFunctions:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.functionsButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
