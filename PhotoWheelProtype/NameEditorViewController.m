//
//  NameEditorViewController.m
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/26/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import "NameEditorViewController.h"

@interface NameEditorViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@end

@implementation NameEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.name) {
        self.navigationBar.items[0].title = NSLocalizedString(@"Edit", @"Edit title");
        self.nameTextField.text = self.name;
    }
    else {
        self.navigationBar.items[0].title = NSLocalizedString(@"Add", @"Add title");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    NSString *newName = self.nameTextField.text;
    if (!self.name) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nameEditorVc:didDone:)]) {
            [self.delegate nameEditorVc:self didDone:newName];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nameEditorViewControllerDidEditName:withNewName:forRowIndexPath:)]) {
            [self.delegate nameEditorViewControllerDidEditName:self withNewName:newName forRowIndexPath:self.editedIndexPath];
        }
    }
}

- (IBAction)cancel:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancel:)]) {
        [self.delegate didCancel:self];
    }
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


@end
