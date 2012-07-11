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
}

- (void)loadModel:(NSString*)fXM :(NSString*)fV :(NSString*)fD :(NSString*)fTRI
{
    NSLog(@"PDMShapeModel:loadModel");
    
    // load mean shape
    if(meanShape != nil)
        meanShape= nil;
    meanShape = [[PDMShape alloc] init];
    [meanShape loadShape:fXM];
    
}

@end
