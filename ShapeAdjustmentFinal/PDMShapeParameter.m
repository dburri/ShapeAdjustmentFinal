//
//  PDMShapeParameter.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDMShapeParameter.h"

@implementation PDMShapeParameter

@synthesize T;
@synthesize b;

- (id)init 
{
    self = [super init];
    if (self) {
        NSLog(@"PDMShapeParameter:init");
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"PDMShapeParameter:dealloc");
}

@end
