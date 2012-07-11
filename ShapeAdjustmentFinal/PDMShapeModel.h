//
//  PDMShapeModel.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PDMShape.h"

@interface PDMShapeModel : NSObject
{
    PDMShape *meanShape;
}

@property (retain) PDMShape *meanShape;


- (void)loadModel:(NSString*)fXM :(NSString*)fV :(NSString*)fD :(NSString*)fTRI;

@end
