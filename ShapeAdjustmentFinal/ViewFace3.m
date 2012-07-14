//
//  ViewFace3.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewFace3.h"

@implementation ViewFace3

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setNewFace:(Face*)f
{
    NSLog(@"ViewFace3:setNewFace");
    face = f;
    
    CGSize viewSize = self.frame.size;
    
    float s1 = face.image.size.width/viewSize.width;
    float s2 = face.image.size.height/viewSize.height;
    scale = 1/MAX(s1,s2);
    
    CGSize imgSize = CGSizeMake(scale*face.image.size.width, scale*face.image.size.height);
    
    UIGraphicsBeginImageContext(imgSize);
    [face.image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


- (void)updateShape:(PDMShape*)s
{
    face.shape = s;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"draw rect in viewface2");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect imgRect = CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height);
    [tmpImage drawInRect:imgRect];
    
    if(face.shape)
    {
        CGContextSetLineWidth(context, 3.0f);
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        for(int i = 0; i < face.shape.num_points*3; i+=3)
        {
            CGPoint p = CGPointMake(face.shape.shape[i]*scale, face.shape.shape[i+1]*scale);
            CGContextFillEllipseInRect(context, CGRectMake(p.x, self.frame.size.height-p.y, 5, 5));
            //NSLog(@"x = %f, y = %f", p.x, p.y);
        }
    }

    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextAddRect(context,CGRectMake(100, 200, 120, 220));
    CGContextStrokePath(context);
}


@end
