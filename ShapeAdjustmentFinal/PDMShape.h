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

typedef struct {
    int component;
    int isVisible;
    int pointNr;
    int isConnected;
    int connectionTo;
} point_info_t;


@interface PDMPointsInfo : NSObject
- (id)init:(size_t)numP;
- (const point_info_t*)getPointInfo;
@end



@interface PDMShape : NSObject
{
    point_t *shape;
    size_t num_points;
    PDMPointsInfo *pointsInfo;
}

@property (nonatomic, readonly) point_t *shape;
@property (nonatomic, readonly) size_t num_points;
@property (nonatomic) PDMPointsInfo *pointsInfo;

- (id)initWithData:(PDMShape*)s;

- (void)loadShape:(NSString*)file;
- (void)loadPointInfo:(NSString*)file;

- (void)setNewShapeData:(PDMShape*)s;
- (void)setNewShapeData:(point_t*)points :(int)nPoints;

- (id)getCopy;

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
