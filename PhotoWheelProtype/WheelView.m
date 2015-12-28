//
//  WheelView.m
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/26/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import "WheelView.h"
#import "SpinGestureRecognizer.h"

@interface WheelView()
@property (nonatomic, assign) CGFloat currentAngle;

@end

@implementation WheelView

-(void) commonInit {
    self.currentAngle = 0.0;
    SpinGestureRecognizer *spin = [[SpinGestureRecognizer alloc] initWithTarget:self action:@selector(spinHandler:)];
    [self addGestureRecognizer:spin];
}

-(instancetype) init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

-(void) spinHandler: (SpinGestureRecognizer *) gesture {
    CGFloat angleInRadians = -[gesture rotation];
    CGFloat degrees = 180.0 * angleInRadians / M_PI;
    [self setCurrentAngle:[self currentAngle] + degrees];
    [self setAngle:[self currentAngle]];
}

-(void) setAngle: (CGFloat) angle {
    CGPoint wheelCenterPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radiusX = MIN(self.bounds.size.width, self.bounds.size.height) * 0.35;
    CGFloat radiusY = radiusX;
    
    if (self.style == WheelViewStyleCarousel) {
        radiusY = 0.3 * radiusX;
    }
    
    NSInteger numberCells = [self.dataSource numberOfCellsOnWheel];
    float angleToAdd = 360.0 / numberCells;
    
    for(int i = 0; i < numberCells; i++) {
        WheelViewCell *cell = [self.dataSource wheelView:self cellAtIndex:i];
        if ([cell superview] == nil) {
            [self addSubview:cell];
        }
        
        float angleInRadians = (angle + 180.0) * M_PI / 180.0;
        float xPosition = wheelCenterPoint.x + (radiusX * sinf(angleInRadians)) - (CGRectGetWidth([cell frame]) / 2);
        float yPosition = wheelCenterPoint.y + (radiusY * cosf(angleInRadians)) - (CGRectGetHeight([cell frame]) / 2);
        float scale = 0.75 + 0.25 * (cosf(angleInRadians) + 1.0);
        
        if (self.style == WheelViewStyleCarousel) {
            cell.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(xPosition, yPosition), scale, scale);
            cell.alpha = 0.3 + 0.5 * (cosf(angleInRadians) + 1.0);
        }
        else {
            cell.transform = CGAffineTransformMakeTranslation(xPosition, yPosition);
            cell.alpha = 1.0;
        }
        
        cell.layer.zPosition = scale;
        angle += angleToAdd;
    }
}

-(void) layoutSubviews {
    [self setAngle:self.currentAngle];
}

-(void) setStyle:(WheelViewStyle)style {
    if (_style != style) {
        _style = style;
        [UIView beginAnimations:@"WheelViewStyleChange" context:nil];
        [self setAngle:0.0];
        [UIView commitAnimations];
    }
}

@end

@implementation WheelViewCell

@end
