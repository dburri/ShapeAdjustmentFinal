//
//  ViewController2.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMModelController.h"
#import "ViewFace.h"
#import "ViewController.h"
#import "ViewController3.h"

@interface ViewController2 : UIViewController
{
    PDMModelController *mainController;
    
    PDMShapeParameter *tmpParam;
    NSMutableArray *b;
    PDMShape *tmpShape;
    
    IBOutlet ViewFace *faceView;
    IBOutlet UISlider *slider;
    IBOutlet UISegmentedControl *segControl;
}

@property (retain) PDMModelController *mainController;
@property (retain) IBOutlet ViewFace *faceView;
@property (retain) IBOutlet UISlider *slider;
@property (retain) IBOutlet UISegmentedControl *segControl;

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)modeSelectorChanged:(id)sender;

- (void)updateModel;

@end
