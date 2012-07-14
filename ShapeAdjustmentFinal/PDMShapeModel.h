//
//  PDMShapeModel.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PDMShape.h"
#import "PDMShapeParameter.h"

typedef struct triangle_t {
    int tri[3];
} triangle_t;

@interface PDMShapeModel : NSObject
{
    PDMShape *meanShape;
    
    size_t num_vecs;
    size_t num_points;
    float *eigVecs;
    float *eigVals;
    
    triangle_t *triangles;
    size_t num_triangles;
}

@property (retain) PDMShape *meanShape;
@property size_t num_vecs;
@property size_t num_triangles;


- (void)loadModel:(NSString*)fXM :(NSString*)fV :(NSString*)fD :(NSString*)fTRI;
- (PDMShape*)createNewShapeWithParams:(NSArray*)b;
- (PDMShape*)createNewShapeWithAllParams:(PDMShapeParameter*)params;
- (PDMShapeParameter*)findBestMatchingParams:(PDMShape*)s;

- (void)loadEigVectors:(NSString*)file;
- (void)loadEigValues:(NSString*)file;
- (void)loadTriangles:(NSString*)file;

- (void)printEigVectors;
- (void)printShapeValues:(PDMShape*)s;

@end
