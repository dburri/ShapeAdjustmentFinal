//
//  ViewShape.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewFace.h"

@implementation ViewFace

@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"ViewFace:initWithFrame");
        activeTouches = [[NSMutableArray alloc] init];
        tmpShape = [PDMShape alloc];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        NSLog(@"ViewFace:initWithCoder");
        activeTouches = [[NSMutableArray alloc] init];
        tmpShape = [PDMShape alloc];
    }
    return self;
}


- (void)dealloc
{
    
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


- (void)setFaceShapeParams:(PDMShape*)shape :(PDMTMat*)TMat
{
    origShape = shape;
    origTMat = TMat;
    
    tmpShape = [origShape getCopy];
    [tmpShape transformAffineMat:origTMat];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{   
    NSArray *touchesArray = [touches allObjects];
    for(NSInteger j = 0; j < [touchesArray count]; ++j) {
        if (![activeTouches containsObject:[touchesArray objectAtIndex:j]]) {
            [activeTouches addObject:[touchesArray objectAtIndex:j]];
        };
    }
    
    int touchesCount = [activeTouches count];
    NSLog(@"Touch Count = %i", touchesCount);
    
    if(touchesCount == 1) {
        firstTouchStart = [NSDate date];
    }
    NSDate *touchTime = [NSDate date];
    double dt = [touchTime timeIntervalSinceDate:firstTouchStart];

    
    if(touchesCount == 1 && touchMode == TOUCH_NONE)
    {
        NSLog(@"set mode to translate");
        touchMode = TOUCH_TRANSLATE_SHAPE;
        UITouch * touch = [touches anyObject];
        touchStartPos = [touch locationInView:self];
    }
    
    if(touchesCount == 2 && dt < 0.5)
    {
        NSLog(@"set mode to scale");
        touchMode = TOUCH_SCALE_SHAPE;
        UITouch *touch1 = [activeTouches objectAtIndex:0];
        UITouch *touch2 = [activeTouches objectAtIndex:1];
        
        CGPoint p1 = [touch1 locationInView:self];
        CGPoint p2 = [touch2 locationInView:self];
        
        touchStartPos = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
        touchStartDistance = sqrtf( powf(p1.x-p2.x,2) + powf(p1.y-p2.y,2));
        touchStartAngle = atan2f(p1.x-p2.x, p1.y-p2.y);
    }
    
    tmpTMat = [[PDMTMat alloc] initWithMat:origTMat];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchMode == TOUCH_TRANSLATE_SHAPE)
    {
        NSLog(@"Translate shape!!!");
        UITouch *touch = [activeTouches objectAtIndex:0];
        CGPoint p = [touch locationInView:self];
        
        float dx = (p.x-touchStartPos.x)/scale;
        float dy = (p.y-touchStartPos.y)/scale;
        
        PDMTMat *matT = [[PDMTMat alloc] initWithTranslate:dx :dy];
        tmpTMat = [origTMat multiply:matT];
    }
    
    else if(touchMode == TOUCH_SCALE_SHAPE)
    {
        NSLog(@"Scale shape!!!");
    
        UITouch *touch1 = [activeTouches objectAtIndex:0];
        UITouch *touch2 = [activeTouches objectAtIndex:1];
        
        CGPoint p1 = [touch1 locationInView:self];
        CGPoint p2 = [touch2 locationInView:self];
        CGPoint p = CGPointMake((p1.x+p2.x)/2, (p1.y+p2.y)/2);
        
        float dx = (p.x-touchStartPos.x)/scale;
        float dy = (p.y-touchStartPos.y)/scale;
        
        float touchDistance = sqrtf( powf(p1.x-p2.x,2) + powf(p1.y-p2.y,2));
        float s = touchDistance/touchStartDistance;
        float touchAngle = atan2f(p1.x-p2.x, p1.y-p2.y);
        float a = touchStartAngle - touchAngle;
        //NSLog(@"Angle = %f", a);
        
        PDMTMat *matSRT = [[PDMTMat alloc] initWithSRT:s :a :dx :dy];
        tmpTMat = [origTMat multiplyPreservingTranslation:matSRT];
    }
    
    [tmpShape setNewShapeData:origShape];
    [tmpShape transformAffineMat:tmpTMat];
    
    [self setNeedsDisplay];
    
}

/**
 Called when a touch ends
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // remove the touch from the list of active touches
    NSArray *touchesArray = [touches allObjects];
    for(NSInteger j = 0; j < [touchesArray count]; ++j) {
        NSUInteger ind = [activeTouches indexOfObject:[touchesArray objectAtIndex:j]];
        
        if(ind == 0 && touchMode == TOUCH_TRANSLATE_SHAPE)
            touchMode = TOUCH_NONE;
        
        if((ind == 0 || ind == 1) && touchMode == TOUCH_SCALE_SHAPE)
            touchMode = TOUCH_NONE;

        if(ind != NSNotFound)
            [activeTouches removeObjectAtIndex:ind];
    }
    
    origTMat = tmpTMat;
    [delegate updateShapeParameter:self newParams:origTMat];
}

@end
