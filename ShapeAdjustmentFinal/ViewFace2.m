//
//  ViewFace2.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewFace2.h"

@implementation ViewFace2

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setFaceImage:(UIImage*)img
{
    CGSize viewSize = self.frame.size;
    
    float s1 = img.size.width/viewSize.width;
    float s2 = img.size.height/viewSize.height;
    scale = 1/MAX(s1,s2);
    
    CGSize imgSize = CGSizeMake(scale*img.size.width, scale*img.size.height);
    
    UIGraphicsBeginImageContext(imgSize);
    [img drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


- (void)updateShape:(PDMShape*)s
{
    tmpShape = s;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"draw rect in viewface2");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextAddRect(context,CGRectMake(80, 80, 120, 120));
    CGContextStrokePath(context);
    
    CGRect imgRect = CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height);
    [tmpImage drawInRect:imgRect];
    
    if(tmpShape)
    {
        CGContextSetLineWidth(context, 3.0f);
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        for(int i = 0; i < tmpShape.num_points; ++i)
        {
            CGRect rect = CGRectMake(
                                     tmpShape.shape[i].pos[0]*scale,
                                     tmpShape.shape[i].pos[1]*scale,
                                     5, 5
                                     );
            CGContextFillEllipseInRect(context, rect);
        }
    }
}

@end
