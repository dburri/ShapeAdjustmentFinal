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
@synthesize triangles;
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
    int i = 0;
    for (id val in b) {
        params[i] = [val floatValue];
        ++i;
    }
    
    float *shapeData = &shape.shape[0].pos[0];
    
    int lda = num_vecs;
    int ldb = 1;
    int ldc = 1;
    
    float s = 1.0;
    
    cblas_sgemm(CblasRowMajor,
                CblasNoTrans,
                CblasNoTrans,
                num_points*3,       // num of rows in matrices A and C
                1,                  // num of col in matrices B and C
                num_vecs,           // Num of col in matrix A; number of rows in matrix B.
                s,                  // alpha
                eigVecs,            // matrix A
                lda,                // size of the first dimension of matrix A
                params,             // matrix B
                ldb,                // size of the first dimension of matrix B
                s,                  // beta
                shapeData,          // matrix C
                ldc                 // size of the first dimention of matrix C
                );
    

    free(params);
    return shape;
}


- (PDMShape*)createNewShapeWithAllParams:(PDMShapeParameter*)params
{
    PDMShape *s = [self createNewShapeWithParams:params.b];
    //PDMShape *s = [meanShape getCopy];
    [s transformAffineMat:params.T];
    return s;
}



/**
 Find the best match
 */
- (PDMShapeParameter*)findBestMatchingParams:(PDMShape*)s
{
    //NSLog(@"FIND THE BEST MATCHIG PARAMS...");
    
    PDMShapeParameter *params = [[PDMShapeParameter alloc] initWithSize:num_vecs];
    
    float *bParams = malloc(num_vecs*sizeof(float));
    float *difference = malloc(num_points*3*sizeof(float));
    
    
    for(int k = 0; k < 2; ++k)
    {
        PDMShape *tmpShape = [self createNewShapeWithParams:params.b];
    
        // project Y into the model coordinate frame
        PDMShape *s2 = [s getCopy];
        params.T = [tmpShape findAlignTransformationTo:s];
        PDMTMat *TInv = [params.T inverse];
        [s2 transformAffineMat:TInv];
        
        // project y into the tangent space to x
        [s2 transformIntoTangentSpaceTo:meanShape];
        
        // update model parameters
        float *data_ptr1 = &(meanShape.shape[0].pos[0]);
        float *data_ptr2 = &(s2.shape[0].pos[0]);
        float *data_ptr3 = &difference[0];
        for(int i = 0; i < num_points; ++i)
        {
            *data_ptr3++ = ((*data_ptr2++) - (*data_ptr1++));
            *data_ptr3++ = ((*data_ptr2++) - (*data_ptr1++));
            *data_ptr3++ = 0;
            
            data_ptr1++;
            data_ptr2++;
        }
        
        
        memset(bParams, 0, num_vecs*sizeof(float));
        
//        NSMutableString *text = [[NSMutableString alloc] init];
//        [text appendFormat:@"\nbParams = ["];
//        for(int i = 0; i < num_vecs; ++i) {
//            [text appendFormat:@"%f, ", bParams[i]];
//        }
//        [text appendFormat:@"]\n"];
//        NSLog(@"%@", text);
//        
//        NSMutableString *text2 = [[NSMutableString alloc] init];
//        [text2 appendFormat:@"\ndifference = "];
//        for(int i = 0; i < 3*num_points; i+=3) {
//            [text2 appendFormat:@"[%f, %f, %f] ", difference[i+0], difference[i+1], difference[i+2]];
//        }
//        [text2 appendFormat:@"]\n"];
//        NSLog(@"%@", text2);
        
        
        
        int lda = num_vecs;
        int ldb = 1;
        int ldc = 1;
        
        float scale = 1.0;

        cblas_sgemm(CblasRowMajor,
                    CblasTrans,
                    CblasNoTrans,
                    num_vecs,       // num of rows in matrices A and C
                    1,                  // num of col in matrices B and C
                    3*num_points,           // Num of col in matrix A; number of rows in matrix B.
                    scale,                  // alpha
                    eigVecs,            // matrix A
                    lda,                // size of the first dimension of matrix A
                    difference,             // matrix B
                    ldb,                // size of the first dimension of matrix B
                    scale,                  // beta
                    bParams,          // matrix C
                    ldc                 // size of the first dimention of matrix C
                    );
        
        
        for(int i = 0; i < num_vecs; ++i) {
            [params.b replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bParams[i]]];
        }
    }
    
    free(bParams);
    free(difference);
    
    return params;
}


- (PDMShapeParameter*)applyConstraintsToParamsEllipse:(PDMShapeParameter*)params :(float)limit
{
    float dmax = 500;
    float dm = 0;
    float bval = 0;
    
    for(int i = 0; i < num_vecs; ++i)
    {
        bval = [[params.b objectAtIndex:i] floatValue];
        dm += (bval*bval/eigVals[i]);
    }
    
    if(dm > dmax)
    {
        for(int i = 0; i < num_vecs; ++i)
        {
            bval = [[params.b objectAtIndex:i] floatValue];
            bval = bval * sqrt(dmax)/sqrt(dm);
            [params.b replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:bval]];
        }
    }
    return params;
}


- (PDMShapeParameter*)applyConstraintsToParamsCube:(PDMShapeParameter*)params :(float)limit
{
    float bval = 0;
    
    for(int i = 0; i < num_vecs; ++i)
    {
        bval = [[params.b objectAtIndex:i] floatValue];
        float maxVal = limit*eigVals[i];
        float sign = (bval >= 0 ? 1 : -1);
        
        //NSLog(@"b[%i] = %f, max = %f", i, bval, maxVal);
        
        if( maxVal < fabs(bval) ) {
            [params.b replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:maxVal*sign]];
        }
        
        
    }
    return params;
}


// -----------------------------------------------
// FILE HANDLING

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
    
    if(eigVecs) {
        free(eigVecs);
    }
    
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
    
    if(eigVals) {
        free(eigVals);
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

    int num_triangles = [rowArray count]-1;
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < num_triangles; ++i)
    {
        NSArray *colArray = [[rowArray objectAtIndex:i] componentsSeparatedByString:@","];
        PDMTriangle *triangle = [[PDMTriangle alloc] init];
        for(int j = 0; j < 3; ++j) {
            triangle.index[j] = [[colArray objectAtIndex:j] intValue] - 1;
        }
        [tmpArray addObject:triangle]; 
    }
    
    triangles = tmpArray;
}


- (void)printEigVectors
{
    // print vectors
    for(int i = 0; i < num_vecs; ++i)
    {
        NSMutableString *tmp = [[NSMutableString alloc] init];
        [tmp appendFormat:@"V%i = [", i];
        for(int j = 0; j < num_points*3; ++j)
        {
            [tmp appendFormat:@"%f, ", eigVecs[i+j*num_vecs]];
        }
        [tmp appendFormat:@"]"];
        NSLog(@"%@", tmp);
    }
}

- (void)printTriangles
{
    // print vectors
    NSMutableString *tmp = [[NSMutableString alloc] init];
    for(int i = 0; i < [triangles count]; ++i)
    {
        [tmp appendFormat:@"TRI %i = [", i];
        for(int j = 0; j < 3; ++j)
        {
            PDMTriangle *triangle = [triangles objectAtIndex:i];
            [tmp appendFormat:@"%i, ", triangle.index[j]];
        }
        [tmp appendFormat:@"]\n"];
    }
    NSLog(@"\n\n%@\n\n", tmp);
}

@end
