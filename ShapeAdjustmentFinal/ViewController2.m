//
//  ViewController2.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

@synthesize mainController;
@synthesize faceView;
@synthesize slider;
@synthesize segControl;


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad2...mainController = %@", mainController);
    
    if(mainController)
    {
        [faceView setNewFace:mainController.face];
        b = [[NSMutableArray alloc] init];
        for(int i = 0; i < mainController.shapeModel.num_vecs; ++i) {
            [b addObject:[NSNumber numberWithFloat:0]];
        }
        tmpShape = mainController.face.shape;
    }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    
    if([[segue identifier] isEqualToString:@"View2ToView1"]) {
        ViewController *VC = (ViewController*)[segue destinationViewController];
        VC.mainController = mainController;
        NSLog(@"Transition to the first view");
    }
    
    if([[segue identifier] isEqualToString:@"View2ToView3"]) {
        ViewController3 *VC = (ViewController3*)[segue destinationViewController];
        VC.mainController = mainController;
        NSLog(@"Transition to the third view");
    }
}


- (IBAction)sliderValueChanged:(id)sender
{
    float value = slider.value;
    int index = segControl.selectedSegmentIndex;
    [b replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:value]];
    [self updateModel];
}

- (IBAction)modeSelectorChanged:(id)sender
{
    int index = segControl.selectedSegmentIndex;
    [slider setValue:[[b objectAtIndex:index] floatValue]];
    [self updateModel];
}

- (void)updateModel
{
    NSLog(@"UPDATE MODEL");
    PDMShape *newShape = [mainController.shapeModel createNewShapeWithParams:b];
    [newShape alignShapeTo:tmpShape];
    mainController.face.shape = newShape;
    [faceView updateShape:newShape];
}

@end
