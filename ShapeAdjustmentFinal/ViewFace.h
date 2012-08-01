//
//  ViewShape.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMTMat.h"
#import "PDMShape.h"


typedef enum 
{
    TOUCH_NONE,
    TOUCH_TRANSLATE_SHAPE,
    TOUCH_SCALE_SHAPE
} TouchMode;

@class ViewFace;

@protocol ViewNewParamsDelegate
- (void)updateShapeParameter:(ViewFace *)controller newParams:(PDMTMat *)tmat;
@end

@interface ViewFace : UIView {
    UIImage *origImage;
    UIImage *tmpImage;
    
    PDMShape *origShape;
    PDMShape *tmpShape;
    
    PDMTMat *origTMat;
    PDMTMat *tmpTMat;
    
    TouchMode touchMode;
    CGPoint touchStartPos;
    float touchStartDistance;
    float touchStartAngle;
    
    float scale;
    
    NSMutableArray *activeTouches;
    NSDate *firstTouchStart;
}

@property (nonatomic, weak) id <ViewNewParamsDelegate> delegate;


- (void)setFaceImage:(UIImage*)img;
- (void)setFaceShapeParams:(PDMShape*)shape :(PDMTMat*)TMat;


@end
