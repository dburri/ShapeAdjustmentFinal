//
//  ViewController3.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController3.h"

@interface ViewController3 ()

@end

@implementation ViewController3

@synthesize faceView;
@synthesize mainController;
@synthesize slider;
@synthesize sliderSize;
@synthesize textField;
@synthesize textFieldSize;
@synthesize segControl;
@synthesize settingsView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad3...mainController = %@", mainController);
    
    if(mainController)
    {
        [faceView setFaceImage:mainController.faceImage];
        [faceView setShape:mainController.faceShape];
        faceView.delegate = self;
    }
    
    boundCube = 50;
    boundEllipse = 100;
    
    textField.text = [NSString stringWithFormat:@"Param Bound = %i", (int)boundCube];
    textFieldSize.text = [NSString stringWithFormat:@"Touch Size = %i", (int)sliderSize.value];
    slider.value = boundCube;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)changeBoundMode:(id)sender
{
    
}

- (IBAction)changeBoundValue:(id)sender
{
    if(segControl.selectedSegmentIndex == 0) {
        boundCube = slider.value;
        textField.text = [NSString stringWithFormat:@"Param Bound = %i", (int)boundCube];
    } else {
        boundEllipse = slider.value;
        textField.text = [NSString stringWithFormat:@"Param Bound = %i", (int)boundEllipse];
    }
}


- (IBAction)changeTouchSize:(id)sender
{
    textFieldSize.text = [NSString stringWithFormat:@"Touch Size = %i", (int)sliderSize.value];
    [faceView setTouchRadius:sliderSize.value];
}

- (IBAction)resetParams:(id)sender
{
    [mainController resetBParam];
    [faceView setShape:mainController.faceShape];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if([[segue identifier] isEqualToString:@"View3ToView2"]) {
        ViewController2 *VC = (ViewController2*)[segue destinationViewController];
        VC.mainController = mainController;
        NSLog(@"Transition to the second view");
    }
}

- (void)updateShapeParameter:(PDMShapeParameter*)params
{
    [mainController update:params];
}


- (void)shapeModified:(PDMShape*)s
{
    NSLog(@"modified shape received from view3");
    
    // apply model
    PDMShapeParameter *tmpParam = [mainController.shapeModel findBestMatchingParams:s];
    
    
    if(segControl.selectedSegmentIndex == 0) {
        tmpParam = [mainController.shapeModel applyConstraintsToParamsCube:tmpParam :boundCube];
    } else {
        tmpParam = [mainController.shapeModel applyConstraintsToParamsEllipse:tmpParam :boundEllipse];
    }
    
    [mainController update:tmpParam];
    [faceView setShape:mainController.faceShape];
}


- (IBAction)showSettings:(id)sender
{
    if(settingsView.hidden == YES)
    {
        settingsView.hidden = NO;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             settingsView.alpha = 1.0;
                             settingsView.transform = CGAffineTransformMakeTranslation(0, -settingsView.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             settingsView.hidden = NO;
                         }];
        
        
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             faceView.alpha = 0.5;
                         }
                         completion:^(BOOL finished) {
                             faceView.userInteractionEnabled = NO;
                         }];
    }
    
}

- (IBAction)dismissSettings:(id)sender
{
    if(settingsView.hidden == NO)
    {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^ {
                             settingsView.alpha = 1.0;
                             settingsView.transform = CGAffineTransformMakeTranslation(0, 0);
                         }
                         completion:^(BOOL finished) {
                             settingsView.hidden = YES;
                         }];
        
        
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             faceView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             faceView.userInteractionEnabled = YES;
                         }];
    }
    
}

@end
