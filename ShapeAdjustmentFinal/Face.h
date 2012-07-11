//
//  Face.h
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDMShape.h"

@interface Face : NSObject {
    PDMShape *shape;
    UIImage *image;
}

@property (retain) PDMShape *shape;
@property (retain) UIImage *image;

@end
