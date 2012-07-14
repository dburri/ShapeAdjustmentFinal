//
//  ViewController.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlMain.h"
#import "ViewFace.h"
#import "ViewController2.h"

@interface ViewController : UIViewController < UIImagePickerControllerDelegate, UINavigationControllerDelegate >
{
    ControlMain *mainController;
    IBOutlet ViewFace *faceView;
}

@property (strong) ControlMain *mainController;
@property (retain) IBOutlet ViewFace *faceView;

- (IBAction)loadImageLibrary:(id)sender;
- (IBAction)loadImageCamera:(id)sender;


@end
