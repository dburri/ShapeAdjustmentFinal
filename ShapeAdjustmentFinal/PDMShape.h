//
//  PDMShape.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import "PDMTMat.h"

typedef struct {
    float pos[3];
} point_t;


@interface PDMShape : NSObject
{
    point_t *shape;
    size_t num_points;
}

@property (nonatomic, readonly) point_t *shape;
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
- (void)transformAffineMat:(PDMTMat*)T;
- (void)transformIntoTangentSpaceTo:(PDMShape*)s;

- (PDMTMat*)findAlignTransformationTo:(PDMShape*)s;
- (void)alignShapeTo:(PDMShape*)s;

- (void)printShapeValues;

@end
