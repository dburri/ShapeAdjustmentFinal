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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad...mainController = %@", mainController);

    if(mainController)
    {
        [faceView setFaceImage:mainController.faceImage];
        [faceView setFaceShapeParams:mainController.shapeModel.meanShape :mainController.shapeParams.T];
        faceView.delegate = self;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)updateShapeParameter:(ViewFace *)controller newParams:(PDMTMat *)tmat
{
    [mainController updateT:tmat];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"View1ToView2"]) {
        ViewController2 *VC = (ViewController2*)[segue destinationViewController];
        VC.mainController = self.mainController;
        NSLog(@"Transition to the second view");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"Image picked...");
	[picker dismissModalViewControllerAnimated:YES];
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [mainController newFaceWithImage:image];
    
    [faceView setFaceImage:image];
    [faceView setFaceShapeParams:mainController.shapeModel.meanShape :mainController.shapeParams.T];
    
    [faceView setNeedsDisplay];
}


- (IBAction)loadImageLibrary:(id)sender {
    NSLog(@"Load Image From Library");
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	[self presentModalViewController:picker animated:YES];
    
}

- (IBAction)loadImageCamera:(id)sender {
    NSLog(@"Load Image From Camera");
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentModalViewController:picker animated:YES];
    
}

@end
