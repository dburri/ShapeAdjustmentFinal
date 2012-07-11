//
//  ControlMain.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PDMShapeModel.h"
#import "Face.h"

@interface ControlMain : NSObject {
    PDMShapeModel *shapeModel;
    Face *face;
    int count;

}
+ (int)count;

@property (retain) PDMShapeModel *shapeModel;
@property (retain) Face *face;

- (void)newFaceWithImage:(UIImage*)image;

@end
