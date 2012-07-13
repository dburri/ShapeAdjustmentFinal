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


- (PDMShape*)createNewShape:(NSArray*)b
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

    // load eigenvectors
    [self loadEigVectors:fV];

}


- (void)loadEigVectors:(NSString*)file
{
    NSLog(@"PDMShapeModel:loadEigVectors");
    
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
    num_vecs = ([colArray count]-1);
    NSLog(@"Number of points = %zu, number of vectors = %zu", num_points, num_vecs);
    eigVecs = malloc(3*num_points*num_vecs*sizeof(float));
    if(eigVecs == NULL) {
        NSLog(@"Could not allocate memory to store eigenvectors!");
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
    
    
    //for(int i = 0; i < 200; ++i) {
    //    NSLog(@"%i: %f, ", i, eigVecs[i]);
    //}
    
    
}

@end
