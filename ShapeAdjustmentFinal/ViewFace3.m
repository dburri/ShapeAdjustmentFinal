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
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        NSLog(@"ViewFace:initWithCoder");
        activeTouches = [[NSMutableArray alloc] init];
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
    faceShape = s;
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
    
    if(faceShape)
    {
        CGContextSetLineWidth(context, 3.0f);
        CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
        for(int i = 0; i < faceShape.num_points; ++i)
        {
            CGRect rect = CGRectMake(
                                     faceShape.shape[i].pos[0]*scale,
                                     faceShape.shape[i].pos[1]*scale,
                                     5, 5
                                     );
            CGContextFillEllipseInRect(context, rect);
        }
    }
    
    CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, 0.5);
    for (TouchState *touchState in activeTouches) {
        CGPoint p = [touchState.touch locationInView:self];
        CGContextFillEllipseInRect(context, CGRectMake(p.x-50, p.y-50, 100, 100));
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
            float rad = 100;
            for(int i = 0; i < faceShape.num_points; ++i)
            {
                CGPoint ps = CGPointMake(faceShape.shape[i].pos[0]*scale, faceShape.shape[i].pos[1]*scale);
                
                float dist2 = ((ps.x - p.x) * (ps.x - p.x) + (ps.y - p.y) * (ps.y - p.y));
                float dist = sqrt(dist2);
                
                
                // move points
                float intensity = 0;
                if(dist < rad)
                {
                    intensity = (rad-dist)/rad;
                    intensity = (intensity < 0 ? 0 : intensity);
                    intensity = (intensity > 1 ? 1 : intensity);
                    faceShape.shape[i].pos[0] += dx*intensity;
                    faceShape.shape[i].pos[1] += dy*intensity;
                }
            }
            touchState.touchLastPos = p;
        }
        [delegate shapeModified:faceShape];
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
