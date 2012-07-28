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
- (id)initWithSRT:(float)s :(float)r :(float)tx :(float)ty;
- (id)initWithScale:(float)s;
- (id)initWithRotate:(float)a;
- (id)initWithTranslate:(float)tx :(float)ty;
- (id)initWithMat:(PDMTMat*)mat;

- (PDMTMat*)multiply:(PDMTMat*)T2;
- (PDMTMat*)multiplyPreservingTranslation:(PDMTMat*)T2;

- (PDMTMat*)inverse;

- (void)printMat;

@end

