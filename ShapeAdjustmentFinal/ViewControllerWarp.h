//
//  ViewControllerWarp.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMModelController.h"
#import "PDMShape.h"
#import "ViewFace.h"
#import "PiecewiseAffineWarp.h"

@interface ViewControllerWarp : UIViewController
{
    PDMShape *srcShape;
    PDMShape *dstShape;
    UIImage *origImage;
    UIImage *srcImage;
    UIImage *warpedImage;
    
    PDMShapeModel *shapeModel;
    PDMShapeParameter *shapeParams;
    PiecewiseAffineWarp *paw;
    
    __weak IBOutlet ViewFace *faceView;
    IBOutlet UISlider *slider;
    IBOutlet UISegmentedControl *segControl;
    IBOutlet UIView *settingsView;
    IBOutlet UISwitch *switchShape;
}

@property (nonatomic, retain) PDMShape *srcShape;
@property (nonatomic, retain) UIImage *origImage;

@property (nonatomic, weak) ViewFace* faceView;
@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UISegmentedControl *segControl;

@property (retain) IBOutlet UIView *settingsView;
@property (retain) IBOutlet UISwitch *switchShape;

- (IBAction)valueChanged:(id)sender;
- (IBAction)selectorChanged:(id)sender;
- (IBAction)startOver:(id)sender;
- (IBAction)resetShape:(id)sender;


- (IBAction)showSettings:(id)sender;
- (IBAction)dismissSettings:(id)sender;
- (IBAction)changeShowShape:(id)sender;

@end
