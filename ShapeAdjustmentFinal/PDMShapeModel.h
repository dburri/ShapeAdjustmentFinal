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
#import "PDMTriangle.h"

typedef struct triangle_t {
    int index[3];
} triangle_t;

@interface PDMShapeModel : NSObject
{
    PDMShape *meanShape;
    
    size_t num_vecs;
    size_t num_points;
    float *eigVecs;
    float *eigVals;
    
    NSArray *triangles;
}

@property (retain) PDMShape *meanShape;
@property (retain) NSArray *triangles;
@property size_t num_vecs;


- (void)loadModel:(NSString*)fXM :(NSString*)fV :(NSString*)fD :(NSString*)fTRI;
- (PDMShape*)createNewShapeWithParams:(NSArray*)b;
- (PDMShape*)createNewShapeWithAllParams:(PDMShapeParameter*)params;
- (PDMShapeParameter*)applyConstraintsToParams:(PDMShapeParameter*)params;
- (PDMShapeParameter*)findBestMatchingParams:(PDMShape*)s;

- (NSArray*)getTriangles;

- (void)loadEigVectors:(NSString*)file;
- (void)loadEigValues:(NSString*)file;
- (void)loadTriangles:(NSString*)file;

- (void)printEigVectors;
- (void)printTriangles;

@end
