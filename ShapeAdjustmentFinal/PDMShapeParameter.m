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
        T = [[PDMTMat alloc] initWithEye];
        b = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (id)initWithSize:(int)s
{
    self = [super init];
    if (self) {
        NSLog(@"PDMShapeParameter:initWithSize %i", s);
        T = [[PDMTMat alloc] initWithEye];
        b = [NSMutableArray arrayWithCapacity:s];
        for(int i = 0; i < s; ++i) {
            [b addObject:[NSNumber numberWithFloat:0]];
        }
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"PDMShapeParameter:dealloc");
}

- (void)printParams
{
    NSMutableString *text = [[NSMutableString alloc] init];
    
    [text appendFormat:@"T = ["];
    for(int i = 0; i < 9; ++i) {
        [text appendFormat:@"%f, ", T.T[i]];
    }
    [text appendFormat:@"] \n"];
    
    [text appendFormat:@"b = ["];
    for(int i = 0; i < [b count]; ++i) {
        [text appendFormat:@"%f, ", [[b objectAtIndex:i] floatValue]];
    }
    [text appendFormat:@"] \n"];
    
    NSLog(@"Shape Parameters:\n%@", text);
}

@end
