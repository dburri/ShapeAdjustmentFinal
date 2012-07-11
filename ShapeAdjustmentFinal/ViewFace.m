//
//  ViewShape.m
//  ShapeAdjustment2
//
//  Created by DINA BURRI on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewFace.h"

@implementation ViewFace

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"ViewFace:initWithFrame");
        activeTouches = [[NSMutableArray alloc] init];
        tmpShape = [PDMShape alloc];
        //[self setMultipleTouchEnabled:YES];
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
        //[self setMultipleTouchEnabled:YES];
    }
    return self;
}


- (void)dealloc
{
    face = nil;
}


- (void)setNewFace:(Face*)f
{
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
    
    [tmpShape setNewShapeData:face.shape];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //NSLog(@"Draw Rect");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationLow);
    
//    float xf = face.image.size.width/rect.size.width;
//    float yf = face.image.size.height/rect.size.height;
//    float m = MIN(xf, yf);
//    xf /= m;
//    yf /= m;
//    CGContextTranslateCTM(context, 0, rect.size.height);
//    CGContextScaleCTM(context, xf, -yf);
    
    
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
    

//    CGContextSetLineWidth(context, 3.0f);
//    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
//    CGContextAddRect(context,CGRectMake(80, 80, 120, 120));
//    CGContextStrokePath(context);
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
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(touchMode == TOUCH_TRANSLATE_SHAPE)
    {
        NSLog(@"Translate shape!!!");
        UITouch *touch = [activeTouches objectAtIndex:0];
        CGPoint p = [touch locationInView:self];
        
        float dx = (p.x-touchStartPos.x)/scale;
        float dy = -(p.y-touchStartPos.y)/scale;
        
        [face.shape setNewShapeData:tmpShape];
        [face.shape translate:dx :dy];
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
        float dy = -(p.y-touchStartPos.y)/scale;
        
        float touchDistance = sqrtf( powf(p1.x-p2.x,2) + powf(p1.y-p2.y,2));
        float s = touchDistance/touchStartDistance;
        float touchAngle = atan2f(p1.x-p2.x, p1.y-p2.y);
        float a = touchAngle - touchStartAngle;
        NSLog(@"Angle = %f", a);
        
        [face.shape setNewShapeData:tmpShape];
        CGPoint center = [face.shape getCenterOfGravity];
        [face.shape translate:-center.x :-center.y];
        [face.shape scale:s];
        [face.shape rotate:a];
        [face.shape translate:center.x+dx :center.y+dy];
    }
    
    [self setNeedsDisplay];
    
}

// touch ended
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
    [tmpShape setNewShapeData:face.shape];
}

@end
