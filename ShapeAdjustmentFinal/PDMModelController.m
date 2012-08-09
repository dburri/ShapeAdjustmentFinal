//
//  ControlMain.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlMain.h"

@implementation ControlMain

@synthesize shapeModel;
@synthesize shapeParams;
@synthesize faceShape;
@synthesize faceImage;


static int theCount = 0;

+ (int) count { return theCount; }


- (id)init {
    self = [super init];
    if (self) {
        count = theCount++;
        shapeParams = [[PDMShapeParameter alloc] init];
        NSLog(@"ControlMain:init:%i", count);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ControlMain:dealloc:%i", count);
}


- (void)loadShapeModel:(NSString*)fXM :(NSString*)fV :(NSString*)fD :(NSString*)fTRI
{
    NSLog(@"LOADING SHAPE MODEL!!!");
    shapeModel = [[PDMShapeModel alloc] init];
    [shapeModel loadModel:fXM :fV :fD :fTRI];
    
    NSLog(@"INITIALIZE PARAM VECTOR TO SIZE %zu", shapeModel.num_vecs);
    shapeParams = [[PDMShapeParameter alloc] initWithSize:shapeModel.num_vecs];
    NSLog(@"SIZE =  %i", [shapeParams.b count]);
}

- (void)newFaceWithImage:(UIImage*)image
{
    NSLog(@"ControlMain:newFaceWithImage");
    faceImage = image;
    faceShape = [shapeModel.meanShape getCopy];
    
    // scale the shape to half of the image size
    CGRect box = [faceShape getMinBoundingBox];
    float s1 = image.size.width/box.size.width;
    float s2 = image.size.height/box.size.height;
    float s = MIN(s1, s2)/2;
    
    shapeParams.T = [[PDMTMat alloc] initWithSRT:s :0 :image.size.height/2 :image.size.width/2];
    [faceShape transformAffineMat:shapeParams.T];
    

    // ------------------------------------------------------
    // perform test by matching a new shape to the existing shape
//    PDMShape *tmpShape = [shapeModel.meanShape getCopy];
//    PDMTMat *T = [tmpShape findAlignTransformationTo:face.shape];
//    [tmpShape transformAffineMat:T];
//    face.shape  = tmpShape;
    
    
    // ------------------------------------------------------
    // perform test by modifying modes
//    NSMutableArray *b = [[NSMutableArray alloc] init];
//    for(int i = 0; i < shapeModel.num_vecs; ++i) {
//        [b addObject:[NSNumber numberWithFloat:0]];
//    }
//    [b replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:0.3]];
//    
//    PDMShape *newShape = [shapeModel createNewShape:b];
//    TMatch T = [newShape alignShapeTo:face.shape];
//    [newShape transformAffineMatch:T];
//    face.shape  = newShape;
    
    // ------------------------------------------------------
    // perform test by modifying modes
//    PDMShapeParameter *params = [shapeModel findBestMatchingParams:face.shape];
//    PDMShape *tmpShape = [shapeModel createNewShapeWithAllParams:params];
//    face.shape = tmpShape;
    
}


- (void)updateT:(PDMTMat*)T
{
    shapeParams.T = T;
    faceShape = [shapeModel createNewShapeWithAllParams:shapeParams];
}

- (void)updateb:(NSArray*)b
{
    assert([b count] == [shapeParams.b count]);
    [shapeParams.b setArray:b];
    faceShape = [shapeModel createNewShapeWithAllParams:shapeParams];
}


- (void)update:(PDMShapeParameter*)param
{
    assert([param.b count] == [shapeParams.b count]);
    [shapeParams.b setArray:param.b];
    shapeParams.T = param.T;
    faceShape = [shapeModel createNewShapeWithAllParams:shapeParams];
}

- (void)resetBParam
{
    for(int i = 0; i < [shapeParams.b count]; ++i) {
        [shapeParams.b replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:0]];
    }
    faceShape = [shapeModel createNewShapeWithAllParams:shapeParams];
}


@end
