//
//  Face.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Face.h"

@implementation Face

@synthesize shape;
@synthesize image;

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"Face:init");
    }
    return self;
}

- (void)dealloc
{
    shape = nil;
    image = nil;
}




@end
