//
//  PDMTriangle.m
//  PiecewiseAffineWarp2
//
//  Created by DINA BURRI on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDMTriangle.h"

@implementation PDMTriangle


@synthesize index;

- (id)init {
    self = [super init];
    if (self) {
        index = malloc(3*sizeof(unsigned int));
    }
    return self;
}

- (void)dealloc {
    free(index);
}

@end
