//
//  ViewShape.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Face.h"


typedef enum 
{
    TOUCH_NONE,
    TOUCH_TRANSLATE_SHAPE,
    TOUCH_SCALE_SHAPE
} TouchMode;

@interface ViewFace : UIView {
    Face *face;
    UIImage *tmpImage;
    PDMShape *tmpShape;
    
    TouchMode touchMode;
    CGPoint touchStartPos;
    float touchStartDistance;
    
    float scale;
    
    NSMutableArray *activeTouches;
}

- (void)setNewFace:(Face*)f;

@end
