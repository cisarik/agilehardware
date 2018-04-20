//
//  ElementScene.m
//  AgileHardware
//
//  Created by Michal Cisarik on 6/17/15.
//  Copyright (c) 2015 cisary solutions. All rights reserved.
//

#import "ElementScene.h"
#import "Loader.h"

@interface ElementScene() {
    
    NSNumber *gridSize;
    
    CGFloat capsuleRadius;
    CGFloat capsuleHeight;
    
    CGFloat hue;
    
    UIColor *color;
    
    float z;
    float x;
    float y;
}

@end

@implementation ElementScene

- (id)initWithLoader:(Loader*)loader;
{
    self = [super init];
    if (self) {
        
        gridSize=@50;//[conf objectForKey:@"GridSize"];
        capsuleRadius=1.0/(CGFloat)[gridSize integerValue];
        capsuleHeight=capsuleRadius * 4.0;
        
        z=((-1*(float)[gridSize integerValue]+1) * (float)capsuleRadius);
        
        for (int row=0; row<[gridSize integerValue];row++){
            
            x=((-1*(float)[gridSize integerValue]+1) * (float)capsuleRadius);
            
            for (int column=0; column<[gridSize integerValue]; column++) {
                //let capsule = SCNCapsule(capRadius: capsuleRadius, height: capsuleHeight)
                SCNSphere *capsule=[SCNSphere sphereWithRadius:capsuleRadius];
                
                //capsule.cornerRadius = 0.01
                // Make the plane visible from both sides
                //capsule.firstMaterial?.doubleSided = true
                
                capsule.firstMaterial.doubleSided=@YES;
                
                hue=fabsf(x*y);
                
                color=[UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
                
                capsule.firstMaterial.diffuse.contents = color;
                
                SCNNode *capsuleNode=[SCNNode nodeWithGeometry:capsule];
                
                [self.rootNode addChildNode:capsuleNode];
                
                capsuleNode.position = SCNVector3Make(x, 0.0, z);
                
                y=(x*x);// TODO!!!
                
                SCNAction *moveUp = [SCNAction moveByX:0 y:y z:0 duration:1.0];
                SCNAction *moveDown = [SCNAction moveByX:0 y:-y z:0 duration:1.0];
                
                SCNAction *sequence= [SCNAction sequence:@[moveUp,moveDown]];
                SCNAction *repeatedSequence = [SCNAction repeatActionForever:sequence];
                
                [capsuleNode runAction:repeatedSequence];
                x+= 2.0 * (float)capsuleRadius;
            }
            z+= 2.0 *(float)capsuleRadius;
        }
    }
    return self;
}


@end
