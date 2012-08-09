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



@interface ViewFace : UIView {
    UIImage *tmpImage;
    PDMShape *tmpShape;
    
    float scale;
    BOOL drawShape;
    
    NSMutableArray *activeTouches;
    float touchRadius;
}

@property (nonatomic, readonly) float scale;
@property (nonatomic) float touchRadius;
@property (nonatomic) BOOL drawShape;


- (void)setImage:(UIImage*)img;
- (void)setShape:(PDMShape*)shape;

- (void)addTouch:(UITouch*)touch;
- (void)removeTouch:(UITouch*)touch;


@end
