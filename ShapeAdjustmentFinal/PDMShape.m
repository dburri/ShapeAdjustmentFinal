//
//  PDMShape.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDMShape.h"

@implementation PDMShape

@synthesize shape;
@synthesize num_points;

- (id)init {
    self = [super init];
    if (self) {
        shape = NULL;
        NSLog(@"PDMShape:init");
    }
    return self;
}

- (id)initWithData:(PDMShape*)s
{
    self = [super init];
    if (self) {
        NSLog(@"PDMShape:initWithData");
        shape = NULL;
        [self setNewShapeData:s];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"PDMShape:dealloc");
    free(shape);
}


// copy the shape
-(id) getCopy
{
    return [[PDMShape alloc] initWithData:self];
}

- (void)setNewShapeData:(PDMShape *)s
{
    NSLog(@"PDMShape:setNewShapeData");
    
    if(!shape)
        shape = malloc(3*s.num_points*sizeof(float));
    
    num_points = s.num_points;
    for(int i = 0; i < 3*num_points; ++i)
        shape[i] = s.shape[i];
}


- (void)loadShape:(NSString*)file {
    
    NSLog(@"PDMShape:loadShape");
    
    NSError* err;
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"csv"];
    NSString *dataStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    if(dataStr == nil) {
        NSLog(@"Error reading file at %@\n%@", path, [err localizedFailureReason]);
    }
    NSArray *dataArray = [dataStr componentsSeparatedByString:@"\n"];
    
    num_points = ([dataArray count]-1)/2;
    size_t num_bytes = 3*num_points*sizeof(float);      // store as homogeneous
    shape = malloc(num_bytes);
    float *shape_ptr = &shape[0];
    for(int i = 0; i < num_points; ++i)
    {
        *shape_ptr++ = [[dataArray objectAtIndex:i] doubleValue];
        *shape_ptr++ = [[dataArray objectAtIndex:i+num_points] doubleValue];
        *shape_ptr++ = 1.0;
    }
}


// -----------------------------------------------
// INFORMATION AND STATISTICS

- (CGRect)getMinBoundingBox
{
    float xmin = INFINITY;
    float xmax = -INFINITY;
    float ymin = INFINITY;
    float ymax = -INFINITY;
    
    float *shape_ptr = &shape[0];
    float x, y;
    for(int i = 0; i < num_points; ++i)
    {
        x = *shape_ptr++;
        y = *shape_ptr++;
        shape_ptr++;
        
        if(x < xmin) xmin = x;
        if(x > xmax) xmax = x;
        if(y < ymin) ymin = y;
        if(y > ymax) ymax = y;
    }
    return CGRectMake(xmin, ymin, xmax-xmin, ymax-ymin);
}

- (CGPoint)getCenterOfGravity
{
    float x = 0;
    float y = 0;
    float *shape_ptr = &shape[0];
    for(int i = 0; i < num_points; ++i)
    {
        x += *shape_ptr++;
        y += *shape_ptr++;
        shape_ptr++;
    }
    return CGPointMake(x/num_points, y/num_points);
}



// -----------------------------------------------
// TRANSFORMATION STUFF

- (void)scale:(float)s
{
    float *shape_ptr = &shape[0];
    for(int i = 0; i < num_points; ++i)
    {
        *shape_ptr++ *= s;
        *shape_ptr++ *= s;
        shape_ptr++;
    }
}

- (void)rotate:(float)a
{
    float T[9];
    T[0] = cosf(a);
    T[1] = sinf(a);
    T[2] = 0;
    T[3] = -sinf(a);
    T[4] = cosf(a);
    T[5] = 0;
    T[6] = 0;
    T[7] = 0;
    T[8] = 1;
    [self transformAffine:&T[0]];
}

- (void)translate:(float)tx:(float)ty
{
    float *shape_ptr = &shape[0];
    for(int i = 0; i < num_points; ++i)
    {
        *shape_ptr++ += tx;
        *shape_ptr++ += ty;
        shape_ptr++;
    }
}

- (void)transformAffine:(float*)T
{
    int lda = 3;
    int ldt = 3;
    int ldb = 3;
    
    float scale = 1.0;
    
    cblas_sgemm(CblasRowMajor,
                CblasNoTrans,
                CblasNoTrans,
                num_points,     // num of rows in matrices A and C
                3,              // num of col in matrices B and C
                3,              // Num of col in matrix A; number of rows in matrix B.
                scale,          // alpha
                shape,          // matrix A
                lda,            // size of the first dimension of matrix A
                T,              // matrix B
                ldt,            // size of the first dimension of matrix B
                scale,          // beta
                shape,          // matrix C
                ldb             // size of the first dimention of matrix C
                );
}

- (void)transformAffineMat:(TMat)T
{
    
}

@end
