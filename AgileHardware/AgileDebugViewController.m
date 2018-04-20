//
//  AgileMenu.m
//  BodyToDress
//
//  Created by Michal Cisarik on 5/22/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "AgileDebugViewController.h"
#import "AgileDebugMenuView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "Macros.h"

#import "TWTSideMenuViewController.h"
#import "AutolayoutMacros.h"

#import "GFS.h"
#import "Optimization.h"

@import ObjectiveC;
@import JavaScriptCore;

static const NSString *javascriptFile=@"ui.js";
static const NSString *javascriptOnLoad=@"initJSContext();";

@interface AgileDebugViewController() {
    
    GFSs *_all;
    Optimization *_optimization;
    
    __block JSContext *context;
    __block JSValue *style;
}
@end

@implementation AgileDebugViewController
-(void)loadView {
    self.title=@"Symbolic Math";
    [self.navigationController setNavigationBarHidden:NO];
    
    _all=[[GFSs alloc]initWithCommand:@"y=x^6−2*x^4+x^2,-1.0,1.0,50" GFSs:8];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view=[[AgileDebugMenuView alloc]init];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"=" style: UIBarButtonSystemItemEdit target:self action:@selector(show)];
    
    [self.menuView.updateButton addTarget:self action:@selector(updateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    //[[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    //self.menuView.imgWebView.delegate=self;
    
    context = [self.menuView.imgWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    if (!([context isKindOfClass:[JSContext class]])) {
        //error
    }
    
    [context evaluateScript:@"console.log('this is a log message that goes nowhere :(’)"];
    context[@"console"][@"log"] = ^(JSValue *msg) {
      NSLog(@"JavaScript %@ log message: %@", [JSContext currentContext], msg);
    };
    [context evaluateScript:@"console.log('this is a log message that goes to my Xcode debug console :)’)"];
                                    
    style = context[@"document"][@"body"][@"style"];
    
    if (!style) {
        //error
    }
    
    // JavaScript-function-to-Cocoa-block bridge:
    context[@"toggleDivColor"] = ^() {
        style[@"background"] = @"";
        NSLog(@"fading to color: %@", style[@"background"]);
    };
    JSValue *setColorFunction = context[@"toggleDivColor"];
    NSAssert([setColorFunction isObject], @"it was a block, but now it should be a bridged JSValue function object");
    // we can call our background-setting code directly via JavaScript
    [setColorFunction callWithArguments:nil];

    
    
//    // set up the body’s style so all CSS changes are animated
//    NSTimeInterval colorChangeInterval = 1.0;
//    style[@"transition-timing-function"] = @"linear";
//    style[@"transition-delay"] = @(0);
//    style[@"transition-duration"] = [NSString stringWithFormat:@"%@s", @(colorChangeInterval)];

//    JSValue *setIntervalFunction = ctx[@"setInterval"]; // grab the built-in setInterval repeating timer function
//    NSAssert([setIntervalFunction isObject], @"setInterval should have been a function object");
//    // now set up a repeating timer in JavaScript that calls our background-changing Cocoa function
//    [setIntervalFunction callWithArguments:@[setColorFunction, @(colorChangeInterval * 1000.)]];

    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style: UIBarButtonSystemItemEdit target:self action:@selector(updateButtonClicked:)];
    
    [self.menuView.updateButton addTarget:self action:@selector(updateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self showWebView];
}

-(void)show{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (void) updateButtonClicked:(UIBarButtonItem*)sender
{
    NSLog(@"sdfds");
    //[self showWebView];
}


-(AgileDebugMenuView*)menuView{
    return (AgileDebugMenuView*)self.view;
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.menuView.updateButton.alpha=1.0;
    }];
    
}

-(void)canvas:(AgileButton *)sender{
    
//    __block AgileOutfitViewController *outfitViewController = [[AgileOutfitViewController alloc] initWithOutfit:outfit];
//    
//    [self.navigationController pushViewController:outfitViewController animated:YES];
//}
}

#pragma mark -
#pragma mark Graph Methods
/*****************************************************************************
 * Graph Methods
 ****************************************************************************/
-(void)showWebView
{
    [NSTimer scheduledTimerWithTimeInterval:(1) target:self selector:@selector(showWebViewOnTimer:) userInfo:nil repeats:YES];
}

-(void) showWebViewOnTimer:(NSTimer *)timer
{
    //----- Retreeve Service from timer User Info
    NSString *title = @"Stored Data!";
    NSString *y_title = @"Title Y";
    NSString *x_title = @"Tytle X";
    
    NSMutableString *theGraphURL = [[NSString stringWithFormat:IMG_URL_TYPEDATE
                                      , title, y_title, x_title] mutableCopy];
    [theGraphURL appendString:TEST_DATA];
    
    [theGraphURL appendString:@"&start_period_seconds=sunrise&end_period_seconds=sunset"];
    
    //----- A white space delimited list of values representing the x and y values of points in a sequence for curve index I where I starts at 1. The x values are in units of seconds from 1970 and the y values are unitless.
    
    [self getGraph:theGraphURL];
    
    [timer  invalidate];
}



-(void) getGraph:(NSMutableString *)graphURL
{
    
    //NSMutableString *htmlLegent = [NSString stringWithFormat:@"%@",[self getLegendTable]];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSMutableString *pageStr = [@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n " mutableCopy];
    [pageStr appendString:@"<html xmlns=\"http://www.w3.org/1999/xhtml\" lang=\"en-US\" xml:lang=\"en-US\">\n"];
    
//    [pageStr appendString:@"appendString"]
    [pageStr appendString:@"<head>\n"];
    [pageStr appendString:@"<title>MigraineMate Paint Graph</title>\n"];
    
    // meta header:
    [pageStr appendString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" />\n"];
    
    // include javascript file:
    [pageStr appendString:@"<script type=\"text/javascript\" src=\""];
    [pageStr appendString:javascriptFile];
    [pageStr appendString:@"\"></script>\n"];
    
    // [pageStr appendString:@"<script type=\"text/javascript\" src=\"auto-render.min.js\"></script>\n"];
    
    // css:
    [pageStr appendString:@"<link href=\"katex.min.css\" rel=\"stylesheet\" type=\"text/css\" />\n"];
    
    [pageStr appendString:@"<script type=\"text/javascript\" src=\"katex.min.js\"></script>\n"];
    [pageStr appendString:@"</head>\n"];
    
    [pageStr appendString:@"<body onload=\""];
    
    int i=0;
    for (GFS* gfs in _all.subGFSs) {
        [pageStr appendString:[NSString stringWithFormat:@"katex.render('gfs%d = [ %@ ]', document.getElementById('expression%d'),{ displayMode: false } );",i,gfs,i]];
        [pageStr appendString:[NSString stringWithFormat:@"katex.render('best : %@ ', document.getElementById('bestReinforcement%d'),{ displayMode: false } );",[gfs reinforcementDescription] ,i]];
        [pageStr appendString:[NSString stringWithFormat:@"katex.render('fitness = %.4f ', document.getElementById('bestFitness%d'),{ displayMode: false } );",[gfs bestReinforcementFitness] ,i]];
        i+=1;
    }
    [pageStr appendString:@"return false;\">\n"];
    
    i=0;
    for (GFS* gfs in _all.subGFSs) {
        [pageStr appendString:@"<div style=\"float:left;font-size: 100%;width:100%;height:70px;color:white;\"class=\"katex\" "];// text-shadow: 0px 4px 3px rgba(0,0,0,0.4),0px 8px 13px rgba(0,0,0,0.1),0px 18px 23px rgba(0,0,0,0.1);
        [pageStr appendString:[NSString stringWithFormat:@"id=\"expression%d\"></div><div id=\"bestReinforcement%d\"></div><br><div style=\"color:white;text-shadow: 0px 4px 3px rgba(0,0,0,0.4),0px 8px 13px rgba(0,0,0,0.1),0px 18px 23px rgba(0,0,0,0.1);\" id=\"bestFitness%d\"></div><br><br>\n",i,i,i]];
        i+=1;
        
//        Optimization *o=[[Optimization alloc]initBlindSearchWithGFS:gfs];
//        [o search];
    }
    
    
//    [pageStr appendString:@"<div style=\"display: none;\" id=\"graph\">\n"];
//    [pageStr appendString:[NSString stringWithFormat:@"<img alt=\"Graph\" src=\"%@\" width=460px height=430px border=0/>\n", graphURL]];
//    [pageStr appendString:@"</div>\n"];
//    [pageStr appendString:[NSString stringWithFormat:@"%@\n", htmlLegent]];
    [pageStr appendString:@"</body>\n"];
    [pageStr appendString:@"</html>\n"];
//    [pageStr appendString:@""];

    
    //NSLog(@"->fullHTMLString=%@", pageStr);
    [self.menuView.imgWebView  setBackgroundColor:[UIColor clearColor]];
    [self.menuView.imgWebView  setOpaque:NO];
    [self.menuView.imgWebView  loadHTMLString:pageStr baseURL:baseURL];
}


-(NSString *) getLegendTable
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *stringStartDate = [formatter stringFromDate:[formatter dateFromString:@"02/11/2010"] ];
    NSString *stringEndDate = [formatter stringFromDate:[formatter dateFromString:@"01/26/2010"]];
    NSMutableString *htmlStr = [@"<div>" mutableCopy];
    [htmlStr appendString:@"<table style=\"margin:10px;padding:20px;font-family:Verdana;font-size:28px;color:#FFFFFF;font-weight:bold;\" cellpadding=\"1\" width=\"100%\">"];
    [htmlStr appendString:@"<tbody style=\"margin:10px;padding:20px;font-family:Verdana;font-size:28px;color:#FFFFFF;font-weight:bold;\">"];
    /*[htmlStr appendString:@"<tr>"];
     
     [htmlStr appendString:@"<td colspan=\"3\" align=\"Center\">Stored migraine data graph.</td>"];
     [htmlStr appendString:@"</tr>"];*/
    [htmlStr appendString:@"<tr>"];
    [htmlStr appendString:@"<td></td>"];
    [htmlStr appendString:@"<td>Period:</td>"];
    [htmlStr appendString:[NSString stringWithFormat:@"<td colspane\"2\" style=\"font-weight:normal;\">From %@ to %@</td>", stringStartDate, stringEndDate]];
    [htmlStr appendString:@"</tr>"];
    [htmlStr appendString:@"<tr>"];
    [htmlStr appendString:@"<td align=\"right\" valign=\"top\" rowspan=\"4\">"];
    [htmlStr appendString:@"<a href=\"http://mentormate.com\" target=\"_blank\"><img src=\"http://mentormate.com/img/main_logo.png\" border=\"0\" height=\"130\" width=\"130\"></a> </td>"];
    [htmlStr appendString:@"<td>Lines:</td>"];
    /*[htmlStr appendString:@"<td></td>"];
     [htmlStr appendString:@"</tr>"];
     [htmlStr appendString:@"<tr>"];
     [htmlStr appendString:@"<td></td>"];*/
    [htmlStr appendString:[NSString stringWithFormat:@"<td style=\"background:#C94118; color:#FFFFFF;font-weight:normal;\">%@</td>", @"Data 1" ]];
    [htmlStr appendString:@"</tr>"];
    [htmlStr appendString:@"<tr>"];
    [htmlStr appendString:@"<td></td>"];
    [htmlStr appendString:[NSString stringWithFormat:@"<td style=\"background:#5A7BBA; color:#FFFFFF;font-weight:normal;\">%@</td>", @"Data 2"]];
    [htmlStr appendString:@"</tr>"];
    [htmlStr appendString:@"<tr>"];
    [htmlStr appendString:@"<td></td>"];
    [htmlStr appendString:[NSString stringWithFormat:@"<td style=\"background:#B76FB8; color:#FFFFFF;font-weight:normal;\">%@</td></tr>", @"Data 3"]];
    [htmlStr appendString:@"<tr>"];
    [htmlStr appendString:@"<td></td>"];
    [htmlStr appendString:[NSString stringWithFormat:@"<td style=\"background:#58D3DB; color:#FFFFFF;font-weight:normal;\">%@</td></tr>", @"Data 4"]];
    [htmlStr appendString:@"</tbody></table></div>"];
    
    
    return htmlStr;
    
}



@end
