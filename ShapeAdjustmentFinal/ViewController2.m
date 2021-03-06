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
    
    if(mainController)
    {
        [faceView setImage:mainController.faceImage];
        [faceView setShape:mainController.faceShape];
        
        // set param vector
        b = mainController.shapeParams.b;
        int index = segControl.selectedSegmentIndex;
        [slider setValue:[[b objectAtIndex:index] floatValue]];
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
    }
    
    if([[segue identifier] isEqualToString:@"View2ToView3"]) {
        ViewController3 *VC = (ViewController3*)[segue destinationViewController];
        VC.mainController = mainController;
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
    //NSLog(@"UPDATE MODEL");
    [mainController updateb:b];
    [faceView setShape:mainController.faceShape];
}

@end
