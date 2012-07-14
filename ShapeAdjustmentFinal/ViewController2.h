//
//  ViewController2.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlMain.h"
#import "ViewFace2.h"
#import "ViewController.h"
#import "ViewController3.h"

@interface ViewController2 : UIViewController
{
    ControlMain *mainController;
    
    PDMShapeParameter *tmpParam;
    NSMutableArray *b;
    PDMShape *tmpShape;
    
    IBOutlet ViewFace2 *faceView;
    IBOutlet UISlider *slider;
    IBOutlet UISegmentedControl *segControl;
}

@property (retain) ControlMain *mainController;
@property (retain) IBOutlet ViewFace2 *faceView;
@property (retain) IBOutlet UISlider *slider;
@property (retain) IBOutlet UISegmentedControl *segControl;

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)modeSelectorChanged:(id)sender;

- (void)updateModel;

@end
