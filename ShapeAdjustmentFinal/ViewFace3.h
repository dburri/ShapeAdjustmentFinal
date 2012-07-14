//
//  ViewFace3.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Face.h"

@interface ViewFace3 : UIView
{
    Face *face;
    UIImage *tmpImage;
    float scale;
    
    //PDMShapeModel *shapeModel;
    //PDMShape *tmpShape;
}

- (void)setNewFace:(Face*)f;
- (void)updateShape:(PDMShape*)s;


@end
