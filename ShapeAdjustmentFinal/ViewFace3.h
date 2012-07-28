//
//  ViewFace3.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMShapeModel.h"

typedef enum 
{
    TOUCH_V3_NONE,
    TOUCH_V3_MODIFY
} TouchModeView3;




@class ViewFace3;

@protocol View3NewShapeParametersDelegate
- (void)updateShapeParameter:(PDMShapeParameter*)params;
- (void)shapeModified:(PDMShape*)s;
@end

@interface TouchState : NSObject {
    UITouch *touch;
    CGPoint touchStartPos;
    CGPoint touchLastPos;
}

@property (retain) UITouch *touch;
@property CGPoint touchStartPos;
@property CGPoint touchLastPos;

@end

@interface ViewFace3 : UIView
{
    UIImage *tmpImage;
    PDMShape *faceShape;
    
    float scale;
    
    TouchModeView3 touchMode;
    
    NSMutableArray *activeTouches;
}

@property (nonatomic, weak) id <View3NewShapeParametersDelegate> delegate;

@property (retain) PDMShapeModel *model;
@property (retain) PDMShapeParameter *param;

- (void)setFaceImage:(UIImage*)img;
- (void)setShape:(PDMShape*)s;



@end
