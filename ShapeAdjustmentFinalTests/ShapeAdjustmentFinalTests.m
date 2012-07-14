//
//  ShapeAdjustmentFinalTests.m
//  ShapeAdjustmentFinalTests
//
//  Created by DINA BURRI on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShapeAdjustmentFinalTests.h"

#define ARC4RANDOM_MAX      0x100000000

@implementation ShapeAdjustmentFinalTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testPDMTMatInverse
{
    NSLog(@"Testing matrix inverse!");
    
    PDMTMat *mat = [[PDMTMat alloc] init];
    for(int i = 0; i < 9; ++i) {
        mat.T[i] = ((float)arc4random() / ARC4RANDOM_MAX);
    }
    
    PDMTMat *matInv = [mat inverse];
    
    
    // test if mat = inverse(inverse(mat))
    PDMTMat *mat2 = [matInv inverse];
    for(int i = 0; i < 9; ++i) {
        if(fabs(mat.T[i] - mat2.T[i]) > 0.000001) {
            STFail(@"Two values are different! mat.T[%i] = %f != mat2.T[%i] = %f", i, mat.T[i], i, mat2.T[i]);
        }
    }
    
    
    // test if eye = mat * inverse(mat)
    PDMTMat *mat3 = [mat multiply:matInv];
    PDMTMat *matCheck = [[PDMTMat alloc] initWithEye];
    for(int i = 0; i < 9; ++i) {
        if(fabs(mat3.T[i] - matCheck.T[i]) > 0.000001) {
            STFail(@"Two values are different! mat3.T[%i] = %f != matCheck.T[%i] = %f", i, mat3.T[i], i, matCheck.T[i]);
        }
    }
    
    
    
    
    
}

@end
