//
//  ViewController3.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController3.h"


@implementation TouchState

@synthesize touch;
@synthesize touchLastPos;
@synthesize touchStartPos;

@end



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
    
    activeTouches = [[NSMutableArray alloc] init];
    
    if(mainController)
    {
        [faceView setImage:mainController.faceImage];
        [faceView setShape:mainController.faceShape];
    }
    
    boundCube = 100;
    boundEllipse = 200;
    
    textField.text = [NSString stringWithFormat:@"Param Bound = %i", (int)boundCube];
    textFieldSize.text = [NSString stringWithFormat:@"Touch Size = %i", (int)sliderSize.value];
    slider.value = boundCube;
    
    radius = 60;
    faceView.touchRadius = radius;
    sliderSize.value = radius;
    textFieldSize.text = [NSString stringWithFormat:@"Touch Size = %i", (int)radius];
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
    if(segControl.selectedSegmentIndex == 0) {
        textField.text = [NSString stringWithFormat:@"Param Bound = %i", (int)boundCube];
        slider.value = boundCube;
    } else {
        textField.text = [NSString stringWithFormat:@"Param Bound = %i", (int)boundEllipse];
        slider.value = boundEllipse;
    }
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
    radius = sliderSize.value;
    textFieldSize.text = [NSString stringWithFormat:@"Touch Size = %i", (int)radius];
    faceView.touchRadius = radius;
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
    }
    if([[segue identifier] isEqualToString:@"View3ToViewWarp"]) {
        ViewControllerWarp *VC = (ViewControllerWarp*)[segue destinationViewController];
        VC.srcShape = mainController.faceShape;
        VC.origImage = mainController.faceImage;
    }
}

- (void)updateShapeParameter:(PDMShapeParameter*)params
{
    [mainController update:params];
}


- (void)shapeModified:(PDMShape*)s
{
    
    // apply model
    PDMShapeParameter *tmpParam = [mainController.shapeModel findBestMatchingParams:s];
    
    if(segControl.selectedSegmentIndex == 0)
    {
        tmpParam = [mainController.shapeModel applyConstraintsToParamsCube:tmpParam :boundCube];
    }
    else
    {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{   
    // add touch if this touch does not exist already
    NSArray *touchesArray = [touches allObjects];
    for (UITouch *uiTouch in touchesArray) {
        
        BOOL exists = NO;
        for (TouchState *touchState in activeTouches) {
            if(touchState.touch == uiTouch) {
                exists = YES;
            }
        }
        
        if(exists == NO) {
            TouchState *newTouch = [[TouchState alloc] init];
            
            newTouch.touch = uiTouch;
            newTouch.touchStartPos = [uiTouch locationInView:self.view];
            newTouch.touchLastPos = [uiTouch locationInView:self.view];
            
            [activeTouches addObject:newTouch];
            [faceView addTouch:uiTouch];
        }
    }
    
    int touchesCount = [activeTouches count];
    NSLog(@"Touch Count = %i", touchesCount);
    
    if(touchesCount > 0) {
        touchMode = TOUCH_V3_MODIFY;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchMode == TOUCH_V3_MODIFY)
    {
        PDMShape *tmpShape = mainController.faceShape;
        for (TouchState *touchState in activeTouches)
        {
            CGPoint p = [touchState.touch locationInView:self.view];
            
            float dx = (p.x-touchState.touchLastPos.x)/faceView.scale;
            float dy = (p.y-touchState.touchLastPos.y)/faceView.scale;
            
            // find points to shift
            for(int i = 0; i < tmpShape.num_points; ++i)
            {
                CGPoint ps = CGPointMake(tmpShape.shape[i].pos[0]*faceView.scale, tmpShape.shape[i].pos[1]*faceView.scale);
                
                float dist2 = ((ps.x - p.x) * (ps.x - p.x) + (ps.y - p.y) * (ps.y - p.y));
                float dist = sqrt(dist2);
                
                // move points
                float intensity = 0;
                if(dist < radius)
                {
                    intensity = (radius-dist)/radius;
                    intensity = (intensity < 0 ? 0 : intensity);
                    intensity = (intensity > 1 ? 1 : intensity);
                    tmpShape.shape[i].pos[0] += dx*intensity;
                    tmpShape.shape[i].pos[1] += dy*intensity;
                }
            }
            touchState.touchLastPos = p;
        }
        [self shapeModified:tmpShape];
    }
    
}

/**
 Called when a touch ends
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // remove the touch that ended
    NSArray *touchesArray = [touches allObjects];
    for (UITouch *uiTouch in touchesArray) {
        
        for (TouchState *touchState in activeTouches) {
            if(touchState.touch == uiTouch) {
                [activeTouches removeObject:touchState];
                break;
            }
        }
        [faceView removeTouch:uiTouch];
    }
    
    [faceView setNeedsDisplay];
}

@end
