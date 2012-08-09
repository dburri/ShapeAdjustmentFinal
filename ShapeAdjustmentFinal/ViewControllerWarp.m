//
//  ViewControllerWarp.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewControllerWarp.h"

@interface ViewControllerWarp ()

@end

@implementation ViewControllerWarp

@synthesize srcShape;
@synthesize origImage;

@synthesize faceView;
@synthesize segControl;
@synthesize slider;

@synthesize switchShape;
@synthesize settingsView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"INIT WARP VIEW WITH NIB NAME");
        paw = [[PiecewiseAffineWarp alloc] init];
        
        shapeModel = [[PDMShapeModel alloc] init];
        [shapeModel loadModel:@"xm2vts_m_model_xm" :@"xm2vts_m_model_v" :@"xm2vts_m_model_d" :@"xm2vts_m_model_tri"];
        shapeParams = [[PDMShapeParameter alloc] initWithSize:shapeModel.num_vecs];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        NSLog(@"INIT WARP VIEW WITH NIB NAME");
        paw = [[PiecewiseAffineWarp alloc] init];
        
        shapeModel = [[PDMShapeModel alloc] init];
        [shapeModel loadModel:@"xm2vts_m_model_xm" :@"xm2vts_m_model_v" :@"xm2vts_m_model_d" :@"xm2vts_m_model_tri"];
        shapeParams = [[PDMShapeParameter alloc] initWithSize:shapeModel.num_vecs];
    }
    return self; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    // resize image to screensize
    CGSize viewSize = faceView.frame.size;
    float s1 = origImage.size.width/viewSize.width;
    float s2 = origImage.size.height/viewSize.height;
    float scale = 1/MAX(s1,s2);
    CGSize imgSize = CGSizeMake(scale*origImage.size.width, scale*origImage.size.height);
    UIGraphicsBeginImageContext(viewSize);
    [origImage drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    srcImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    // scale shape appropriate
    [srcShape scale:scale];
    
    // create second shape according to parameters
    shapeParams = [shapeModel findBestMatchingParams:srcShape];
    dstShape = [shapeModel createNewShapeWithAllParams:shapeParams];
    
    
    warpedImage = [paw warpImage:srcImage :srcShape :dstShape :shapeModel.triangles];
    
    
    [faceView setImage:warpedImage];
    [faceView setShape:dstShape];
    
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


- (IBAction)valueChanged:(id)sender
{
    [shapeParams.b replaceObjectAtIndex:segControl.selectedSegmentIndex withObject:[NSNumber numberWithFloat:slider.value]];
    
    [self updateShape];
}

- (IBAction)selectorChanged:(id)sender
{
    slider.value = [[shapeParams.b objectAtIndex:segControl.selectedSegmentIndex] floatValue];
}

- (IBAction)startOver:(id)sender
{
    
}

- (IBAction)resetShape:(id)sender
{
    for(int i = 0; i < [shapeParams.b count]; ++i) {
        [shapeParams.b replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:0]];
    }
    
    [self updateShape];
}


- (IBAction)changeShowShape:(id)sender
{
    if(switchShape.on) {
        faceView.drawShape = YES;
    }
    else {
        faceView.drawShape = NO;
    }
    [faceView setNeedsDisplay];
}

- (void)updateShape
{
    dstShape = [shapeModel createNewShapeWithAllParams:shapeParams];
    
    warpedImage = [paw warpImage:srcImage :srcShape :dstShape :shapeModel.triangles];
    
    [faceView setImage:warpedImage];
    [faceView setShape:dstShape];
}

- (IBAction)showSettings:(id)sender
{
    NSLog(@"show settings");
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
