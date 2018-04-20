//
//  Optimization.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 7/12/14.
//  Copyright (c) 2014 Michal Cisarik. All rights reserved.
//

#import "Optimization.h"

@implementation Optimization {
    
    // properties
	int dimension;
	int numberGenerations;
	int numberVectors;
    
    // matrix arrays pointers for malloc
	long double **a_;
    long double **b_;
    
    double* averageFitness;
    double* bestFitnesses;
    
    int i,j,k,l,generation,iBest,jBest;
    
    double bestFitness;
    
    GFS *gfs;
    
    // random generator:
    MersenneTwister *mersennetwister;
    
    // output
    OUT *output;
    
    NSString *defaultMethod;
    
    NSMutableString *array_a;
    NSMutableString *array_b;
    
    NSString *longDoubleString_a;
    NSArray *subArray_a;
    NSString *subString_a;
    
    NSString *longDoubleString_b;
    NSArray *subArray_b;
    NSString *subString_b;
    
    int changePoint;
    int previousChangePoint;
}


-(void)mallocArrays {
    a_ = (long double **) malloc(sizeof(long double*) * numberVectors);
    a_[0] = (long double *) malloc(sizeof(long double) * dimension * numberVectors * 5 * 3);
    
    b_ = (long double **) malloc(sizeof(long double*) * numberVectors);
    b_[0] = (long double *) malloc(sizeof(long double) * dimension * numberVectors * 5 * 3);
    
    for ( i = 0; i < numberVectors; i++ ) {
        if(i) {
            
            a_[i] = a_[i-1] + numberVectors;
            
            b_[i] = b_[i-1] + numberVectors;
            
        }
    }
    
    averageFitness = (double *) malloc(sizeof(double) * numberGenerations);
    bestFitnesses = (double *) malloc(sizeof(double) * numberGenerations);
}

-(id)initBlindSearchWithGFS:(GFS*)fs{
    self = [super init];
    if (self) {
        
        gfs=fs;
        mersennetwister=[[MersenneTwister alloc]init];
        
        numberVectors=16;
        dimension = 33;// ElementWidth(33) * DoublesCountToArray(5)
        bestFitness = FLT_MAX;
       
        [self mallocArrays];
        
        NSMutableArray *points=[[NSMutableArray alloc]init];
        
        for ( i = 0; i < numberVectors; i++ ) {
            
            for (j = 0; j < dimension * 5 * 3; j++) {
                
               
                
                changePoint=0;
                Element *element1=[self getElement]; // changepoint max 10
                previousChangePoint=floor((10/changePoint)*0.33*50);
                
                [points addObject:[NSNumber numberWithInt:previousChangePoint]];
                
                changePoint=0;
                Element *element2=[self getElement];
                previousChangePoint+=floor((10/changePoint)*0.33*50);
                [points addObject:[NSNumber numberWithInt:previousChangePoint]];
                
                changePoint=0;
                Element *element3=[self getElement];
                previousChangePoint+=floor((10/changePoint)*0.33*50);
                [points addObject:[NSNumber numberWithInt:previousChangePoint]];
                
            
                
                Elements *elements=[[Elements alloc]initWithElements:@[element1,element2,element3] andChangePoints:points];
                NSLog(@"%@",elements);
                NSLog(@"\n\n");
                
            }
        }
    }
    return self;
}

-(Element*)getElement{
    array_a=[@"" mutableCopy];
    array_b=[@"" mutableCopy];
    
    for (k =0; k<5; k++) {
        a_[i][j]=[mersennetwister randomDouble0To1Exclusive];
        b_[i][j]=[mersennetwister randomDouble0To1Exclusive];
        
        if (a_[i][j]>0.5) {
            changePoint+=1;
        }
        if (b_[i][j]>0.5) {
            changePoint+=1;
        }
        
        longDoubleString_a=[NSString stringWithFormat:@"%.21Lg", (long double)a_[i][j]];
        longDoubleString_b=[NSString stringWithFormat:@"%.21Lg", (long double)b_[i][j]];
        
        subString_a=[longDoubleString_a componentsSeparatedByString:@"."][1]; // 0.12323 zero is omitted
        subString_b=[longDoubleString_b componentsSeparatedByString:@"."][1];

        for(l =0; l<=20;l+=2){
            int element_a=[[NSString stringWithFormat:@"%c%c",[subString_a characterAtIndex:l],[subString_a characterAtIndex:l+1]] intValue] % [gfs terminalsStartingIndex];
            
            
            int element_b=([[NSString stringWithFormat:@"%c%c",[subString_b characterAtIndex:l],[subString_b characterAtIndex:l+1]] intValue] % ([gfs size]-[gfs terminalsStartingIndex])+[gfs terminalsStartingIndex]);
            
            if (l==18) {
                array_a=[[array_a stringByAppendingString:[NSString stringWithFormat:@"%d",element_a] ] mutableCopy];
                array_b=[[array_b stringByAppendingString:[NSString stringWithFormat:@"%d",element_b] ] mutableCopy];
                
            } else {
                array_a=[[array_a stringByAppendingString:[NSString stringWithFormat:@"%d,",element_a] ] mutableCopy];
                array_b=[[array_b stringByAppendingString:[NSString stringWithFormat:@"%d,",element_b] ] mutableCopy];
            }
            
        }
    }
    
    return [[Element alloc]initWithString:[NSString stringWithFormat:@"[%@]\n[%@]",array_a,array_b] andGFS:gfs];
}

-(void)search {
    
    //if ([defaultMethod isEqualToString:@"Blind Search"]) {
        [self blindSearch];
    //}
  
}


-(void)blindSearch{
    
    double best=DBL_MAX;
    double tmp=0;
    
    for (generation = 0; generation < numberGenerations; generation++){
        
        
        
        for ( i = 0; i < numberVectors; i++ ) {
            
            for ( j = 0; j < numberVectors; j++ ) {
                //[gfs repairA:&a_[i][0] withB:&b_[j][0]];
                
                if([gfs errorA:&a_[i][0] withB:&b_[j][0]] < best) {
                    iBest=i;
                    jBest=j;
                    best=[gfs errorA:&a_[i][0] withB:&b_[j][0]];
                }
            }
        }
        
        tmp=[gfs errorA:&a_[iBest][0] withB:&b_[jBest][0]];
        
        
        if ([output insertFitness:tmp string:[NSString stringWithFormat:@"%@",[gfs describeA:&a_[iBest][0] withB:&b_[jBest][0]]] ofMethod:defaultMethod]) {
            
        }
    }
}

-(void)free{
    free(a_[0]);
    free(a_);
    free(b_[0]);
    free(b_);
	free(averageFitness);
	free(bestFitnesses);
}

@end
