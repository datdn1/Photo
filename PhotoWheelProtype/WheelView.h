//
//  WheelView.h
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/26/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WheelViewCell;
@class WheelView;

typedef enum {
    WheelViewStyleWheel = 0,
    WheelViewStyleCarousel = 1
} WheelViewStyle;

@protocol WheelViewDataSource <NSObject>
@required
-(NSInteger) numberOfCellsOnWheel;
-(WheelViewCell *) wheelView: (WheelView *)wheelView cellAtIndex:(NSInteger)index;
@end


@interface WheelView : UIView
@property (nonatomic, weak) IBOutlet id<WheelViewDataSource> dataSource;
@property (nonatomic, assign) WheelViewStyle style;
@end

@interface WheelViewCell : UIView

@end
