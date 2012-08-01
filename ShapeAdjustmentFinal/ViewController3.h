//
//  ViewController3.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlMain.h"
#import "ViewFace3.h"
#import "ViewController2.h"

@interface ViewController3 : UIViewController <View3NewShapeParametersDelegate>
{
    ControlMain *mainController;
    PDMShape *tmpShape;
    
    float boundCube;
    float boundEllipse;
    
    IBOutlet ViewFace3 *faceView;
    IBOutlet UISegmentedControl *segControl;
    IBOutlet UISlider *slider;
    IBOutlet UISlider *sliderSize;
    IBOutlet UILabel *textField;
    IBOutlet UILabel *textFieldSize;
    IBOutlet UIView *settingsView;
}

@property (retain) ControlMain *mainController;
@property (retain) IBOutlet ViewFace3 *faceView;
@property (retain) IBOutlet UISegmentedControl *segControl;
@property (retain) IBOutlet UISlider *slider;
@property (retain) IBOutlet UISlider *sliderSize;
@property (retain) IBOutlet UILabel *textField;
@property (retain) IBOutlet UILabel *textFieldSize;
@property (retain) IBOutlet UIView *settingsView;

- (IBAction)changeBoundMode:(id)sender;
- (IBAction)changeBoundValue:(id)sender;
- (IBAction)changeTouchSize:(id)sender;
- (IBAction)resetParams:(id)sender;

- (IBAction)showSettings:(id)sender;
- (IBAction)dismissSettings:(id)sender;


@end
