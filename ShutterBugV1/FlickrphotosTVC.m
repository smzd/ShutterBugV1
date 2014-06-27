//
//  FlickrphotosTVC.m
//  Shutterbug
//
//  Created by Sarah Azad on 6/24/14.
//  Copyright (c) 2014 Dumb Donkey. All rights reserved.
//

#import "FlickrphotosTVC.h"
#import "FlickrFetcher.h"
#import "imageViewController.h"
@interface FlickrphotosTVC ()

@end

@implementation FlickrphotosTVC

-(void) setPhotos:(NSArray *)photos{
    
    _photos=photos;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"posted photos" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photo= self.photos[indexPath.row];
    cell.textLabel.text=[photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    cell.detailTextLabel.text=[photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    id detail= self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]])
    {
        detail=[((UINavigationController *)detail).viewControllers firstObject];
    }
    if ([detail isKindOfClass:[imageViewController class]]) {
        [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
    }
    
    
}


-(void) prepareImageViewController:(imageViewController*)ivc toDisplayPhoto:(NSDictionary*) photo{
    ivc.imageURL=[FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
    ivc.title=[photo valueForKeyPath:FLICKR_PHOTO_TITLE ];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexpath=[self.tableView indexPathForCell:sender];
    if (indexpath){
    if ([segue.identifier isEqualToString:@"Display Photos"]) {
        if ([segue.destinationViewController isKindOfClass:[imageViewController class]]) {
            [self prepareImageViewController:segue.destinationViewController toDisplayPhoto:self.photos[indexpath.row]];
        }
        
    }
    }
}


@end
