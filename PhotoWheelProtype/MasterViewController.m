//
//  MasterViewController.m
//  PhotoWheelProtype
//
//  Created by datdn1 on 12/25/15.
//  Copyright © 2015 datdn1. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NameEditorViewController.h"

@interface MasterViewController () <NameEditorViewControllerDelegate>

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.title = NSLocalizedString(@"Photo Album", @"Photo Album title");
    
    // initialize photo album
    [self.photoAlbum addObject:@"A Sample Photo Album"];
    [self.photoAlbum addObject:@"Another Photo Album"];
}

-(NSMutableOrderedSet *) photoAlbum {
    if (!_photoAlbum) {
        _photoAlbum = [[NSMutableOrderedSet alloc] init];
    }
    return _photoAlbum;
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    // create new name editor view controller
    NameEditorViewController *nameEditorVc = [[NameEditorViewController alloc] init];
    nameEditorVc.modalPresentationStyle = UIModalPresentationFormSheet;
    nameEditorVc.delegate = self;
    [self presentViewController:nameEditorVc animated:true completion:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *photoAlbumName = self.photoAlbum[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:photoAlbumName];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoAlbum.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    cell.showsReorderControl = YES;
    NSString *photoAlbumName = self.photoAlbum[indexPath.row];
    cell.textLabel.text = [photoAlbumName description];
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return NO;
//    }
//    return YES;
//}

-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.photoAlbum.count - 1) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.photoAlbum removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }
}

-(void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.photoAlbum exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
    }];
    editAction.backgroundColor = [UIColor blueColor];
    
    return @[deleteAction, editAction];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(NSIndexPath *) tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row == self.photoAlbum.count - 1) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}


-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NameEditorViewController *nameEditorVc = [[NameEditorViewController alloc] init];
    nameEditorVc.delegate = self;
    NSString *nameForEdit = self.photoAlbum[indexPath.row];
    nameEditorVc.name = nameForEdit;
    nameEditorVc.editedIndexPath = indexPath;
    nameEditorVc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nameEditorVc animated:true completion:nil];
}

-(void) nameEditorViewControllerDidEditName:(NameEditorViewController *)nameEditor withNewName:(NSString *)newName  forRowIndexPath: (NSIndexPath *)row {
    NSLog(@"New edit name  = %@", newName);
    // update row edit
//    self.photoAlbum[row.row] = newName;
    [self.photoAlbum replaceObjectAtIndex:row.row withObject:newName];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[row] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) nameEditorVc:(NameEditorViewController *)nameEditor didDone:(NSString *)nameAlbum {
    NSLog(@"New name = %@", nameAlbum);
    if (nameAlbum && [nameAlbum length] > 0) {
        [self.photoAlbum addObject:nameAlbum];
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void) didCancel:(NameEditorViewController *)nameEditorVc {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
