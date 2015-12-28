//
//  SpinGestureRecognizer.m
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/27/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import "SpinGestureRecognizer.h"
// overide state property of gesture
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation SpinGestureRecognizer

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[event touchesForGestureRecognizer:self] count] > 1) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
    }
    else {
        self.state = UIGestureRecognizerStateChanged;
    }
    
    UITouch *touch = [touches anyObject];
    UIView *viewTouched = touch.view;
    
    CGPoint center = CGPointMake(CGRectGetMidX(viewTouched.bounds), CGRectGetMidY(viewTouched.bounds));
    CGPoint currentTouchPoint = [touch locationInView:viewTouched];
    CGPoint previousTouchPoint = [touch previousLocationInView:viewTouched];
    
    CGPoint line2Start = currentTouchPoint;
    CGPoint line1Start = previousTouchPoint;
    CGPoint line2End = CGPointMake(center.x + (center.x - line2Start.x),
                                   center.y + (center.y - line2Start.y));
    CGPoint line1End = CGPointMake(center.x + (center.x - line1Start.x),
                                   center.y + (center.y - line1Start.y));
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    CGFloat line1Slope = (line1End.y - line1Start.y) / (line1End.x - line1Start.x);CGFloat line2Slope = (line2End.y - line2Start.y) / (line2End.x - line2Start.x);
    CGFloat degs = acosf(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    CGFloat angleInRadians = (line2Slope > line1Slope) ? degs : -degs;
    
    self.rotation =  angleInRadians;
    
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateEnded;
}

-(void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateFailed;
}
@end
