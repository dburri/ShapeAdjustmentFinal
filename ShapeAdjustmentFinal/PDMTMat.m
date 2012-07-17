//
//  PDMTMat.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDMTMat.h"

@implementation PDMTMat

@synthesize T;

- (id)init 
{
    self = [super init];
    if (self) {
        NSLog(@"PDMTMat:init");
        T = malloc(9*sizeof(float));
        memset(&T[0], 0, 9*sizeof(float));
    }
    return self;
}

- (id)initWithEye
{
    self = [super init];
    if (self) {
        NSLog(@"PDMTMat:init");
        T = malloc(9*sizeof(float));
        memset(&T[0], 0, 9*sizeof(float));
        T[0] = 1;
        T[4] = 1;
        T[8] = 1;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"PDMTMat:dealloc");
    free(T);
}


- (PDMTMat*)multiply:(PDMTMat*)T2
{
    PDMTMat *newT = [[PDMTMat alloc] init];
    
    for(int i = 0; i < 3; ++i)
    {
        for(int j = 0; j < 3; ++j)
        {
            newT.T[i*3+j] = 0;
            for(int k = 0; k < 3; ++k)
            {
                newT.T[i*3+j] += T[i*3+k] * T2.T[k*3+j];
            }
        }
    }
    return newT;
}


// solution from:
// http://mathworld.wolfram.com/MatrixInverse.html

- (PDMTMat*)inverse
{
    PDMTMat *TInv = [[PDMTMat alloc] init];

    double det_1 = 
    T[0]*T[4]*T[8] -
    T[0]*T[5]*T[7] -
    T[1]*T[3]*T[8] +
    T[1]*T[5]*T[6] +
    T[2]*T[3]*T[7] -
    T[2]*T[4]*T[6];
    
    det_1 = 1/det_1;
    
    TInv.T[0] = det_1*(T[8]*T[4]-T[7]*T[5]);
    TInv.T[1] = det_1*(T[7]*T[2]-T[8]*T[1]);
    TInv.T[2] = det_1*(T[5]*T[1]-T[4]*T[2]);
    TInv.T[3] = det_1*(T[6]*T[5]-T[8]*T[3]);
    TInv.T[4] = det_1*(T[8]*T[0]-T[6]*T[2]);
    TInv.T[5] = det_1*(T[3]*T[2]-T[5]*T[0]);
    TInv.T[6] = det_1*(T[7]*T[3]-T[6]*T[4]);
    TInv.T[7] = det_1*(T[6]*T[1]-T[7]*T[0]);
    TInv.T[8] = det_1*(T[4]*T[0]-T[3]*T[1]);
    
    return TInv;
    
    
//    PDMTMat *TInv = [[PDMTMat alloc] init];
//    [self inverseMatf:T :3 :TInv.T];
//    return TInv;
}

@end
