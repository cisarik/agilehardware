////  GFS.h //  Math general function set implementation
////
////  @interface Element
////  @interface IN
////
////  Copyright (c) 2013 Michal Cisarik. All rights reserved.        //

#import <UIKit/UIKit.h>
#import "MersenneTwister.h" // Random generator - thread-safe

// ================== // ERRORS AND EXCEPTIONS // ================== //
@interface NotEnoughTerminalsInRepairingArray : NSException
@end

@interface UnexpectedBehavior : NSException
@end


// ========================= // TYPES // =========================== //
typedef double (^func2)(double,double);
typedef double (^func1)(double);
typedef double (^func0)(void);

typedef double (^input2D)(double);
typedef double (^input3D)(double,double);

// ====================== // PROTOCOLS // ========================== //
@protocol GFS2args <NSObject>
-(double) eval:(double)parameter1 and:(double)parameter2;
@end

@protocol GFS1args <NSObject>
-(double) eval:(double)a;
@end

@protocol GFS0args <NSObject>
-(double) eval;
@end

@protocol GFSvariable <NSObject>
@end

@protocol GFSconstant <NSObject>
@end

@protocol GFSreinforced <NSObject>
-(double) eval;
@end

@interface GFSelement : NSObject {
    NSString *name;
    NSString *nametex;
}
@property (retain) NSString* name;
@property (retain) NSString* nametex;
@end



// ====================== // INTERFACE // ====================== IN
@interface IN : NSObject {
    
    NSMutableArray *xs;
    NSMutableArray *ys;
    NSMutableArray *zs;
    double min;
    double max;
    uint count;
}

@property (nonatomic, copy) NSMutableArray *xs;
@property (nonatomic, copy) NSMutableArray *ys;
@property (nonatomic, copy) NSMutableArray *zs;

@property (nonatomic) double min;
@property (nonatomic) double max;
@property (nonatomic) uint count;

-(id)initWithXs:(NSMutableArray *)x Ys:(NSMutableArray *)y Zs:(NSMutableArray *)z min:(double)i max:(double)mx andCount:(uint)c;


+(NSMutableArray*) ekvidistantDoublesCount:(int)count min:(double)m max:(double)mx;
@end



// ====================== // INTERFACE // ====================== GFS
@interface GFS : NSObject {
    
    NSMutableArray* elements;   // Array of all elements from General Funtion Set = set of functors
    
    // For functional programming it's necessary to implement endofunctor = monad
    // so that I'ts possible to include state (or context) of function itself (number of  parameters...)
    // this can help to work with GFS (create subsets for example) and 'watch' the evaluation
    
    uint64_t bin;               // Binary representation of the general funtion set
    
    int functions;              // How many functions (GSF1 and GFS2) there are in the general function set
    int constants;
    int reinforcementStartingIndex;
    int terminalsStartingIndex;
    int size;
    int xpos;
    int bit1;
    int bit2;
    int bit3;
    int bit4;
    int bit5;
    int bit6;
    int bit7;
    int bit8;
    int bit9;
    int bit10;
    int bit11;
    int bit12;
    int bit13;
    int bit14;
    int bit15;
    int bit16;
    int bit17;
    int bit18;
    int bit19;
    int bit20;
    int bit21;
    int bit22;
    int bit23;
    int bit24;
    int bit25;
    int bit26;
    int bit27;
    int bit28;
    int bit29;
    int bit30;
    int bit31;
    
    double bestReinforcementFitness;
}

@property (retain) NSMutableArray* elements;
@property IN *input;
@property NSMutableDictionary *configuration;

@property int functions;
@property int constants;
@property int size;
@property int reinforcementStartingIndex;
@property int xpos;
@property BOOL variableNameInsteadOfValue;
@property int terminalsStartingIndex;

@property uint64_t bin;

@property double bestReinforcementFitness;


-(id)initWithGFSbin:(uint64_t)b configuration:(NSMutableDictionary *)cfg input:(IN*)data parentGFSbin:(uint64_t)parent andSeed:(uint32_t)seed;

-(void)force:(uint64_t)b;

-(NSString *)toStringRecursive:(int[])array at:(int) i last:(int*)last max:

(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger;

-(double)evaluateRepairingRecursive:(int[])array at:(int) i last:(int*)last max:(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger depth:(int*)depth;

-(double)evaluateRecursive:(int[])array at:(int) i last:(int*)last max:(int*)len repairing:(int [])repairing lastrepairing:(int*)lastrepairing lastbigger:(int*)lastbigger depth:(int*)depth;

-(void)saveStateAt:(int) i last:(int*) last max:(int*) len repairing:(int[]) repairing lastrepairing:(int*) lastrepairing lastbigger:(int*) lastbigger depth:(int*) depth;

-(void)restoreState;

-(void)setValueOf:(NSString*)var value:(double)val;

-(double)evalA:(int[])_a withB:(int[])_b;

-(double)errorA:(int[])_a withB:(int[])_b;

-(NSString *)stringA:(int[])_a withB:(int[])_b;

-(NSString *)describeA:(int[])_a withB:(int[])_b;

-(void)randomize;

-(void)null;

-(NSString *)description;
-(NSString*)reinforcementDescription;

@end

// ====================== // INTERFACE // ====================== Element
@interface Elements : NSObject {
@public
    NSArray *elements;
    NSArray *changePoints;
}
-(id)initWithElements:(NSArray*)elems andChangePoints:(NSArray*)points;
-(NSString*)description;
@end

// ====================== // INTERFACE // ====================== Element
@interface Element : GFSelement < GFSreinforced > {
@public
    int* array;
    int* repairing;
}
@property GFS *gfs;
-(id)initWithSeed:(uint32_t)seed forGFS:(GFS*)fs;
-(id)initWithString:(NSString *)s andGFS:(GFS*)fs;
-(double)eval;
-(double)error;
-(NSString*)description;
@end

// ====================== // INTERFACE // ====================== GFSs
@interface GFSs : NSObject
-(id) initWithCommand:(NSString*)command GFSs:(int)count;
@property NSMutableArray *subGFSs;
@end

@interface OUT : NSObject {
    GFS *gfs;
    NSMutableDictionary *configuration;
    NSMutableDictionary *history;
    NSMutableArray *elements;
    
}
@property (readwrite,retain) GFS* gfs;
@property (readwrite,retain) NSMutableDictionary *configuration;
@property (readwrite) NSMutableDictionary *history;
@property (readwrite) NSMutableArray *elements;

-(id)initWithConfiguration:(NSDictionary*) conf andGFS:(GFS*)gfs;
-(BOOL)insertFitness:(double)i string:(NSString*)s ofMethod:(NSString*)m;
-(NSString*)description;
-(NSString*)bestDescription;

@end


@interface GFSvar : GFSelement <GFSvariable>{
    double* variable;
}
-(id)initWith:(double *)n name:(NSString *)s andTex:(NSString*)tex;
-(double)value;
@end

@interface GFSconst : GFSelement <GFSconstant>{
    double constant;
}
-(id)initWith:(double)n;
-(double)value;
@end

@interface GFS0 : GFSelement <GFS0args>{
    func0 function;
}
-(id)initWith:(func0) f name:(NSString *)n andTex:(NSString*)tex;
-(double) eval;
@end

@interface GFS1 : GFSelement <GFS1args>{
    func1 function;
}
-(id)initWith:(func1) f name:(NSString *)n andTex:(NSString*)tex;
-(double) eval:(double)parameter1;
@end

@interface GFS2 : GFSelement <GFS2args>{
    func2 function;
}
- (id)initWith:(func2) f name:(NSString *)n andTex:(NSString*)tex;
-(double) eval:(double)parameter1 and:(double)parameter2;
@end




