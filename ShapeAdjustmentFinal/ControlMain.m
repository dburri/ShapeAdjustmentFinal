//
//  ControlMain.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlMain.h"

@implementation ControlMain

@synthesize shapeModel;
@synthesize face;


static int theCount = 0;

+ (int) count { return theCount; }


- (id)init {
    self = [super init];
    if (self) {
        count = theCount++;
        NSLog(@"ControlMain:init:%i", count);
    }
    return self;
}

- (void)dealloc {
    NSLog(@"ControlMain:dealloc:%i", count);
    shapeModel = nil;
    face = nil;
}

- (void)newFaceWithImage:(UIImage*)image
{
    NSLog(@"ControlMain:newFaceWithImage");
    face = nil;
    face = [[Face alloc] init];
    face.image = image;
    face.shape = [shapeModel.meanShape getCopy];
    
    
    // scale the shape to half of the image size
    CGRect box = [face.shape getMinBoundingBox];
    float s1 = image.size.width/box.size.width;
    float s2 = image.size.height/box.size.height;
    float s = MIN(s1, s2)/2;
    [face.shape scale:s];
    
    // translate shape to image center
    [face.shape translate:image.size.height/2 :image.size.width/2];
}


@end
