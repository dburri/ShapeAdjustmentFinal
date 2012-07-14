//
//  PDMShapeParameter.h
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDMTMat.h"

@interface PDMShapeParameter : NSObject
{
    PDMTMat *align;
    float *params;
    size_t num_params;
}

@property PDMTMat *align;
@end

