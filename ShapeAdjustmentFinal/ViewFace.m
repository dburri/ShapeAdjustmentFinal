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
    [activeTouches addObjectsFromArray:[touches allObjects]];
    
    int touchesCount = [activeTouches count];
    NSLog(@"Touch Count = %i", touchesCount);
    
    
    if(touchesCount == 1 && touchMode == TOUCH_NONE)
    {
        touchMode = TOUCH_TRANSLATE_SHAPE;
        UITouch * touch = [touches anyObject];
        touchStartPos = [touch locationInView:self];
    }
    
    if(touchesCount == 2 && touchMode == TOUCH_NONE)
    {
        touchMode = TOUCH_SCALE_SHAPE;
        UITouch *touch1 = [activeTouches objectAtIndex:0];
        UITouch *touch2 = [activeTouches objectAtIndex:1];
        
        CGPoint p1 = [touch1 locationInView:self];
        CGPoint p2 = [touch2 locationInView:self];
        
        touchStartDistance = sqrtf( powf(p1.x-p2.x,2) + powf(p1.y-p2.y,2));
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
        
        float touchDistance = sqrtf( powf(p1.x-p2.x,2) + powf(p1.y-p2.y,2));
        float s = touchDistance/touchStartDistance;
        
        [face.shape setNewShapeData:tmpShape];
        CGPoint center = [face.shape getCenterOfGravity];
        [face.shape translate:-center.x :-center.y];
        [face.shape scale:s];
        [face.shape translate:center.x :center.y];
    }
    
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch endend...");
    NSArray *touchesArray = [touches allObjects];
    
    for(NSInteger j = 0; j < [touchesArray count]; ++j)
    {
        for(NSInteger i = [activeTouches count]-1; i >= 0 ; --i)
        {
            if([activeTouches objectAtIndex:i] == [touchesArray objectAtIndex:j]) {
                NSLog(@"remove touch!!!");
                [activeTouches removeObjectAtIndex:i];
            }
        }
    }
    
    [tmpShape setNewShapeData:face.shape];
    
    touchMode = TOUCH_NONE;
    
    //if([activeTouches count] < 2)
    //    touchMode = TOUCH_TRANSLATE_SHAPE;
    //if([activeTouches count] < 1)
    //    touchMode = TOUCH_NONE;
    
}

@end
