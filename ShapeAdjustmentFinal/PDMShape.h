//
//  PDMShape.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>

typedef struct TMat {
    float *a1, *a2, *a3, *a4, *a5, *a6;
} TMat;

@interface PDMShape : NSObject <NSCopying>
{
    float *shape;
    size_t num_points;
}

@property (nonatomic, readonly) float *shape;
@property (nonatomic, readonly) size_t num_points;

- (id)initWithData:(PDMShape*)s;

- (void)loadShape:(NSString*)file;
- (id)getCopy;
- (void)setNewShapeData:(PDMShape*)s;

- (CGRect)getMinBoundingBox;
- (CGPoint)getCenterOfGravity;

- (void)scale:(float)s;
- (void)rotate:(float)a;
- (void)translate:(float)tx:(float)ty;

- (void)transformAffine:(float*)T;
- (void)transformAffineMat:(TMat)T;

@end
