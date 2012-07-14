//
//  PDMTMat.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDMTMat.h"

@implementation PDMTMat

@synthesize T;

- (id)init 
{
    self = [super init];
    if (self) {
        NSLog(@"PDMTMat:init");
        T = malloc(9*sizeof(float));
        memset(&T[0], 0, 9*sizeof(float));
    }
    return self;
}

- (id)initWithEye
{
    self = [super init];
    if (self) {
        NSLog(@"PDMTMat:init");
        T = malloc(9*sizeof(float));
        memset(&T[0], 0, 9*sizeof(float));
        T[0] = 1;
        T[4] = 1;
        T[8] = 1;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"PDMTMat:dealloc");
    free(T);
}

@end
