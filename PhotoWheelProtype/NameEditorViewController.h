//
//  NameEditorViewController.h
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/26/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NameEditorViewController;
@protocol NameEditorViewControllerDelegate <NSObject>
@optional
-(void) didCancel: (NameEditorViewController *) nameEditorVc;
-(void) nameEditorVc: (NameEditorViewController *) nameEditor didDone: (NSString *)nameAlbum;
-(void) nameEditorViewControllerDidEditName: (NameEditorViewController *)nameEditor withNewName: (NSString *)newName forRowIndexPath: (NSIndexPath *)row;
@end

@interface NameEditorViewController : UIViewController
@property (copy, nonatomic) NSString* name;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) id<NameEditorViewControllerDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *editedIndexPath;
@end
