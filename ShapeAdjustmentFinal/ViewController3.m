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
@synthesize textField;
@synthesize segControl;

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
    
    textField.text = [NSString stringWithFormat:@"value = %i", (int)boundCube];
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
        textField.text = [NSString stringWithFormat:@"value = %i", (int)boundCube];
    } else {
        boundEllipse = slider.value;
        textField.text = [NSString stringWithFormat:@"value = %i", (int)boundEllipse];
    }
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
        tmpParam = [mainController.shapeModel applyConstraintsToParamsCube:tmpParam :slider.value];
    } else {
        tmpParam = [mainController.shapeModel applyConstraintsToParamsEllipse:tmpParam :slider.value];
    }
    
    
    [mainController update:tmpParam];
    [faceView setShape:mainController.faceShape];
}

@end
