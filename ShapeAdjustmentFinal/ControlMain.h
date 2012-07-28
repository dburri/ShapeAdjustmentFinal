//
//  ControlMain.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PDMShapeModel.h"

@interface ControlMain : NSObject {
    PDMShapeModel *shapeModel;
    PDMShapeParameter *shapeParams;
    
    PDMShape *faceShape;
    UIImage *faceImage;
    
    int count;
}
+ (int)count;

@property (retain) PDMShapeModel *shapeModel;
@property (retain, readonly) PDMShapeParameter *shapeParams;
@property (retain) UIImage *faceImage;
@property (retain) PDMShape *faceShape;

- (void)loadShapeModel:(NSString*)fXM :(NSString*)fV :(NSString*)fD :(NSString*)fTRI;

- (void)newFaceWithImage:(UIImage*)image;

- (void)updateT:(PDMTMat*)T;
- (void)updateb:(NSArray*)b;
- (void)update:(PDMShapeParameter*)param;
- (void)resetBParam;


@end
