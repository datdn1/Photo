//
//  DetailViewController.m
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/25/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import "DetailViewController.h"
#import "WheelView.h"
#import "PhotoWheelViewCell.h"

@interface DetailViewController () <WheelViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) PhotoWheelViewCell *selectedPhotoWheelViewCell;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

-(NSArray *) data {
    if (!_data) {
        _data = [[NSArray alloc] init];
    }
    return _data;
}
- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    UIFontDescriptor *fontDescriptor = [self.detailDescriptionLabel.font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic];
//    self.detailDescriptionLabel.font = [UIFont fontWithDescriptor:fontDescriptor size:0];
//    self.detailDescriptionLabel.textColor = [UIColor redColor];
//    [self configureView];
    
    CGRect frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    NSInteger numberCells = 15;
    NSMutableArray *cells = [[NSMutableArray alloc] initWithCapacity:numberCells];
    UIImage *image= [UIImage imageNamed:@"defaultPhoto"];
    
    for (int i = 0; i < numberCells; i++) {
        PhotoWheelViewCell *cell = [[PhotoWheelViewCell alloc] initWithFrame:frame];
        [cell setImage:image];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHandler:)];
        doubleTap.numberOfTapsRequired = 2;
        [cell addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedHandler:)];
        [tap requireGestureRecognizerToFail:doubleTap];
        [cell addGestureRecognizer:tap];
        
        [cells addObject:cell];
    }
    self.data = [cells copy];
    
    NSArray *items = @[@"Wheel", @"Carousel"];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:items];
    [segmentControl addTarget:self action:@selector(changeWheelStyle:) forControlEvents:UIControlEventValueChanged];
    segmentControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentControl;
    
}

-(void) tapedHandler: (UITapGestureRecognizer *)gesture {
    NSLog(@"Tap in  gesture!!!");
    self.selectedPhotoWheelViewCell = (PhotoWheelViewCell *)gesture.view;
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        [self presentPhotoPickerMenu];
    }
    else {
        [self presentPhotoLibrary];
    }
}

-(void) presentPhotoPickerMenu {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIAlertController *menuSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *librarySourceAction = [UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self presentPhotoLibrary];
    }];
    
    UIAlertAction *cameraSourceAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self presentCamera];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [menuSheet addAction:librarySourceAction];
    [menuSheet addAction:cameraSourceAction];
    [menuSheet addAction:cancelAction];
    
    if (menuSheet.popoverPresentationController != nil) {
        menuSheet.popoverPresentationController.sourceView = self.selectedPhotoWheelViewCell;
        menuSheet.popoverPresentationController.sourceRect = self.selectedPhotoWheelViewCell.frame;
    }
    [self presentViewController:menuSheet animated:true completion:nil];
}

-(void) presentCamera {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.delegate = self;
    pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerImage animated:true completion:nil];
}

-(void) presentPhotoLibrary {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.delegate = self;
    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
//    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:pickerImage];
//    [popover presentPopoverFromRect:self.selectedPhotoWheelViewCell.bounds inView:self.selectedPhotoWheelViewCell permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
    pickerImage.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = pickerImage.popoverPresentationController;
    if (popover != nil) {
        popover.sourceRect = self.selectedPhotoWheelViewCell.bounds;
        popover.sourceView = self.selectedPhotoWheelViewCell;
    }
    [self presentViewController:pickerImage animated:true completion:nil];
}

-(void) doubleTapHandler: (UITapGestureRecognizer *)gesture {
    NSLog(@"Double tap in  gesture!!!");
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil);
    }
    [self.selectedPhotoWheelViewCell setImage:selectedImage];
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:true completion:nil];
}



-(void) changeWheelStyle: (UISegmentedControl *)segmentControl {
    NSInteger seletedIndex = segmentControl.selectedSegmentIndex;
    if (seletedIndex == WheelViewStyleWheel) {
        self.wheelView.style = WheelViewStyleWheel;
    }
    else {
        self.wheelView.style = WheelViewStyleCarousel;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfCellsOnWheel {
    return self.data.count;
}

-(WheelViewCell *) wheelView:(WheelView *)wheelView cellAtIndex:(NSInteger)index {
    return self.data[index];
}

@end
