//
//  MasterViewController.h
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/25/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSMutableArray *photoAlbum;


@end

