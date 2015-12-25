//
//  DetailViewController.h
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/25/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

