//
//  ViewFace2.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMShapeModel.h"

@interface ViewFace2 : UIView
{
    PDMShape *tmpShape;
    UIImage *tmpImage;
    float scale;
}

- (void)setFaceImage:(UIImage*)img;
- (void)updateShape:(PDMShape*)s;

@end
