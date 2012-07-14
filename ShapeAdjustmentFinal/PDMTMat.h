//
//  PDMTMat.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface PDMTMat : NSObject
{
    float *T;
}
@property float *T;


- (id)initWithEye;

- (PDMTMat*)multiply:(PDMTMat*)T2;
- (PDMTMat*)inverse;


- (void)inverseMatd:(double*)A:(long)N;
- (void)inverseMatf:(const float*)A:(long)N:(float*)B;

@end

