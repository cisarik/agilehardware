//
//  SceneViewController.m
//  AgileHardware
//
//  Created by Michal Cisarik on 6/17/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "SceneViewController.h"
#import "GFS.h"
#import "Loader.h"
#import "ElementScene.h"
#import "Optimization.h"

@interface SceneViewController () {
    Optimization *_optimization;
    GFSs *_GFSs;
    ElementScene *scene;
    Loader *loader;
    SCNView *scnView;
}

@end

@implementation SceneViewController

- (id)init
{
    self = [super init];
    if (self) {
        _GFSs=[[GFSs alloc]initWithCommand:@"y=x^6−2*x^4+x^2,-1.0,1.0,50" GFSs:4];
        
        NSLog(@"GFS[0]:%@",_GFSs.subGFSs[0]);
        _optimization=[[Optimization alloc]initBlindSearchWithGFS:_GFSs.subGFSs[0]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    loader=nil;
    scnView=[[SCNView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scnView];
    
    scene=[[ElementScene alloc]initWithLoader:loader];
    [scnView setScene:scene];
    
    scnView.backgroundColor=[UIColor blackColor];
    
    scnView.autoenablesDefaultLighting = @YES;
    scnView.allowsCameraControl = @YES;
    
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
