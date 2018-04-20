//
//  GFS.m
//  Testovanie
//
//  Created by Michal Cisarik on 8/1/13.
//  Copyright (c) 2013 Michal Cisarik. All rights reserved.
//

#import "GFS.h"
#import "Loader.h"

#define ELEMENTSIZE 33
#define EVALUATE_REPAIRING_DEPTH 9

@implementation IN

@synthesize xs,ys,zs,min,max,count;

// Class methods: ======================================================================
+(NSMutableArray*) ekvidistantDoublesCount:(int)count min:(double)m max:(double)mx {
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    double dx=m;
    double rx=(abs(m)+abs(mx))/(double)count;
    double qx=0.0;
    for (int i=0; i<count; i++) {
        if (qx+rx-dx>-0.005 &&qx+rx-dx<0.005 ) {
            [array insertObject:[NSNumber numberWithDouble:0.0] atIndex:i ];
        }
        else [array insertObject:[NSNumber numberWithDouble:qx+rx+dx] atIndex:i ];
        qx=qx+rx;
    }
    return array;
    
}

// Instance methods: ====================================================================
-(id)initWithXs:(NSMutableArray *)x Ys:(NSMutableArray *)y Zs:(NSMutableArray *)z min:(double)i max:(double)mx andCount:(uint)c {
    self = [super init];
    if (self) {
        self.xs=x;
        self.ys=y;
        self.zs=z;
        self.min=i;
        self.max=mx;
        self.count=c;
    }
    return self;
}

@end

@implementation GFSelement
@synthesize name,nametex;
@end

@implementation GFSconst
-(id)initWith:(double)n {
    self = [super init];
    if (self) {
        constant=n;
        name=[NSString stringWithFormat:@"%.2f",n];
    }
    return self;
}
-(double)value{
    return (constant);
}
@end

@implementation GFSvar
-(id)initWith:(double *)n name:(NSString *)s andTex:(NSString*)tex{
    self = [super init];
    if (self) {
        variable=n;
        name=s;
        nametex=tex;
    }
    return self;
}
-(double)value{
    return (*variable);
}
@end

@implementation GFS2
-(double) eval:(double)parameter1 and:(double)parameter2{
    return function(parameter1,parameter2);
}
- (id)initWith:(func2) f name:(NSString *)n andTex:(NSString*)tex{
    self = [super init];
    if (self) {
        function=f;
        name=[[NSString alloc]initWithString:n];
        nametex=tex;
    }
    return self;
}
@end

@implementation GFS1
-(double) eval:(double)parameter1{
    return function(parameter1);
}
- (id)initWith:(func1) f name:(NSString *)n andTex:(NSString*)tex{
    self = [super init];
    if (self) {
        function=f;
        name=[[NSString alloc]initWithString:n];
        nametex=tex;
    }
    return self;
}
@end

@implementation GFS0
-(double) eval{
    return function();
}
- (id)initWith:(func0) f name:(NSString *)n andTex:(NSString*)tex{
    self = [super init];
    if (self) {
        function=f;
        name=[[NSString alloc]initWithString:n];
        nametex=tex;
    }
    return self;
}
@end



// ====================== // IMPLEMENTATION // ====================== GFSs
@implementation GFSs : NSObject {
    
    MersenneTwister *mersennetwister;
    Loader *loader;
    
}
-(id)initWithCommand:(NSString*)command GFSs:(int)count {
{
    self = [super init];
    if (self) {
        mersennetwister=[[MersenneTwister alloc]initWithSeed:(uint32_t)time(NULL)];
        
        _subGFSs=[NSMutableArray arrayWithCapacity:count];
        
        loader=[[Loader alloc]initWithInput:command settings:nil];
        
        uint64_t parentGFSbin=15; // ..0 1111
        
        uint64_t random32bits1;//=[mersennetwister randomUInt32];
        uint64_t random32bits2;//=[mersennetwister randomUInt32];
        
        uint64_t random64bits;//=random32bits2;
//        random64bits |= (random32bits1<<32);
        
        for (int i=0; i<count; i++) {
            
            random32bits1=[mersennetwister randomUInt32];
            random32bits2=[mersennetwister randomUInt32];
            
            random64bits=random32bits2;
            random64bits |= (random32bits1<<32);
            
            
            [ _subGFSs addObject: (id)[[GFS alloc]initWithGFSbin:random64bits configuration:loader.configuration input:loader.input parentGFSbin:parentGFSbin andSeed:[mersennetwister randomUInt32]]];
        }

    }
    return self;
}

    
}
@end

#pragma mark - GFS

@implementation GFS{
    
    OUT *output;

    __block double _x; // variable is used in dynamically created block
    __block double _y;
    
    
    NSMutableArray *consts;
    
    int _i;
    int _last_static;
    int _len_static;
    int _lastrepairing_static;
    int _lastbigger_static;
    int _depth;
    
    int* _last;
    int* _len;
    int* _lastrepairing;
    int* _lastbigger;
    
    int j;
    double sumdx,dx,da,db,dc;
    
    NSMutableString *temp;
    NSMutableString *buffer1;
    NSMutableString *buffer2;
    
    MersenneTwister *mersennetwister;
    
    uint64_t parentGFSbin;
}


@synthesize elements,variableNameInsteadOfValue,terminalsStartingIndex,bin,size,xpos,functions,constants,bestReinforcementFitness;

-(void)force:(uint64_t)b{
    
    if ((b&bit1)==bit1)
        [_configuration setObject:@YES forKey:@"forcebit1"];
    if ((b&bit2)==bit2)
        [_configuration setObject:@YES forKey:@"forcebit2"];
    if ((b&bit3)==bit3)
        [_configuration setObject:@YES forKey:@"forcebit3"];
    if ((b&bit4)==bit4)
        [_configuration setObject:@YES forKey:@"forcebit4"];
    if ((b&bit5)==bit5)
        [_configuration setObject:@YES forKey:@"forcebit5"];
    if ((b&bit6)==bit6)
        [_configuration setObject:@YES forKey:@"forcebit6"];
    if ((b&bit7)==bit7)
        [_configuration setObject:@YES forKey:@"forcebit7"];
    if ((b&bit8)==bit8)
        [_configuration setObject:@YES forKey:@"forcebit8"];
    if ((b&bit9)==bit9)
        [_configuration setObject:@YES forKey:@"forcebit9"];
    if ((b&bit10)==bit10)
        [_configuration setObject:@YES forKey:@"forcebit10"];
    if ((b&bit11)==bit11)
        [_configuration setObject:@YES forKey:@"forcebit11"];
    if ((b&bit12)==bit12)
        [_configuration setObject:@YES forKey:@"forcebit12"];
    if ((b&bit13)==bit13)
        [_configuration setObject:@YES forKey:@"forcebit13"];
    if ((b&bit14)==bit14)
        [_configuration setObject:@YES forKey:@"forcebit14"];
    if ((b&bit15)==bit15)
        [_configuration setObject:@YES forKey:@"forcebit15"];
    if ((b&bit16)==bit16)
        [_configuration setObject:@YES forKey:@"forcebit16"];
    if ((b&bit17)==bit17)
        [_configuration setObject:@YES forKey:@"forcebit17"];
    if ((b&bit18)==bit18)
        [_configuration setObject:@YES forKey:@"forcebit18"];
    if ((b&bit19)==bit19)
        [_configuration setObject:@YES forKey:@"forcebit19"];
    if ((b&bit20)==bit20)
        [_configuration setObject:@YES forKey:@"forcebit20"];
    if ((b&bit21)==bit21)
        [_configuration setObject:@YES forKey:@"forcebit21"];
    if ((b&bit22)==bit22)
        [_configuration setObject:@YES forKey:@"forcebit22"];
    if ((b&bit23)==bit23)
        [_configuration setObject:@YES forKey:@"forcebit23"];
    if ((b&bit24)==bit24)
        [_configuration setObject:@YES forKey:@"forcebit24"];
    if ((b&bit25)==bit25)
        [_configuration setObject:@YES forKey:@"forcebit25"];
    if ((b&bit26)==bit26)
        [_configuration setObject:@YES forKey:@"forcebit26"];
    if ((b&bit27)==bit27)
        [_configuration setObject:@YES forKey:@"forcebit27"];
    if ((b&bit28)==bit28)
        [_configuration setObject:@YES forKey:@"forcebit28"];
    if ((b&bit29)==bit29)
        [_configuration setObject:@YES forKey:@"forcebit29"];
    if ((b&bit30)==bit30)
        [_configuration setObject:@YES forKey:@"forcebit30"];
    if ((b&bit31)==bit31)
        [_configuration setObject:@YES forKey:@"forcebit31"];
    
}


/*! Instantiate GFS
 \return self
 */
-(id)initWithGFSbin:(uint64_t)b configuration:(NSMutableDictionary *)cfg input:(IN*)data parentGFSbin:(uint64_t)parent andSeed:(uint32_t)seed{
    
    self = [super init];
    if (self) {
        parentGFSbin=parent;
        _input=data;
        _configuration=cfg;
        //_consts=[configuration objectForKey:@"constants"];
        output=[[OUT alloc]initWithConfiguration:_configuration andGFS:self];
        bin=b;
        
        // local random generator initialized by "seed" parameter
        mersennetwister=[[MersenneTwister alloc]initWithSeed:(uint32_t)seed];
        
        
        // main object of the GFS class - NSMutableArray "container" for all functions
        elements=[[NSMutableArray alloc] initWithCapacity:64];
    
        _last=&_last_static;
        _len=&_len_static;
        _lastrepairing=&_lastrepairing_static;
        _lastbigger=&_lastbigger_static;
        
        bit1 = 1;          // 2^0   add
        bit2 = 1 << 1;     // 2^1   sub
        bit3 = 1 << 2;     // 2^2   mul
        bit4 = 1 << 3;     // 2^3   div
        bit5 = 1 << 4;     // 2^4   sin
        bit6 = 1 << 5;     // 2^5   cos
        bit7 = 1 << 6;     // 2^6   tan
        bit8 = 1 << 7;     // 2^7   log
        bit9 = 1 << 8;     // 2^8   log2
        bit10 = 1 << 9;    // 2^9   log10
        bit11 = 1 << 10;   // 2^10  pow2
        bit12 = 1 << 11;   // 2^11  pow3
        bit13 = 1 << 12;   // 2^12  pow4
        bit14 = 1 << 13;   // 2^13  pow5
        bit15 = 1 << 14;   // 2^14  pow6
        bit16 = 1 << 15;   // 2^15  1
        bit17 = 1 << 16;   // 2^16  2
        bit18 = 1 << 17;   // 2^17  3
        bit19 = 1 << 18;   // 2^18  4
        bit20 = 1 << 19;   // 2^19  5
        bit21 = 1 << 20;   // 2^20  6
        bit22 = 1 << 21;   // 2^21  7
        bit23 = 1 << 22;   // 2^22  8
        bit24 = 1 << 23;   // 2^23  9
        bit25 = 1 << 24;   // 2^24  ^
        bit26 = 1 << 25;   // 2^25  sqrt
        bit27 = 1 << 26;   // 2^26  abs
        bit28 = 1 << 27;   // 2^27  exp
        bit29 = 1 << 28;   // 2^28  pi
        bit30 = 1 << 29;   // 2^29  e
        bit31 = 1 << 30;   // 2^30  phi
        
        // create functions for GFSelement objects :
        
        // <subgfs mathtype="aritmetic">
        func2 _add = ^(double a, double b) { return a + b; };   // <functions type="GFS2"><f name="plus" p1="double" p2="double" command="+"></f>
        func2 _sub = ^(double a, double b) { return a - b; };   // <f name="minus" p1="double" p2="double" command="-"></f>
        func2 _mul = ^(double a, double b) { return a * b; };   // ...
        func2 _div = ^(double a, double b) { return a / b; };   // </functions>
        
        //<constants>
        //<c name="1" command="3">
        //</constants>
        //<variable>
        //</subgfs>
        
        func1 _sin = ^(double par) { return sin(par); };
        func1 _cos = ^(double par) { return cos(par); };
        func1 _tan = ^(double par) { return tan(par); };
        
        func1 _log = ^(double par) { return log(par); };
        func1 _log2 = ^(double par) { return log2(par); };
        func1 _log10 = ^(double par) { return log10(par); };
        
        func1 _pow2 = ^(double par) { return pow(par,2); };
        func1 _pow3 = ^(double par) { return pow(par,3); };
        func1 _pow4 = ^(double par) { return pow(par,4); };
        func1 _pow5 = ^(double par) { return pow(par,5); };
        func1 _pow6 = ^(double par) { return pow(par,6); };
        
        func0 _1=^() { return (double) 1; };
        func0 _2=^() { return (double) 2; };
        func0 _3=^() { return (double) 3; };
        func0 _4=^() { return (double) 4; };
        func0 _5=^() { return (double) 5; };
        func0 _6=^() { return (double) 6; };
        func0 _7=^() { return (double) 7; };
        func0 _8=^() { return (double) 8; };
        func0 _9=^() { return (double) 9; };
        
        func2 _up = ^(double a, double b) { return pow(a,b); };
        
        func1 _sqrt = ^(double par) { return sqrt(par); };
        func1 _abs = ^(double par) { return fabs(par); };
        func1 _exp = ^(double par) { return exp(par); };
        
        func0 _pi=^() { return (double) M_PI; };
        func0 _e=^() { return (double) M_E; };
        func0 _phi=^() { return (double) 1.618033988749894848204586834365; };
        
        // initial values for variables which may be used in elements:
        _x=1;
        _y=1;
        
        functions=0;
        
        [self force:parentGFSbin];
        [self force:bin];
        
        bin=0;

        
        if ([[_configuration objectForKey:@"arithmeticFunctions"] isEqual:@YES]){
            
            if ([[_configuration objectForKey:@"forcebit1"]isEqual:@YES]) {
                [elements insertObject:[[GFS2 alloc]initWith:_add name:@"+" andTex:@"x + y"] atIndex:functions++ ];
                bin|=bit1;
            }
            
            if ([[_configuration objectForKey:@"forcebit2"]isEqual:@YES]) {
                [elements insertObject:[[GFS2 alloc]initWith:_sub name:@"-" andTex:@"x - y"] atIndex:functions++ ];
                bin|=bit2;
            }
            
            if ([[_configuration objectForKey:@"forcebit3"]isEqual:@YES]) {
                [elements insertObject:[[GFS2 alloc]initWith:_mul name:@"*" andTex:@"{x}\\\\cdot{y}"] atIndex:functions++ ];
                bin|=bit3;
            }
            
            
            if ([[_configuration objectForKey:@"forcebit4"]isEqual:@YES]) {
                [elements insertObject:[[GFS2 alloc]initWith:_div name:@"/" andTex:@"x / y"] atIndex:functions++ ];
                bin|=bit4;
            }
            
        }
        
        if ([[_configuration objectForKey:@"exponentialFunction"] isEqual:@YES]) {
            
            if ([[_configuration objectForKey:@"forcebit25"] isEqual:@YES]) {
                [elements insertObject:[[GFS2 alloc]initWith:_up name:@"^" andTex:@"x^{y}"] atIndex:functions++ ];
                bin|=bit25;
            }
        }
        
        if ([[_configuration objectForKey:@"goniometricFunctions"] isEqual:@YES]) {
            
            if ([[_configuration objectForKey:@"forcebit5"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_sin name:@"sin" andTex:@"\\\\sin(x)"] atIndex:functions++ ];
                bin|=bit5;
            }
            
            if ([[_configuration objectForKey:@"forcebit6"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_cos name:@"cos" andTex:@"\\\\cos(x)"] atIndex:functions++ ];
                bin|=bit6;
            }
            
            if ([[_configuration objectForKey:@"forcebit7"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_tan name:@"tan" andTex:@"\\\\tan(x)"] atIndex:functions++ ];
                bin|=bit7;
            }
            
        }
        if ([[_configuration objectForKey:@"logarithmicFunctions"] isEqual:@YES]) {
            
            if ([[_configuration objectForKey:@"forcebit8"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_log name:@"log" andTex:@"\\\\ln(x)"] atIndex:functions++ ];
                bin|=bit8;
            }
            
            if ([[_configuration objectForKey:@"forcebit9"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_log2 name:@"log2" andTex:@"\\\\log_2(x)"] atIndex:functions++ ];
                bin|=bit9;
            }
            
            if ([[_configuration objectForKey:@"forcebit10"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_log10 name:@"log10" andTex:@"\\\\log(x)"] atIndex:functions++ ];
                bin|=bit10;
            }
        }
        if ([[_configuration objectForKey:@"polynomialFunctions"] isEqual:@YES]) {
            
            if ([[_configuration objectForKey:@"forcebit11"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow2 name:@"^2" andTex:@"x^2"] atIndex:functions++ ];
                bin|=bit11;
            }
            
            if ([[_configuration objectForKey:@"forcebit12"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow3 name:@"^3" andTex:@"x^3"] atIndex:functions++ ];
                bin|=bit12;
            }
            
            if ([[_configuration objectForKey:@"forcebit13"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow4 name:@"^4" andTex:@"x^4"] atIndex:functions++ ];
                bin|=bit13;
            }
            
            if ([[_configuration objectForKey:@"forcebit14"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow5 name:@"^5" andTex:@"x^5"] atIndex:functions++ ];
                bin|=bit14;
            }
            
            if ([[_configuration objectForKey:@"forcebit15"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_pow6 name:@"^6" andTex:@"x^6"] atIndex:functions++ ];
                bin|=bit15;
            }
        }
        
        if ([[_configuration objectForKey:@"otherFunctions"] isEqual:@YES]) {
            
            if ([[_configuration objectForKey:@"forcebit26"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_sqrt name:@"sqrt" andTex:@"\\\\sqrt{x}"] atIndex:functions++ ];
                bin|=bit26;
            }
            
            if ([[_configuration objectForKey:@"forcebit27"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_abs name:@"abs" andTex:@"|x|"] atIndex:functions++ ];
                bin|=bit27;
            }
            
            if ([[_configuration objectForKey:@"forcebit28"] isEqual:@YES]) {
                [elements insertObject:[[GFS1 alloc]initWith:_exp name:@"exp" andTex:@"\\\\exp(x)"] atIndex:functions++ ];
                bin|=bit28;
            }
            
        }
        
        int variables=0;
        
        [elements insertObject:[[GFSvar alloc] initWith:&_x name:@"x" andTex:@"x"] atIndex:functions++];
        variables+=1;
        
        if ([[_configuration objectForKey:@"3D"] isEqual:@YES]) {
            [elements insertObject:[[GFSvar alloc] initWith:&_y name:@"y" andTex:@"y"] atIndex:functions++];
            variables+=1;
        }
        
        xpos=functions;
        
        terminalsStartingIndex=xpos-variables;
        
        
        if ([[_configuration objectForKey:@"linearConstants"] isEqual:@YES]) {
            
            if ([[_configuration objectForKey:@"forcebit16"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_1 name:@"1" andTex:@"1"] atIndex:xpos++];
                bin|=bit16;
            }
            
            if ([[_configuration objectForKey:@"forcebit17"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_2 name:@"2" andTex:@"2"] atIndex:xpos++];
                bin|=bit17;
            }
            
            if ([[_configuration objectForKey:@"forcebit18"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_3 name:@"3" andTex:@"3"] atIndex:xpos++];
                bin|=bit18;
            }
            
            if ([[_configuration objectForKey:@"forcebit19"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_4 name:@"4" andTex:@"4"] atIndex:xpos++];
                bin|=bit19;
            }
            
            if ([[_configuration objectForKey:@"forcebit20"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_5 name:@"5" andTex:@"5"] atIndex:xpos++];
                bin|=bit20;
            }
            
            if ([[_configuration objectForKey:@"forcebit21"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_6 name:@"6" andTex:@"6"] atIndex:xpos++];
                bin|=bit21;
            }
            
            if ([[_configuration objectForKey:@"forcebit22"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_7 name:@"7" andTex:@"7"] atIndex:xpos++];
                bin|=bit22;
            }
            
            if ([[_configuration objectForKey:@"forcebit23"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_8 name:@"8" andTex:@"8"] atIndex:xpos++];
                bin|=bit23;
            }
            
            if ([[_configuration objectForKey:@"forcebit24"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_9 name:@"9" andTex:@"9"] atIndex:xpos++];
                bin|=bit24;
            }
        }
        
        if ([[_configuration objectForKey:@"mathConstants"]isEqual:@YES]) {
            if ([[_configuration objectForKey:@"forcebit29"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_pi name:@"pi" andTex:@"\\\\pi"] atIndex:xpos++];
                bin|=bit29;
            }
            
            if ([[_configuration objectForKey:@"forcebit30"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_e name:@"e" andTex:@"e^{x})"] atIndex:xpos++];
                bin|=bit30;
            }
            
            if ([[_configuration objectForKey:@"forcebit31"] isEqual:@YES]) {
                [elements insertObject:[[GFS0 alloc]initWith:_phi name:@"phi" andTex:@"\\\\phi"] atIndex:xpos++];
                bin|=bit31;
            }
        }
        
        uint64_t originalgfsbin=bin;//[[configuration objectForKey:@"GFSbin"]longLongValue];
        int tempbit = 0;
        uint64_t actualbit;
        
        if ([[_configuration objectForKey:@"reinforcedConstants"]isEqual:@YES]) {
            for (j=0; j<[(NSArray*)[_configuration objectForKey:@"constants"]count]; j++) {
          
                    [elements insertObject:[[GFSconst alloc]initWith:[[_configuration objectForKey:@"constants"][j]doubleValue]] atIndex:xpos++];
                
            }
        }
        
        
        if ([[_configuration objectForKey:@"randomConstants"]isEqual:@YES]) {
            for (j=0; j<[[_configuration objectForKey:@"randomConstantsCount"]intValue]; j++) {
                actualbit = 1 << (32+j);
                tempbit=(32+j);
                if ((b&actualbit)==actualbit) {
                    bin|=actualbit;
                    [elements insertObject:[[GFSconst alloc]initWith:[mersennetwister randomDoubleFrom:[[_configuration objectForKey:@"constantMinValue"]doubleValue] to:[[_configuration objectForKey:@"constantMaxValue"]doubleValue]]] atIndex:xpos++];
                }
            }
        }
        

        constants=xpos-terminalsStartingIndex-variables;
        
        //size=constants+functions;
        reinforcementStartingIndex=xpos;
        
        //TODO: Reinforcement initialization:
        
//        if ([[_configuration objectForKey:@"reinforcedElements"]isEqual:@YES]) {
//            for (j=0; j<[(NSArray*)[_configuration objectForKey:@"reinforcements"] count]; j++) {
//                actualbit = 1 << tempbit;
//                tempbit+=1;
//                if ((b&actualbit)==actualbit) {
//                    bin|=actualbit;
//                    
//                    Element *reinforcing=[[Element alloc]initWithString:[_configuration objectForKey:@"reinforcements"][j] andGFS:self];
//               
//                    [elements insertObject:reinforcing atIndex:xpos++];
//                    
//                    //NSLog(@"%@",reinforcing.name);
//                
//                }
//            }
//        }
        
        if ([[_configuration objectForKey:@"randomElements"]isEqual:@YES]) {
            for (j=0; j<[[_configuration objectForKey:@"randomElementsCount"]intValue]; j++) {
                actualbit = 1 << tempbit;
                tempbit+=1;
                if ((b&actualbit)==actualbit) {
                    bin|=actualbit;
                    Element *reinforcing=[[Element alloc]initWithSeed:[mersennetwister randomUInt32] forGFS:self];
                 
                    [elements insertObject:reinforcing atIndex:xpos++];
                    
                    NSLog(@"%@",reinforcing);
                }
            }
        }
        
        size=xpos;
    }
    
    return self;
}


-(void)setValueOf:(NSString*)var value:(double)val{
    if ([var isEqual:@"x"])
        _x=val;
    if ([var isEqual:@"y"])
        _y=val;
}


-(NSString *)toTeXStringRecursive:(int[])array at:(int) i last:(int*)last max:(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger{
    int j=*last;
    GFSelement *f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        *last+=2;
        
        if ([[((GFS2*)f) name] isEqualToString:@"*"])
            return [NSString stringWithFormat:@"({%@}\\\\cdot{%@})",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [self toTeXStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS2*)f) name] isEqualToString:@"^"])
            return [NSString stringWithFormat:@"(%@^{%@})",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [self toTeXStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS2*)f) name] isEqualToString:@"/"])
            return [NSString stringWithFormat:@"(\\\\frac{%@}{%@})",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [self toTeXStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        return [NSString stringWithFormat:@"(%@%@%@)",
                [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                [((GFS2*)f) name],
                [self toTeXStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        *last+=1;
        
        if ([[((GFS1*)f) name] isEqualToString:@"sqrt"])
            return [NSString stringWithFormat:@"(\\\\sqrt{%@}",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"abs"])
            return [NSString stringWithFormat:@"|{x}|",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"e^"])
            return [NSString stringWithFormat:@"\\\\e^{%@}",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"log"])
            return [NSString stringWithFormat:@"(\\\\ln(%@))",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"log2"])
            return [NSString stringWithFormat:@"(\\\\log_2(%@))",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        if ([[((GFS1*)f) name] isEqualToString:@"log10"])
            return [NSString stringWithFormat:@"(\\\\log(%@))",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if (([[((GFS1*)f) name] isEqualToString:@"^2"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^3"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^4"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^5"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^6"]))
            
            return [NSString stringWithFormat:@"(%@%@)",
                    [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [((GFS1*)f) name]];
        
        else return [NSString stringWithFormat:@"\\\\%@(%@)",
                     [((GFS1*)f) name],
                     [self toTeXStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        
        if (([[((GFS1*)f) name] isEqualToString:@"pi"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"e"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"phi"]))
            return [NSString stringWithFormat:@"/%@",[((GFS0*)f) name]];
        
        return [NSString stringWithFormat:@"%@",[((GFS0*)f) name]];
        
    } else if ([f conformsToProtocol: @protocol( GFSreinforced )]){
        
    return [((Element*)f) name];
    
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        if (variableNameInsteadOfValue)
            return [f name];
        if ([[f name] isEqual:@"x"])
            return[NSString stringWithFormat:@"%g",_x];
        else if ([[f name] isEqual:@"y"])
            return[NSString stringWithFormat:@"%g",_y];
        
    } else if ([f conformsToProtocol: @protocol( GFSconstant )]){
        return [f name];
    }
    return @"_";
}

-(NSString *)toStringRecursive:(int[])array at:(int) i last:(int*)last max:(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger{
    int j=*last;
    GFSelement *f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        *last+=2;
        return [NSString stringWithFormat:@"(%@%@%@)",
                [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                [((GFS2*)f) name],
                [self toStringRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        
        *last+=1;
        
        if ([[((GFS1*)f) name] isEqualToString:@"log"])
            return [NSString stringWithFormat:@"log(%f,%@)",M_E,
                    
                    [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if ([[((GFS1*)f) name] isEqualToString:@"log2"])
            return [NSString stringWithFormat:@"log(2,%@)",
                    [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        if ([[((GFS1*)f) name] isEqualToString:@"log10"])
            return [NSString stringWithFormat:@"log(10,%@)",
                    [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
        if (([[((GFS1*)f) name] isEqualToString:@"^2"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^3"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^4"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^5"]) ||
            ([[((GFS1*)f) name] isEqualToString:@"^6"]))
            
            return [NSString stringWithFormat:@"(%@%@)",
                    [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger],
                    [((GFS1*)f) name]];
        
        else return [NSString stringWithFormat:@"%@(%@)",
                     [((GFS1*)f) name],
                     [self toStringRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger]];
        
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        
        if ([[((GFS1*)f) name] isEqualToString:@"pi"] )
            return [NSString stringWithFormat:@"%f",M_PI];
        
        if ([[((GFS1*)f) name] isEqualToString:@"e"] )
            return [NSString stringWithFormat:@"%f",M_E];
        
        if ([[((GFS1*)f) name] isEqualToString:@"phi"] )
            return @"1.618033988749894848204586834365";
        
        return [NSString stringWithFormat:@"%@",[((GFS0*)f) name]];
        
    } else if ([f conformsToProtocol: @protocol( GFSreinforced )]){
         
        return [((Element*)f) name];
         
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        if (variableNameInsteadOfValue)
            return [f name];
        if ([[f name] isEqual:@"x"])
            return[NSString stringWithFormat:@"%g",_x];
        else if ([[f name] isEqual:@"y"])
            return[NSString stringWithFormat:@"%g",_y];
        
    } else if ([f conformsToProtocol: @protocol( GFSconstant )]){
        return [NSString stringWithFormat:@"%.16f",[((GFSconst *)f)value]];
    }
    return @"_";
}


-(double)evaluateRecursive:(int[]) array
                        at:(int)  i
                      last:(int*) last
                       max:(int*) len
                 repairing:(int[]) repairing
             lastrepairing:(int*) lastrepairing
                lastbigger:(int*) lastbigger
                     depth:(int*) depth{
    
    // necessary local variables inside recursion:
    int j = *last;
    GFSelement *f;
    double a,b,result;
    
    // get right GFS elements by number from array of indexes - expression
    f=[elements objectAtIndex:array[i]];
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        
        *last+=2;
        
        a=[self evaluateRecursive:&array[0] at:j+1 last:last max:len repairing:&repairing[0] lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        
        b=[self evaluateRecursive:&array[0] at:j+2 last:last max:len repairing:&repairing[0] lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS2 *)f) eval: a and: b];
        
        return result;
        
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        
        *last+=1;
        
        b=[self evaluateRecursive:&array[0] at:j+1 last:last max:len repairing:&repairing[0] lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        
        result=[((GFS1 *)f) eval:b];
        
        *depth+=1;
        
        return result;
        
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        
        return [((GFS0 *)f) eval];
    
     } else if ([f conformsToProtocol: @protocol( GFSreinforced )]){
     
         return [((Element *)f) eval];
     
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        
        if ([[f name] isEqual:@"x"])
            
            return _x;
        
        else if ([[f name] isEqual:@"y"])
            
            return _y;
        
    } else if ([f conformsToProtocol: @protocol( GFSconstant )]){
        
        return [((GFSconst *)f)value];
    }
    
    return (double) NAN; //.. Something went wrong so just return "not a number" so array can be repaired - this is also needed for ending recursion and avoid endless loops
}

-(double)evaluateRepairingRecursive:(int[]) array
                                 at:(int)  i
                               last:(int*) last
                                max:(int*) len
                          repairing:(int[]) repairing
                      lastrepairing:(int*) lastrepairing
                         lastbigger:(int*) lastbigger
                              depth:(int*) depth{
    
    // necessary local variables inside recursion:
    int j = *last;
    GFSelement *f;
    double a,b,result;
    
    if ((*last > [[_configuration objectForKey:@"ElementSize"]intValue])||(*lastrepairing > [[_configuration objectForKey:@"ElementSize"]intValue])) { // if there are no more elements to get from the repairing array
        
        f=[elements objectAtIndex:terminalsStartingIndex];
        array[i]=terminalsStartingIndex;                 // just use "x" variable
    }
    else if (*depth > [[_configuration objectForKey:@"ElementDepth"]intValue]) {
        *depth = 0;
        f=[elements objectAtIndex:repairing[(*lastrepairing)]];
        array[i]=repairing[*lastrepairing];
        *lastrepairing+=1;
    }
    else if (*last > [[_configuration objectForKey:@"ElementWidth"]intValue]) {
        
        f=[elements objectAtIndex:repairing[(*lastrepairing)]];
        array[i]=repairing[*lastrepairing];
        *lastrepairing+=1;
    }
    else
        f=[elements objectAtIndex:array[i]];
    
    
    if ([f conformsToProtocol: @protocol( GFSreinforced )]){
    
        int _i_temp=i;
        int _last_static_temp=(*last);
        int _lastrepairing_static_temp=(*lastrepairing);
        int _lastbigger_static_temp=(*lastbigger);
        int _depth_temp=(*depth);

        result = [((Element *)f) eval];

        _i=_i_temp;
        _last_static=_last_static_temp;
        _lastrepairing_static=_lastrepairing_static_temp;
        _lastbigger_static=_lastbigger_static_temp;
        _depth=_depth_temp;
         
        return result;
     
    }
    
    if ([f conformsToProtocol: @protocol( GFS2args )]){
        
        *last+=2;
        
        // ==== > recursion 1:
        
        a=[self evaluateRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        
        // < ====
        
        // ==== > recursion 2:
        
        b=[self evaluateRepairingRecursive:array at:j+2 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS2 *)f) eval: a and: b];
        
        // < ====
        
        // now when both arguments are evaluated we can check if their value can be avalueted in general:
        
        if ((a == NAN) || (b == NAN) || (a == INFINITY) || (b == INFINITY) ||
            (a == -INFINITY) || (b == -INFINITY) || (result == NAN) ||
            (result == INFINITY) || (result == -INFINITY)){
            
            f=[elements objectAtIndex:repairing[*lastrepairing]];
            
        // repairing of the element:
            
            array[i]=repairing[*lastrepairing];
            *lastrepairing+=1;
            
        } else return result;
        
    } else if ([f conformsToProtocol: @protocol( GFS1args )]){
        *last+=1;
        
        // ==== > recursion:
        
        // evaluateRepairingRecursive:array and start with j+1
        b=[self evaluateRepairingRecursive:array at:j+1 last:last max:len repairing:repairing lastrepairing:lastrepairing lastbigger:lastbigger depth:depth];
        result=[((GFS1 *)f) eval:b];
        
        // < ====
        
        if ((b == NAN) || (b==INFINITY) || (b==-INFINITY) || (result == NAN) || (result == INFINITY) || (result == -INFINITY)) {
            f=[elements objectAtIndex:repairing[*lastrepairing]];
            array[i]=repairing[*lastrepairing];
            *lastrepairing+=1;
            
        } else {
            *depth+=1;
            return result;
        }
        
    } else if ([f conformsToProtocol: @protocol( GFS0args )]){
        return [((GFS0 *)f) eval];
        
    } else if ([f conformsToProtocol: @protocol( GFSvariable )]){
        
        if ([[f name] isEqual:@"x"])
            return _x;
        
        else if ([[f name] isEqual:@"y"])
            return _y;
        
    } else if ([f conformsToProtocol: @protocol( GFSconstant )]){
        
        return [((GFSconst *)f)value];
    }
    return (double)NAN;
}

-(NSString*)reinforcementDescription{
    NSMutableString *t=[NSMutableString stringWithString:@""];
    Element *best=nil;
    double bestFitness=FLT_MAX;
    double error;
    for (id element in elements){
        if ([element conformsToProtocol:@protocol(GFSreinforced)]){
            error=[(Element*)element error];
            if ((error<bestFitness)&&(error!=NAN)) {
                best=element;
                bestFitness=error;
            }
        }
    }
    
    self.bestReinforcementFitness = bestFitness;
    [t appendString:[NSString stringWithFormat:@"%@, ",(Element*)best]];
    
    return [NSString stringWithString:t];
}

-(NSString*)description{
    NSMutableString *t=[NSMutableString stringWithString:@""];
    for (id element in elements){
//        if ([element conformsToProtocol:@protocol(GFSreinforced)]){
//            
//        }
//        else if (![element conformsToProtocol:@protocol(GFSconstant)])
        
        self.variableNameInsteadOfValue=YES;
        
        if ([element conformsToProtocol:@protocol(GFSreinforced)]){
            double err=[(Element*)element error];
            if ((!isnan(err))&&(err<10000000000)) {
                [t appendString:[NSString stringWithFormat:@"%@, ",(Element*)element]];
            }
        
            continue;
        } else if ([element nametex]){
            [t appendString:[NSString stringWithFormat:@"%@, ",[element nametex]]];
        } else {
            [t appendString:[NSString stringWithFormat:@"%@, ",[element name]]];
        }
        
    }
    return [NSString stringWithString:t];

}

-(void)null {
    _i=0;
    _last_static=0;
    _len_static=[[_configuration objectForKey:@"ElementSize"]intValue];
    _lastrepairing_static=0;
    _lastbigger_static=0;
    _depth=[[_configuration objectForKey:@"ElementDepth"]intValue];
}

-(NSString *)describeA:(int[])_a withB:(int[])_b{
    
    temp=[NSMutableString stringWithFormat:@""];
    buffer1=[NSMutableString stringWithFormat:@""];
    buffer2=[NSMutableString stringWithFormat:@""];
    
    for (int v = 0; v < [[_configuration objectForKey:@"ElementSize"]intValue]; v++) {
        [buffer1 appendString:[NSString stringWithFormat:@"%d,",_a[v]]];
        [buffer2 appendString:[NSString stringWithFormat:@"%i,",_b[v]]];
    }
    
    //[temp appendFormat:@"\n[%@]\n[%@]\n",buffer1,buffer2];
    
    self.variableNameInsteadOfValue=YES;
    
    double fitness=[self errorA:&_a[0] withB:&_b[0]];
    
    [temp appendString:[NSString stringWithFormat:@"\n%llu\n[%@]\n[%@]\n%@\n%@\n%@",[self bin],buffer1,buffer2,[self stringA:&_a[0] withB:&_b[0]],[self teXStringA:&_a[0] withB:&_b[0]],[NSNumber numberWithDouble:fitness]]];
    
    return [NSString stringWithFormat:@"%@",temp];
    
}

-(NSString *)stringA:(int[])_a withB:(int[])_b{
    [self null];
    return [self toStringRecursive:&_a[0]
                                at:_i
                              last:_last
                               max:_len
                         repairing:&_b[0]
                     lastrepairing:_lastrepairing
                        lastbigger:_lastbigger];
}

-(NSString *)teXStringA:(int[])_a withB:(int[])_b{
    [self null];
    return [self toTeXStringRecursive:&_a[0]
                                   at:_i
                                 last:_last
                                  max:_len
                            repairing:&_b[0]
                        lastrepairing:_lastrepairing
                           lastbigger:_lastbigger];
}



-(double)evalA:(int[])_a withB:(int[])_b{
    [self null];
    return [self evaluateRepairingRecursive:&_a[0] at:_i last:_last max:_len repairing:&_b[0] lastrepairing:_lastrepairing lastbigger:_lastbigger depth:&_depth];
}


-(double)errorA:(int[])_a withB:(int[])_b{

        double sumdx=0;
        double error=0;
        double da,db,dc,dx;
        int x,y;
        int j;
        
        if ([[_configuration objectForKey:@"3D"] isEqual:@YES]) {
            
            for (x=0; x<50; x++) {
                for (y=0; y<50; y++) {
                    
                    db=[_input.xs[x] doubleValue];
                    dc=[_input.ys[y] doubleValue];
                    
                    [self setValueOf:@"x" value:db];
                    [self setValueOf:@"y" value:dc];
                    
                    da=[self evalA:&_a[0] withB:&_b[0]];
                    
                    dx=[_input.zs[x*y-x] doubleValue];
                    
                    sumdx+=fabs(da-dx);
                }
                
            }
            return sumdx;
        }
        
        for (j=0; j<50; j++) {
            
            dx=[_input.xs[j] doubleValue];
            
            
            
            [self setValueOf:@"x" value:dx];
            
            da=[self evalA:&_a[0] withB:&_b[0]];
            
            if ((da==NAN)||(da==-INFINITY)||(da==INFINITY))
                
                return NAN;
            
            db=[_input.ys[j] doubleValue];
            
            sumdx+=fabs(da-db);
        }
        return sumdx;
}


-(void)reinforceWith:(Element*)c{
    [elements addObject:c];
    size+=1;
}


@end

@implementation OUT {
    int i,j;
    double a,b,dx,dy,sumdx;
    double best;
    NSMutableString *mutable;
    NSMutableArray *_elements;
}

@synthesize gfs,configuration,elements,history;

-(id)initWithConfiguration:(NSMutableDictionary*)con andGFS:(GFS*)gs{
    self = [super init];
    if (self) {
        best=DBL_MAX;
        self.configuration=con;
        self.gfs=gs;
        self.history=[[NSMutableDictionary alloc]initWithCapacity:100];
        self.elements=[[NSMutableArray alloc]initWithCapacity:100];
    }
    return self;
}

-(BOOL)insertFitness:(double)f string:(NSString*)s ofMethod:(NSString*)m{
    
    if ((f<best)&&(f!=NAN)) {
        
        [history setValue:s forKey:[NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:f]]];
        best=f;
        //[lock lock];
        NSLog(@"\n%@\n%@\n\n",m,[self bestDescription]); //DEBUGGING
        //[lock unlock];
        return YES;
    }
    
    return NO;
}

-(NSString*)bestDescription{
    if (best!=FLT_MAX)
        return [NSString stringWithFormat:@"%@",[history  objectForKey:[NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:best]]]];
    else
        return @"";
}

-(NSString*)description{
    mutable=[NSMutableString stringWithFormat:@""];
    for (NSString *n in [history allKeys]) {
        [mutable appendString:[NSString stringWithFormat:@"%@",[history objectForKey:n]]];
    }
    return [NSString stringWithFormat:@"%@\n",mutable];
}


-(int*)repairingArray:(int)at{
    int i=3;
    return &i;
}
-(void)randomizeRepairingArray:(int)at{
    
}
-(void)setRepairingArray:(int[])a at:(int)at{
    
}
@end


@implementation Elements

-(id)initWithElements:(NSArray*)elems andChangePoints:(NSArray*)points{
    
    self = [super init];
    if (self) {
        elements=[elems copy];
        changePoints=[points copy];

    }
    return self;
}

-(NSString*)description{
    
    NSMutableString *out=[@"" mutableCopy];
   
        int j,index,changepoint,sub;
        
        GFS *gfs=((Element*)[elements objectAtIndex:0]).gfs;
        Element *subElement;
        
        index=0;
        changepoint=[[changePoints objectAtIndex:index]intValue];
        sub=0;
        subElement=(Element*)[elements objectAtIndex:sub];
    
        int count=(int)elements.count;
        [out appendString:[NSString stringWithFormat:@"y in < -inf,%@ > : %@\n", gfs.input.ys[sub], subElement]];
    
    
        double da;//=[gfs.input.ys[0] doubleValue];
        
        for (j=0; j<50; j++) {
            
            if (index>=changepoint) {
               
                if ( sub>=count-1 ) {
                    
                    subElement=(Element*)[elements objectAtIndex:sub];
                    break;
                } else {
                    [out appendString:[NSString stringWithFormat:@"y in <%@,%@> : %@\n", gfs.input.ys[sub], gfs.input.ys[sub+1], subElement]];
                    sub+=1;
                }
                
                subElement=(Element*)[elements objectAtIndex:sub];
                changepoint=[[changePoints objectAtIndex:sub]intValue];
                
                
            }
            
            index+=1;
        }
    
        [out appendString:[NSString stringWithFormat:@"y in < %@, inf > : %@\n\n", gfs.input.ys[sub], subElement]];
    
    
    return out;
}


-(double)error{
    
    double sumdx=0;
    double error=0;
    double da,db,dc,dx;
    int x,y;
    int j,index,changepoint,sub;

    GFS *gfs=((Element*)[elements objectAtIndex:0]).gfs;
    Element *subElement;

    index=0;
    changepoint=[[changePoints objectAtIndex:index]intValue];
    sub=0;
    subElement=(Element*)[elements objectAtIndex:sub];

    if ([[gfs.configuration objectForKey:@"3D"] isEqual:@YES]) {
        
        for (x=0; x<50; x++) {
            for (y=0; y<50; y++) {
                
                db=[gfs.input.xs[x] doubleValue];
                dc=[gfs.input.ys[y] doubleValue];
                
                [gfs setValueOf:@"x" value:db];
                [gfs setValueOf:@"y" value:dc];
                
                if (index>=changepoint) {
                    
                    sub+=1;
                    
                    subElement=(Element*)[elements objectAtIndex:sub];
                    changepoint=[[changePoints objectAtIndex:sub]intValue];
                    
                }
                
                da=[subElement eval];
                
                dx=[gfs.input.zs[x*y-x] doubleValue];
                
                sumdx+=fabs(da-dx);
                index+=1;
            }
            
        }
        return sumdx;
    }
    
    for (j=0; j<50; j++) {
        
        dx=[gfs.input.xs[j] doubleValue];
        
        [gfs setValueOf:@"x" value:dx];
        
        if (index>=changepoint) {
            
            sub+=1;
            
            subElement=(Element*)[elements objectAtIndex:sub];
            changepoint=[[changePoints objectAtIndex:sub]intValue];
            
        }
        
        da=[subElement eval];
        
        if ((da==NAN)||(da==-INFINITY)||(da==INFINITY))
            
            return NAN;
        
        db=[gfs.input.ys[j] doubleValue];
        
        sumdx+=fabs(da-db);
        index+=1;
    }
    return sumdx;
    
}

@end

@interface Element() {
    MersenneTwister *mersenetwister;
}

@end

@implementation Element

-(NSString*)description{
    return [NSString stringWithString:[_gfs teXStringA:&array[0] withB:&repairing[0]]];
}

-(double)eval{
    return [_gfs evalA:&array[0] withB:&repairing[0]];
}

-(double)error{
    return [_gfs errorA:&array[0] withB:&repairing[0]];
}

-(id)initWithSeed:(uint32_t)seed forGFS:(GFS*)fs{
    self = [super init];
    if (self) {
        _gfs=fs;
        mersenetwister=[[MersenneTwister alloc]initWithSeed:seed];
        
        array = (int *) malloc(sizeof(int) * [[_gfs.configuration objectForKey:@"ElementSize"]intValue]);
        repairing = (int *) malloc(sizeof(int) * [[_gfs.configuration objectForKey:@"ElementSize"]intValue]);
        
        
        for (int j=0;j<[[_gfs.configuration objectForKey:@"ElementSize"]intValue];j++) {
            
            array[j]=[mersenetwister randomUInt32From:0 to:_gfs.terminalsStartingIndex-1];
            
            
            repairing[j]=[mersenetwister randomUInt32From:_gfs.terminalsStartingIndex to:[_gfs.elements count]-1];
            
        }
        [self eval];
        
        name=[_gfs stringA:&array[0] withB:&repairing[0]];
        
    }
    return self;
}

-(id)initWithString:(NSString *)s andGFS:(GFS*)fs{
    self = [super init];
    if (self) {
        
        _gfs=fs;
        
        array = (int *) malloc(sizeof(int) * [[_gfs.configuration objectForKey:@"ElementSize"]intValue]);
        repairing = (int *) malloc(sizeof(int) * [[_gfs.configuration objectForKey:@"ElementSize"]intValue]);

        NSArray *lines = [NSArray arrayWithArray:  [s componentsSeparatedByString:@"\n"]];
    
        NSString *astr=[NSString stringWithString:[lines objectAtIndex:0]];
        NSString *bstr=[NSString stringWithString:[lines objectAtIndex:1]];

        NSArray *aarray= [NSArray arrayWithArray:  [astr componentsSeparatedByString:@","]];
        int ii=0;
        for (NSString *st in aarray) {
            if (ii==0)
                array[ii++]=[[st stringByReplacingOccurrencesOfString:@"[" withString:@""]intValue];
            else
                array[ii++]=[st intValue];
            
        }
        
        NSArray *barray=[NSArray arrayWithArray: [bstr componentsSeparatedByString:@","]];
        ii=0;
        for (NSString *st2 in barray) {
            if (ii==0)
                repairing[ii++]=[[st2 stringByReplacingOccurrencesOfString:@"[" withString:@""]intValue];
            else
                repairing[ii++]=[st2 intValue];
            
            if (ii==[[_gfs.configuration objectForKey:@"ElementSize"]intValue] )
                break;
        }
    
        [self eval];
        
        name=[_gfs stringA:&array[0] withB:&repairing[0]];
     
}
return self;
}

@end