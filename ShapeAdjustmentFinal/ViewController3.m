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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad3...mainController = %@", mainController);
    
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
    if([[segue identifier] isEqualToString:@"View3ToView2"]) {
        ViewController2 *VC = (ViewController2*)[segue destinationViewController];
        VC.mainController = mainController;
        NSLog(@"Transition to the second view");
    }
}

@end
