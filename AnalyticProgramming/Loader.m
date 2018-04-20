//
//  Loader.m
//  MSAP
//
//  Created by Michal Cisarik on 2/23/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "Loader.h"

@implementation Loader
@synthesize configuration,input;

-(IN*)generateInput:(NSString*)inputDescription {
    
    NSString *functionstr;
    NSArray *expression;
    NSMutableArray *xs;
    NSMutableArray *ys;
    NSMutableArray *zs;
    
    BOOL is3D=NO;
    double min;
    double max;
    int count;
    int i;
    int j;
    
    NSArray *subseparated=[inputDescription componentsSeparatedByString:@","];
    
    if ([subseparated count]==1) {
        NSString *inputfile=[NSString stringWithContentsOfURL:[NSURL fileURLWithPath:inputDescription] encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *inputfilelines=[inputfile componentsSeparatedByString:@"\n"];
        
        i=0;
        
        uint ii=0;
        for (NSString *line in inputfilelines) {
            i++;
            if (i==1) {
                
                expression=[line componentsSeparatedByString:@"="];
                functionstr=[expression objectAtIndex:1];
                
                if (!([[expression objectAtIndex:0]isEqualToString:@"y"]))
                    is3D=YES;
                
                [configuration setObject:line  forKey:@"function"];
                
            } else if (i==2) {
                min=[line doubleValue];
            } else if (i==3) {
                max=[line doubleValue];
            } else if (i==4) {
                count=[line intValue];
                if (is3D) {
                    xs=[[NSMutableArray alloc]initWithCapacity:count*count];
                    ys=[[NSMutableArray alloc]initWithCapacity:count*count];
                    zs=[[NSMutableArray alloc]initWithCapacity:count*count];
                } else {
                    xs=[[NSMutableArray alloc]initWithCapacity:count];
                    ys=[[NSMutableArray alloc]initWithCapacity:count];
                }
            } else if (((is3D) && (ii<count*count))||((!is3D) && (ii<count))){
                
                subseparated=[line componentsSeparatedByString:@","];
                
                [xs insertObject:[NSNumber numberWithDouble:[[subseparated objectAtIndex:0]doubleValue]] atIndex:ii];
                [ys insertObject:[NSNumber numberWithDouble:[[subseparated objectAtIndex:1]doubleValue]] atIndex:ii];
                
                if (is3D) {
                    [zs insertObject:[NSNumber numberWithDouble:[[subseparated objectAtIndex:2]doubleValue]] atIndex:ii];
                }
                ii++;
            }
        }
        if (is3D)
            [configuration setObject:@YES forKey:@"3D"];
        else
            [configuration setObject:@NO forKey:@"3D"];
        return [[IN alloc] initWithXs:xs Ys:ys Zs:zs min:min max:max andCount:count];
    }
    
    functionstr=[subseparated objectAtIndex:0];
    [configuration setObject:functionstr  forKey:@"function"];
    
    expression=[[subseparated objectAtIndex:0]componentsSeparatedByString:@"="];
    functionstr=[expression objectAtIndex:1];
    
    if (([[expression objectAtIndex:0]isEqualToString:@"z"])) {
        is3D=YES;
        functionstr=[functionstr stringByReplacingOccurrencesOfString:@"y" withString:@"$y"];
    }
    functionstr=[functionstr stringByReplacingOccurrencesOfString:@"x" withString:@"$x"];
    functionstr=[functionstr stringByReplacingOccurrencesOfString:@"^" withString:@"**"];
    
    min=[[subseparated objectAtIndex:1]doubleValue];
    max=[[subseparated objectAtIndex:2]doubleValue];
    count=[[subseparated objectAtIndex:3]intValue];
    
    NSMutableString *newinput=[[NSMutableString alloc]init];
    
    xs=[IN ekvidistantDoublesCount:count min:min max:max];
    
    [newinput appendString:[NSString stringWithFormat:@"%@\n",[subseparated objectAtIndex:0]]];
    [newinput appendString:[NSString stringWithFormat:@"%.12f\n",min]];
    [newinput appendString:[NSString stringWithFormat:@"%.12f\n",max]];
    [newinput appendString:[NSString stringWithFormat:@"%d\n",count]];
    
    double result;
    
    NSMutableDictionary *substitutions=[[NSMutableDictionary alloc]init];
    
    DDMathEvaluator *eval = [DDMathEvaluator defaultMathEvaluator];
    
    NSError *s=[[NSError alloc]init];
    DDExpression *function=[DDExpression expressionFromString:functionstr error:&s];
    
    if (is3D) {
        
        ys=[IN ekvidistantDoublesCount:count min:min max:max];
        zs=[[NSMutableArray alloc]initWithCapacity:count*count];
        uint ii=0;
        for (i=0; i<count; i++) {
            for (j=0; j<count; j++) {
                [substitutions setValue:[xs objectAtIndex:i] forKey:@"x"];
                [substitutions setValue:[ys objectAtIndex:j] forKey:@"y"];
                result=[[eval evaluateExpression:function withSubstitutions:substitutions error:&s]doubleValue];
                [newinput appendString:[NSString stringWithFormat:@"%.12f,%.12f,%.12f\n",[[xs objectAtIndex:i]doubleValue],[[ys objectAtIndex:j]doubleValue],result]];
                [zs insertObject:[NSNumber numberWithDouble:result] atIndex:ii++];
            }
        }
        
    } else {
        ys=[[NSMutableArray alloc]initWithCapacity:count];
        
        for (i=0; i<count; i++) {
            
            [substitutions setValue:[xs objectAtIndex:i] forKey:@"x"];
            result=[[eval evaluateExpression:function withSubstitutions:substitutions error:&s]doubleValue];
            [ys insertObject:[NSNumber numberWithDouble:result] atIndex:i];
            [newinput appendString:[NSString stringWithFormat:@"%.12f,%.12f\n",[[xs objectAtIndex:i]doubleValue],result]];
        }
    }
    
    NSFileManager *filemgr = [[NSFileManager alloc] init];
    NSString *currentpath = [filemgr currentDirectoryPath];
    NSLog(@"currentDirectoryPath:%@",currentpath);
    NSURL *inputurl=[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",currentpath,@"/input.txt"]];
    
    [newinput writeToURL:inputurl atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if (is3D)
        [configuration setObject:@YES forKey:@"3D"];
    else
        [configuration setObject:@NO forKey:@"3D"];
    
    return [[IN alloc] initWithXs:xs Ys:ys Zs:zs min:min max:max andCount:count];
}

- (id)initWithInput:(NSString *)inputDescription settings:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict==nil) {
            configuration=[NSMutableDictionary dictionaryWithDictionary:@{
                                                                          
                @"function":@"",
                @"3D" : @NO,
                @"GFShex": @"",
                @"constants": @[@22,@11,@33,@44],
                
                @"ElementSize":@33,
                @"ElementWidth":@6,
                @"ElementDepth":@9,

                @"calculationSize":@32,

                @"individuals":@20,
                @"individualLength":@96,
                @"subintervals":@3,

                @"randomConstants" :@YES,
                @"reinforcedConstants" :@YES,
                
                @"randomConstantsCount":@10,
                @"constantMinValue":@0.0,
                @"constantMaxValue":@100.0,
                
                
                @"randomElements":@YES,
                @"randomElementsCount":@11,
                @"arithmeticFunctions" : @YES,
                @"logarithmicFunctions" : @YES,
                @"goniometricFunctions" : @YES,
                @"polynomialFunctions" : @YES,

                @"otherFunctions" : @YES,

                @"exponentialFunction" : @YES,

                @"linearConstants" : @NO,
                @"mathConstants" :@YES,

                @"forcebit1": @NO,  //add
                @"forcebit2": @NO,  //sub
                @"forcebit3": @NO,  //mul
                @"forcebit4": @NO,  //div
                @"forcebit5": @NO,  //sin
                @"forcebit6": @NO,  //cos
                @"forcebit7": @NO,  //tan
                @"forcebit8": @NO,  //log
                @"forcebit9": @NO,  //log2
                @"forcebit10": @NO, //log10
                @"forcebit11": @NO, //^2
                @"forcebit12": @NO, //^3
                @"forcebit13": @NO, //^4
                @"forcebit14": @NO, //^5
                @"forcebit15": @NO, //^6
                @"forcebit16": @NO, //1
                @"forcebit17": @NO, //2
                @"forcebit18": @NO, //3
                @"forcebit19": @NO, //4
                @"forcebit20": @NO, //5
                @"forcebit21": @NO, //6
                @"forcebit22": @NO, //7
                @"forcebit23": @NO, //8
                @"forcebit24": @NO, //9
                @"forcebit25": @NO, //^
                @"forcebit26": @NO, //sqrt
                @"forcebit27": @NO, //abs
                @"forcebit28": @NO, //exp
                @"forcebit29": @NO, //pi
                @"forcebit30": @NO, //e
                @"forcebit31": @NO, //phi
                
                @"reinforcedElements" : @YES,
                
                @"reinforcedEvolution" : @YES,
                
                @"reinforcements": @[@"[2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,1,2,3]\n[12,11,13,14,15,14,13,12,11,12,13,12,11,13,14,15,14,13,12,11,12,13,11,11,13,14,15,14,13,12,11,12,13,11,12,13]",
               @"[2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,1,2,3]\n[12,11,13,14,15,14,13,12,11,12,13,12,11,13,14,15,14,13,12,11,12,13,11,11,13,14,15,14,13,12,11,12,13,11,12,13]",
              @"[2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,1,2,3]\n[12,11,13,14,15,14,13,12,11,12,13,12,11,13,14,15,14,13,12,11,12,13,11,11,13,14,15,14,13,12,11,12,13,11,12,13]",
              @"[2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,1,2,3]\n[12,11,13,14,15,14,13,12,11,12,13,12,11,13,14,15,14,13,12,11,12,13,11,11,13,14,15,14,13,12,11,12,13,11,12,13]",
              @"[2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,2,1,3,4,5,4,3,2,1,2,3,1,2,3]\n[12,11,13,14,15,14,13,12,11,12,13,12,11,13,14,15,14,13,12,11,12,13,11,11,13,14,15,14,13,12,11,12,13,11,12,13]"],
                
                @"BS_iterations":@100,
                @"BS_metaiterations":@10,

                @"DE_vectors" : @32,
                @"DE_generations" : @1000,
                @"DE_scalingFactor" : @0.9,
                @"DE_crossProb" : @0.9,
                @"DE_mutProb" : @0.3,
                @"DE_migProb" : @0.6,
                @"DE_migrations" : @20,

                }];
            
        } else {
            configuration=[NSMutableDictionary dictionaryWithDictionary:dict];
        }
        
        input=[self generateInput:inputDescription];

        
    }
    return self;
}
@end
