//
//  ViewShape.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewFace.h"

@implementation ViewFace

@synthesize scale;
@synthesize touchRadius;
@synthesize drawShape;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        activeTouches = [[NSMutableArray alloc] init];
        scale = 1;
        drawShape = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        activeTouches = [[NSMutableArray alloc] init];
        scale = 1;
        drawShape = YES;
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"ViewFace Dealloc");
}


- (void)setImage:(UIImage*)img
{
    
    if(img.size.width == self.frame.size.width && img.size.width == self.frame.size.width)
    {
        tmpImage = img;
    }
    else 
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
    [self setNeedsDisplay];
}


- (void)setShape:(PDMShape *)shape
{
    tmpShape = shape;
    [self setNeedsDisplay];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect imgRect = CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height);
    [tmpImage drawInRect:imgRect];

    
    if(tmpShape && drawShape)
    {
        const point_info_t *pointInfo = [tmpShape.pointsInfo getPointInfo];
        for(int i = 0; i < tmpShape.num_points; ++i)
        {
            if(pointInfo[i].isVisible == 0)
                continue;
            
            // draw connection
            CGContextSetLineWidth(context, 1.5f);
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            
            int cFrom = pointInfo[i].pointNr;
            int cTo = pointInfo[i].connectionTo;
            
            CGPoint p1 = CGPointMake(tmpShape.shape[cFrom].pos[0]*scale, tmpShape.shape[cFrom].pos[1]*scale);
            CGPoint p2 = CGPointMake(tmpShape.shape[cTo].pos[0]*scale, tmpShape.shape[cTo].pos[1]*scale);
            
            CGContextMoveToPoint(context, p1.x, p1.y);
            CGContextAddLineToPoint(context, p2.x, p2.y);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathStroke);
            
            
            // draw point
            CGContextSetLineWidth(context, 3.0f);
            CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGRect rect1 = CGRectMake(p1.x-2.5, p1.y-2.5, 5, 5);
            CGContextFillEllipseInRect(context, rect1);
            
            // draw point
            CGContextSetLineWidth(context, 3.0f);
            CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            CGRect rect2 = CGRectMake(p1.x-2, p1.y-2, 4, 4);
            CGContextFillEllipseInRect(context, rect2);
        }
    }
    
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5);
    for (UITouch *touch in activeTouches) {
        CGPoint p = [touch locationInView:self];
        NSLog(@"point in view = [%f, %f], radius = %f", p.x, p.y, touchRadius);
        CGContextFillEllipseInRect(context, CGRectMake(p.x-touchRadius, p.y-touchRadius, 2*touchRadius, 2*touchRadius));
    }
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5);
    for (UITouch *touch in activeTouches) {
        CGPoint p = [touch locationInView:self];
        CGContextFillEllipseInRect(context, CGRectMake(p.x-touchRadius/2, p.y-touchRadius/2, touchRadius, touchRadius));
    }
    
}


- (void)addTouch:(UITouch*)touch
{
    NSLog(@"addig touch");
    [activeTouches addObject:touch];
}

- (void)removeTouch:(UITouch*)touch
{
    NSLog(@"removeing touch");
    [activeTouches removeObject:touch];
}



@end
