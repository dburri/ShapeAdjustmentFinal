//
//  ViewController.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mainController;
@synthesize faceView;
@synthesize buttonContinue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activeTouches = [[NSMutableArray alloc] init];
    
    if(mainController)
    {
        [faceView setImage:mainController.faceImage];
        [faceView setShape:mainController.faceShape];
    }
    else
    {
        buttonContinue.enabled = false;
        buttonContinue.hidden = true;
    }
    
}

- (void)startModeling:(UIImage*)img
{
    mainController = [[PDMModelController alloc] init];
    [mainController loadShapeModel:@"xm2vts_m_model_xm" :@"xm2vts_m_model_v" :@"xm2vts_m_model_d" :@"xm2vts_m_model_tri"];
    
    [mainController newFaceWithImage:img];
    
    [faceView setImage:mainController.faceImage];
    [faceView setShape:mainController.faceShape];
    
    [faceView setNeedsDisplay];
    
    buttonContinue.enabled = true;
    buttonContinue.hidden = false;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"View1ToView2"]) {
        ViewController2 *VC = (ViewController2*)[segue destinationViewController];
        VC.mainController = self.mainController;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self startModeling:image];
}


- (IBAction)loadImageLibrary:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentModalViewController:picker animated:YES];
    
}

- (IBAction)loadImageCamera:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:picker animated:YES];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{   
    if(!mainController)
        return;
    
    NSArray *touchesArray = [touches allObjects];
    for(NSInteger j = 0; j < [touchesArray count]; ++j) {
        if (![activeTouches containsObject:[touchesArray objectAtIndex:j]]) {
            [activeTouches addObject:[touchesArray objectAtIndex:j]];
        };
    }
    
    int touchesCount = [activeTouches count];
    //NSLog(@"Touch Count = %i", touchesCount);
    
    
    if(touchesCount == 1 && touchMode == TOUCH_NONE)
    {
        //NSLog(@"set mode to translate");
        touchMode = TOUCH_TRANSLATE_SHAPE;
        UITouch * touch = [touches anyObject];
        touchStartPos = [touch locationInView:self.view];
    }
    
    if(touchesCount == 2)
    {
        //NSLog(@"set mode to scale");
        touchMode = TOUCH_SCALE_SHAPE;
        UITouch *touch1 = [activeTouches objectAtIndex:0];
        UITouch *touch2 = [activeTouches objectAtIndex:1];
        
        CGPoint p1 = [touch1 locationInView:self.view];
        CGPoint p2 = [touch2 locationInView:self.view];
        
        touchStartPos = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
        touchStartDistance = sqrtf( powf(p1.x-p2.x,2) + powf(p1.y-p2.y,2));
        touchStartAngle = atan2f(p1.x-p2.x, p1.y-p2.y);
    }
    
    origTMat = mainController.shapeParams.T;
    tmpTMat = [[PDMTMat alloc] initWithMat:origTMat];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchMode == TOUCH_TRANSLATE_SHAPE)
    {
        UITouch *touch = [activeTouches objectAtIndex:0];
        CGPoint p = [touch locationInView:self.view];
        
        float dx = (p.x-touchStartPos.x)/faceView.scale;
        float dy = (p.y-touchStartPos.y)/faceView.scale;
        
        PDMTMat *matT = [[PDMTMat alloc] initWithTranslate:dx :dy];
        tmpTMat = [origTMat multiply:matT];
    }
    
    else if(touchMode == TOUCH_SCALE_SHAPE)
    {
        UITouch *touch1 = [activeTouches objectAtIndex:0];
        UITouch *touch2 = [activeTouches objectAtIndex:1];
        
        CGPoint p1 = [touch1 locationInView:self.view];
        CGPoint p2 = [touch2 locationInView:self.view];
        CGPoint p = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
        
        float dx = (p.x-touchStartPos.x)/faceView.scale;
        float dy = (p.y-touchStartPos.y)/faceView.scale;
        
        float touchDistance = sqrtf( powf(p1.x-p2.x,2) + powf(p1.y-p2.y,2));
        float s = touchDistance/touchStartDistance;
        float touchAngle = atan2f(p1.x-p2.x, p1.y-p2.y);
        float a = touchStartAngle - touchAngle;
        //NSLog(@"Angle = %f", a);
        
        PDMTMat *matSRT = [[PDMTMat alloc] initWithSRT:s :a :dx :dy];
        tmpTMat = [origTMat multiplyPreservingTranslation:matSRT];
    }
    
    [mainController updateT:tmpTMat];
    [faceView setShape:mainController.faceShape];
}

/**
 Called when a touch ends
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // remove the touch from the list of active touches
    NSArray *touchesArray = [touches allObjects];
    for(NSInteger j = 0; j < [touchesArray count]; ++j) {
        NSUInteger ind = [activeTouches indexOfObject:[touchesArray objectAtIndex:j]];
        
        if(ind == 0 && touchMode == TOUCH_TRANSLATE_SHAPE)
            touchMode = TOUCH_NONE;
        
        if((ind == 0 || ind == 1) && touchMode == TOUCH_SCALE_SHAPE)
            touchMode = TOUCH_NONE;

        if(ind != NSNotFound)
            [activeTouches removeObjectAtIndex:ind];
    }
}


@end
