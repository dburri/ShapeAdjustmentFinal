//
//  ViewFace3.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Face.h"
#import "PDMShapeModel.h"

typedef enum 
{
    TOUCH_V3_NONE,
    TOUCH_V3_MODIFY
} TouchModeView3;

@interface ViewFace3 : UIView
{
    Face *face;
    PDMShapeModel *model;
    PDMShapeParameter *param;
    
    UIImage *tmpImage;
    PDMShape *tmpShape;
    
    float scale;
    
    TouchModeView3 touchMode;
    CGPoint touchStartPos;
    CGPoint touchLastPos;
    float touchStartDistance;
    float touchStartAngle;
    
    NSMutableArray *activeTouches;
    NSDate *firstTouchStart;
}

@property (retain) PDMShapeModel *model;
@property (retain) PDMShapeParameter *param;

- (void)setNewFace:(Face*)f;
- (void)updateShape:(PDMShape*)s;


@end
