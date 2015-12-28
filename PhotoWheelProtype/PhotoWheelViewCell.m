//
//  PhotoWheelViewCell.m
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/27/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import "PhotoWheelViewCell.h"

@implementation PhotoWheelViewCell

//- (void)drawRect:(CGRect)rect {
//}

-(void) setImage:(UIImage *)image {
    CALayer *layer = self.layer;
    [layer setContents:(__bridge id)image.CGImage];
    
    [layer setBorderColor:[UIColor colorWithWhite:1.0 alpha:1.0].CGColor];
    [layer setBorderWidth:5.0];
    [layer setShadowOffset:CGSizeMake(0, 5)];
    [layer setShadowOpacity:0.7];
    [layer setShouldRasterize:YES];
}


@end
