//
//  PDMShape.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#undef DEBUG

#import "PDMShape.h"
#include <vector>

using namespace std;

// ******************************************************
// PDMPOINTINFO IMPLEMENTATION
// ******************************************************

@interface PDMPointsInfo() {
    vector<point_info_t> pointInfo;
}
@end

@implementation PDMPointsInfo

- (id)init:(size_t)numP {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (const point_info_t*)getPointInfo
{
    return &pointInfo[0];
}


- (void)loadPointsInfo:(NSString*)file
{
    NSLog(@"LOAD POINT INFORMARION....");
    
    NSError* err;
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"csv"];
    NSString *dataStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    if(dataStr == nil) {
        NSLog(@"Error reading file at %@\n%@", path, [err localizedFailureReason]);
    }
    NSArray *dataArray = [dataStr componentsSeparatedByString:@"\n"];
    
    size_t length = [dataArray count]-2;
    pointInfo.assign(length, point_info_t());
    
    for (int i = 0; i < length; ++i)
    {
        NSArray *colArray = [[dataArray objectAtIndex:i+1] componentsSeparatedByString:@","];
        
        pointInfo[i].component = [[colArray objectAtIndex:0] intValue];
        pointInfo[i].isVisible = [[colArray objectAtIndex:1] intValue];
        pointInfo[i].pointNr = [[colArray objectAtIndex:2] intValue];
        pointInfo[i].isConnected = [[colArray objectAtIndex:3] intValue];
        pointInfo[i].connectionTo = [[colArray objectAtIndex:4] intValue];
    }
}

@end



// ******************************************************
// PDMSHAPE IMPLEMENTATION
// ******************************************************

@implementation PDMShape

@synthesize shape;
@synthesize num_points;
@synthesize pointsInfo;

- (id)init {
    self = [super init];
    if (self) {
        num_points = 0;
        shape = NULL;
        pointsInfo = [[PDMPointsInfo alloc] init];
    }
    return self;
}

- (id)initWithData:(PDMShape*)s
{
    self = [self init];
    if (self) {
        [self setNewShapeData:s];
    }
    return self;
}

- (void)dealloc {
    #ifdef DEBUG
    NSLog(@"PDMShape:dealloc");
    #endif
    free(shape);
}


// copy the shape
-(id) getCopy
{
    return [[PDMShape alloc] initWithData:self];
}

- (void)setNewShapeData:(PDMShape *)s
{

    // deep copy of the shape data
    if(shape) {
        free(shape);
    }
    shape = (point_t*)malloc(s.num_points*sizeof(point_t));
    
    num_points = s.num_points;
    float *ptr_src = &(s.shape[0].pos[0]);
    float *ptr_dst = &(shape[0].pos[0]);
    for(int i = 0; i < num_points*3; ++i) {
        *ptr_dst++ = *ptr_src++;
    }
    
    // copy reference to its info
    pointsInfo = s.pointsInfo;
}


- (void)setNewShapeData:(point_t*)points :(int)nPoints
{
    //NSLog(@"PDMShape:setNewShapeData");
    
    if(shape) {
        free(shape);
    }
    
    shape = points;
    num_points = nPoints;
}



// -----------------------------------------------
// INFORMATION AND STATISTICS

- (CGRect)getMinBoundingBox
{
    float xmin = INFINITY;
    float xmax = -INFINITY;
    float ymin = INFINITY;
    float ymax = -INFINITY;
    
    float *shape_ptr = &(shape[0].pos[0]);
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
    float *shape_ptr = &(shape[0].pos[0]);
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
//    float *shape_ptr = &shape[0];
//    for(int i = 0; i < num_points; ++i)
//    {
//        *shape_ptr++ *= s;
//        *shape_ptr++ *= s;
//        shape_ptr++;
//    }
    
    float T[9];
    T[0] = s;
    T[1] = 0;
    T[2] = 0;
    T[3] = 0;
    T[4] = s;
    T[5] = 0;
    T[6] = 0;
    T[7] = 0;
    T[8] = 1;
    [self transformAffine:&T[0]];
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
//    float *shape_ptr = &shape[0];
//    for(int i = 0; i < num_points; ++i)
//    {
//        *shape_ptr++ += tx;
//        *shape_ptr++ += ty;
//        shape_ptr++;
//    }
    
    float T[9];
    T[0] = 1;
    T[1] = 0;
    T[2] = 0;
    T[3] = 0;
    T[4] = 1;
    T[5] = 0;
    T[6] = tx;
    T[7] = ty;
    T[8] = 1;
    [self transformAffine:&T[0]];
}

- (void)transformAffine:(float*)T
{
    int lda = 3;
    int ldt = 3;
    int ldb = 3;
    
    float s = 1.0;
    float *tmpShape = (float*)malloc(num_points*sizeof(point_t));
    memset(tmpShape, 0, num_points*sizeof(point_t));
    
    cblas_sgemm(CblasRowMajor,
                CblasNoTrans,
                CblasNoTrans,
                num_points,     // num of rows in matrices A and C
                3,              // num of col in matrices B and C
                3,              // Num of col in matrix A; number of rows in matrix B.
                s,              // alpha
                &shape[0].pos[0],          // matrix A
                lda,            // size of the first dimension of matrix A
                T,              // matrix B
                ldt,            // size of the first dimension of matrix B
                s,              // beta
                tmpShape,          // matrix C
                ldb             // size of the first dimention of matrix C
                );
    
    float *shape_ptr = &shape[0].pos[0];
    float *tmpshape_ptr = &tmpShape[0];
    for(int i = 0; i < 3*num_points; ++i) {
        *shape_ptr++ = *tmpshape_ptr++;
    }
    free(tmpShape);
}

- (void)transformAffineMat:(PDMTMat*)T
{
    [self transformAffine:T.T];
}

- (PDMTMat*)findAlignTransformationTo:(PDMShape*)s;
{
    //NSLog(@"Find matching transformation");
    double a = 0;
    double b = 0;
    double c = 0;
    const float *data_ptr1 = &shape[0].pos[0];
    const float *data_ptr2 = &(s.shape[0].pos[0]);
    for(int i = 0; i < num_points; ++i)
    {
        a += ((*data_ptr1) * (*data_ptr2) + (*(data_ptr1+1)) * (*(data_ptr2+1)));
        b += ((*data_ptr1) * (*(data_ptr2+1)) - (*(data_ptr1+1)) * (*data_ptr2));
        c += ((*data_ptr1) * (*data_ptr1) + (*(data_ptr1+1)) * (*(data_ptr1+1)));
        
        data_ptr1 += 3;
        data_ptr2 += 3;
    }
    
    CGPoint g = [s getCenterOfGravity];
    
    PDMTMat *mat = [[PDMTMat alloc] init];
    a = (float)(a/c);
    b = (float)(b/c);
    
    mat.T[0] = a;
    mat.T[1] = b;
    mat.T[2] = 0;
    mat.T[3] = -b;
    mat.T[4] = a;
    mat.T[5] = 0;
    mat.T[6] = g.x;
    mat.T[7] = g.y;
    mat.T[8] = 1;
    
    //NSLog(@"match: a = %f, b = %f, tx = %f, ty = %f", match.a, match.b, match.tx, match.ty);
    //NSLog(@"match: s = %f, r = %f", sqrt(pow(match.a,2)+pow(match.b,2)), atan2(match.b, match.a));
    
    return mat;
}

- (void)alignShapeTo:(PDMShape*)s
{
    PDMTMat *T = [self findAlignTransformationTo:s];
    [self transformAffineMat:T];
}

- (void)transformIntoTangentSpaceTo:(PDMShape*)s
{
    float scale = 0;
    float *data_ptr1 = &shape[0].pos[0];
    float *data_ptr2 = &s.shape[0].pos[0];
    for(int i = 0; i < num_points; ++i)
    {
        scale += ((*data_ptr1++) * (*data_ptr2++));
        scale += ((*data_ptr1++) * (*data_ptr2++));
        data_ptr1++;
        data_ptr2++;
    }
    
    scale = 1/scale;
    
    data_ptr1 = &shape[0].pos[0];
    for(int i = 0; i < num_points; ++i)
    {
        (*data_ptr1++) *= scale;
        (*data_ptr1++) *= scale;
        data_ptr1++;
    }
}


// -----------------------------------------------
// FILE HANDLING

- (void)loadShape:(NSString*)file
{
    
#ifdef DEBUG
    NSLog(@"PDMShape:loadShape");
#endif
    
    NSError* err;
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"csv"];
    NSString *dataStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    
    if(dataStr == nil) {
        NSLog(@"Error reading file at %@\n%@", path, [err localizedFailureReason]);
    }
    NSArray *dataArray = [dataStr componentsSeparatedByString:@"\n"];
    
    num_points = ([dataArray count]-1)/2;
    size_t num_bytes = num_points*sizeof(point_t);      // store as homogeneous
    if(shape) {
        free(shape);
    }
    shape = (point_t*)malloc(num_bytes);
    float *shape_ptr = &(shape[0].pos[0]);
    for(int i = 0; i < num_points; ++i)
    {
        *shape_ptr++ = [[dataArray objectAtIndex:i] doubleValue];
        *shape_ptr++ = -[[dataArray objectAtIndex:i+num_points] doubleValue];
        *shape_ptr++ = 1.0;
    }
}

- (void)loadPointInfo:(NSString*)file
{
    [pointsInfo loadPointsInfo:file];
}

- (void)printShapeValues
{
    // print shape values
    NSMutableString *tmp = [[NSMutableString alloc] init];
    for(int i = 0; i < num_points; ++i)
    {
        [tmp appendFormat:@"P%i = [", i];
        [tmp appendFormat:@"%f, ", shape[i].pos[0]];
        [tmp appendFormat:@"%f, ", shape[i].pos[1]];
        [tmp appendFormat:@"%f", shape[i].pos[2]];
        [tmp appendFormat:@"]\n"];
    }
    NSLog(@"\n\n%@\n", tmp);
}


@end
