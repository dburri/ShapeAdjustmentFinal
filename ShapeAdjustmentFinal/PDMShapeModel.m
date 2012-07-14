//
//  PDMShapeModel.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDMShapeModel.h"

@implementation PDMShapeModel

@synthesize meanShape;
@synthesize num_vecs;
@synthesize num_triangles;

- (id)init 
{
    self = [super init];
    if (self) {
        NSLog(@"PDMShapeModel:init");
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"PDMShapeModel:dealloc");
    meanShape = nil;
    free(eigVecs);
}


- (PDMShape*)createNewShapeWithParams:(NSArray*)b
{
    if([b count] != num_vecs) {
        NSLog(@"The number of parameters (%i) must match the number of vectors (%zu)! ", [b count], num_vecs);
        return nil;
    }
    
    
    PDMShape *shape = [[PDMShape alloc] initWithData:meanShape];
    
    
    float *params = malloc(num_vecs*sizeof(float));
    for(int i = 0; i < [b count]; ++i) {
        params[i] = [[b objectAtIndex:i] floatValue];
    }
    
    float *shapeData = shape.shape;
    
    int lda = num_vecs;
    int ldb = 1;
    int ldc = 1;
    
    float s = 1.0;
    
    cblas_sgemm(CblasRowMajor,
                CblasNoTrans,
                CblasNoTrans,
                num_points*3,     // num of rows in matrices A and C
                1,              // num of col in matrices B and C
                num_vecs,              // Num of col in matrix A; number of rows in matrix B.
                s,              // alpha
                eigVecs,          // matrix A
                lda,            // size of the first dimension of matrix A
                params,              // matrix B
                ldb,            // size of the first dimension of matrix B
                s,              // beta
                shapeData,       // matrix C
                ldc             // size of the first dimention of matrix C
                );
    

    free(params);
    return shape;
}



- (void)loadModel:(NSString*)fXM :(NSString*)fV :(NSString*)fD :(NSString*)fTRI
{
    NSLog(@"PDMShapeModel:loadModel");

    // load mean shape
    if(meanShape != nil)
    meanShape= nil;
    meanShape = [[PDMShape alloc] init];
    [meanShape loadShape:fXM];

    // load eigenvectors and eigenvalues
    [self loadEigVectors:fV];
    [self loadEigValues:fD];
    
    // load triangles
    [self loadTriangles:fTRI];

}


- (void)loadEigVectors:(NSString*)file
{
    //NSLog(@"PDMShapeModel:loadEigVectors");
    
    NSError* err;
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"csv"];
    NSString *dataStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    if(dataStr == nil) {
        NSLog(@"Error reading file at %@\n%@", path, [err localizedFailureReason]);
    }
    
    NSArray *rowArray = [dataStr componentsSeparatedByString:@"\n"];
    if([rowArray count] == 0) {
        NSLog(@"Could not load file with Eigenvectors! File is empty...");
        return;
    }
    NSArray *colArray = [[rowArray objectAtIndex:0] componentsSeparatedByString:@","];
    
    num_points = ([rowArray count]-1)/2;
    num_vecs = ([colArray count]);
    
    eigVecs = malloc(3*num_points*num_vecs*sizeof(float));
    if(eigVecs == NULL) {
        NSLog(@"Could not allocate memory to store eigenvectors!");
        return;
    }
    
    float *data_ptr = &eigVecs[0];
    for(int i = 0; i < num_points; ++i)
    {
        //NSLog(@"i = %i, difference = %i", i, data_ptr-&eigVecs[0]);
        NSArray *colXArray = [[rowArray objectAtIndex:i] componentsSeparatedByString:@","];
        NSArray *colYArray = [[rowArray objectAtIndex:i+num_points] componentsSeparatedByString:@","];
        
        // x-coordinates
        for(int j = 0; j < num_vecs; ++j) {
            *data_ptr++ = [[colXArray objectAtIndex:j] doubleValue];
        }
        
        // y-coordinates
        for(int j = 0; j < num_vecs; ++j) {
            *data_ptr++ = [[colYArray objectAtIndex:j] doubleValue];
        }
        
        // make then already homogeneous
        for(int j = 0; j < num_vecs; ++j) {
            *data_ptr++ = 0;
        }
    }
}

- (void)loadEigValues:(NSString*)file
{
    //NSLog(@"PDMShapeModel:loadEigVectors");
    
    NSError* err;
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"csv"];
    NSString *dataStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    if(dataStr == nil) {
        NSLog(@"Error reading file at %@\n%@", path, [err localizedFailureReason]);
    }
    
    NSArray *rowArray = [dataStr componentsSeparatedByString:@"\n"];
    if([rowArray count] == 0) {
        NSLog(@"Could not load file with Eigenvectors! File is empty...");
        return;
    }
 
    size_t num_values = ([rowArray count]-1);
    
    if(num_values != num_vecs) {
        NSLog(@"The number of eigenvectors (%zu) is not equal to the number of eigenvalues %zu!", num_vecs, num_values);
    }
    
    eigVals = malloc(3*num_vecs*sizeof(float));
    if(eigVals == NULL) {
        NSLog(@"Could not allocate memory to store eigenvalues!");
        return;
    }
    
    float *data_ptr = &eigVals[0];
    for(int i = 0; i < num_vecs; ++i)
    {
        *data_ptr++ = [[rowArray objectAtIndex:i] floatValue];
    }
    
    
//    for(int i = 0; i < 5; ++i) {
//        NSLog(@"%i: %f, ", i, eigVals[i]);
//    }
    
    
}


- (void)loadTriangles:(NSString*)file
{
    //NSLog(@"PDMShapeModel:loadEigVectors");
    
    NSError* err;
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"csv"];
    NSString *dataStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    if(dataStr == nil) {
        NSLog(@"Error reading file at %@\n%@", path, [err localizedFailureReason]);
    }
    
    NSArray *rowArray = [dataStr componentsSeparatedByString:@"\n"];
    if([rowArray count] == 0) {
        NSLog(@"Could not load file with Eigenvectors! File is empty...");
        return;
    }

    num_triangles = [rowArray count]-1;
    
    triangles = malloc(num_triangles*sizeof(triangle_t));
    if(triangles == NULL) {
        NSLog(@"Could not allocate memory to store triangles!");
    }
    
    for(int i = 0; i < num_triangles; ++i)
    {
        NSArray *colArray = [[rowArray objectAtIndex:i] componentsSeparatedByString:@","];
        for(int j = 0; j < 3; ++j) {
            triangles[i].tri[j] = [[colArray objectAtIndex:j] intValue];
        }
    }
    
    
    for(int i = 0; i < 5; ++i) {
        NSLog(@"[%i, %i, %i]", triangles[i].tri[0], triangles[i].tri[1], triangles[i].tri[2]);
    }
    
    
}


@end
