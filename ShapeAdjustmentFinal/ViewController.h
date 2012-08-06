//
//  ViewController.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlMain.h"
#import "ViewFace.h"
#import "ViewController2.h"

typedef enum 
{
    TOUCH_NONE,
    TOUCH_TRANSLATE_SHAPE,
    TOUCH_SCALE_SHAPE
} TouchMode;

@interface TouchState : NSObject {
    UITouch *touch;
    CGPoint touchStartPos;
    CGPoint touchLastPos;
}

@property (retain) UITouch *touch;
@property CGPoint touchStartPos;
@property CGPoint touchLastPos;

@end


@interface ViewController : UIViewController < UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    ControlMain *mainController;
    IBOutlet ViewFace *faceView;

    PDMTMat *origTMat;
    PDMTMat *tmpTMat;
    
    TouchMode touchMode;
    CGPoint touchStartPos;
    float touchStartDistance;
    float touchStartAngle;
    
    NSMutableArray *activeTouches;
    NSDate *firstTouchStart;
}

@property (strong) ControlMain *mainController;
@property (retain) IBOutlet ViewFace *faceView;

- (IBAction)loadImageLibrary:(id)sender;
- (IBAction)loadImageCamera:(id)sender;


@end
