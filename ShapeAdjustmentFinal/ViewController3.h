//
//  ViewController3.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ControlMain.h"
#import "ViewFace3.h"
#import "ViewController2.h"

@interface ViewController3 : UIViewController
{
    ControlMain *mainController;
    NSMutableArray *b;
    PDMShape *tmpShape;
    
    IBOutlet ViewFace3 *faceView;
}

@property (retain) ControlMain *mainController;
@property (retain) IBOutlet ViewFace3 *faceView;

@end
