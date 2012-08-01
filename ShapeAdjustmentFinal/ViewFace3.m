//
//  ViewFace3.m
//  ShapeAdjustmentFinal
//
//  Created by DINA BURRI on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewFace3.h"

@implementation TouchState

@synthesize touch;
@synthesize touchLastPos;
@synthesize touchStartPos;

@end



@implementation ViewFace3

@synthesize delegate;

@synthesize model;
@synthesize param;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"ViewFace:initWithFrame");
        activeTouches = [[NSMutableArray alloc] init];
        radius = 60;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        NSLog(@"ViewFace:initWithCoder");
        activeTouches = [[NSMutableArray alloc] init];
        radius = 60;
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


- (void)setShape:(PDMShape*)s
{
    tmpShape = s;
    [self setNeedsDisplay];
}


- (void)setTouchRadius:(float)rad
{
    radius = rad;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"draw rect in viewface2");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect imgRect = CGRectMake(0, 0, tmpImage.size.width, tmpImage.size.height);
    [tmpImage drawInRect:imgRect];
    
    if(tmpShape)
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
            CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            CGRect rect = CGRectMake(
                                     tmpShape.shape[i].pos[0]*scale-2,
                                     tmpShape.shape[i].pos[1]*scale-2,
                                     4, 4
                                     );
            CGContextFillEllipseInRect(context, rect);
        }
    }
    
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5);
    for (TouchState *touchState in activeTouches) {
        CGPoint p = [touchState.touch locationInView:self];
        CGContextFillEllipseInRect(context, CGRectMake(p.x-radius, p.y-radius, 2*radius, 2*radius));
    }
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5);
    for (TouchState *touchState in activeTouches) {
        CGPoint p = [touchState.touch locationInView:self];
        CGContextFillEllipseInRect(context, CGRectMake(p.x-radius/2, p.y-radius/2, radius, radius));
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{   
    // add touch if this touch does not exist already
    NSArray *touchesArray = [touches allObjects];
    for (UITouch *uiTouch in touchesArray) {
        
        BOOL exists = NO;
        for (TouchState *touchState in activeTouches) {
            if(touchState.touch == uiTouch) {
                exists = YES;
            }
        }
        
        if(exists == NO) {
            TouchState *newTouch = [[TouchState alloc] init];
            
            newTouch.touch = uiTouch;
            newTouch.touchStartPos = [uiTouch locationInView:self];
            newTouch.touchLastPos = [uiTouch locationInView:self];
            
            [activeTouches addObject:newTouch];
        }
    }
    
    int touchesCount = [activeTouches count];
    NSLog(@"Touch Count = %i", touchesCount);
    
    if(touchesCount > 0) {
        touchMode = TOUCH_V3_MODIFY;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchMode == TOUCH_V3_MODIFY)
    {
        for (TouchState *touchState in activeTouches)
        {
            CGPoint p = [touchState.touch locationInView:self];
            
            float dx = (p.x-touchState.touchLastPos.x)/scale;
            float dy = (p.y-touchState.touchLastPos.y)/scale;
            
            // find points to shift
            for(int i = 0; i < tmpShape.num_points; ++i)
            {
                CGPoint ps = CGPointMake(tmpShape.shape[i].pos[0]*scale, tmpShape.shape[i].pos[1]*scale);
                
                float dist2 = ((ps.x - p.x) * (ps.x - p.x) + (ps.y - p.y) * (ps.y - p.y));
                float dist = sqrt(dist2);
                
                
                // move points
                float intensity = 0;
                if(dist < radius)
                {
                    intensity = (radius-dist)/radius;
                    intensity = (intensity < 0 ? 0 : intensity);
                    intensity = (intensity > 1 ? 1 : intensity);
                    tmpShape.shape[i].pos[0] += dx*intensity;
                    tmpShape.shape[i].pos[1] += dy*intensity;
                }
            }
            touchState.touchLastPos = p;
        }
        [delegate shapeModified:tmpShape];
    }
    
}

/**
 Called when a touch ends
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // remove the touch that ended
    NSArray *touchesArray = [touches allObjects];
    for (UITouch *uiTouch in touchesArray) {
        
        for (TouchState *touchState in activeTouches) {
            if(touchState.touch == uiTouch) {
                [activeTouches removeObject:touchState];
                break;
            }
        }
    }
    
    [self setNeedsDisplay];
}


@end
