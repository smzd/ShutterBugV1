//
//  imageViewController.m
//  Imaginarium
//
//  Created by Sarah Azad on 6/23/14.
//  Copyright (c) 2014 Dumb Donkey. All rights reserved.
//

#import "imageViewController.h"

@interface imageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>
@property (strong,nonatomic) UIImageView *imageView;

@property (strong,nonatomic) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end

@implementation imageViewController

-(void) setScrollView:(UIScrollView *)scrollView{
    _scrollView=scrollView;
    _scrollView.minimumZoomScale=0.2;
    _scrollView.maximumZoomScale=2.0;
    _scrollView.delegate=self;
    self.scrollView.contentSize= self.image? self.image.size : CGSizeZero;
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
    
}
-(void) setImageURL:(NSURL *)imageURL{
    _imageURL=imageURL;
    [self downloadingImage];
    //self.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]];
    
}
-(void) downloadingImage{
    
    self.image=nil;
    
    if (self.imageURL) {
        [self.spinner startAnimating];
        NSURLRequest *request= [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration= [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session=[NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task=[session downloadTaskWithRequest:request completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
            if (!error) {
            if ([request.URL isEqual:self.imageURL]) {
            UIImage *image= [UIImage imageWithData:[NSData dataWithContentsOfURL:localFile]];
            dispatch_async(dispatch_get_main_queue(), ^{
                 self.image=image;
            });
               
            }
            }
        }];
        [task resume];
    }
    
}

-(UIImageView*) imageView{
    
    if (!_imageView) {
        _imageView=[[UIImageView alloc]init];
        
    }
    return _imageView;
    
}
-(void) setImage:(UIImage *)image{
    self.scrollView.zoomScale=1.0;
    self.imageView.image=image;

    self.imageView.frame=CGRectMake(0, 0,image.size.width,image.size.height);
    self.scrollView.contentSize= self.image? self.image.size: CGSizeZero;
    [self.spinner stopAnimating];
}

-(UIImage*) image{
    
    return self.imageView.image;
}

-(void) viewDidLoad{
    
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    
}
-(void) awakeFromNib{
    
    self.splitViewController.delegate=self;
}

-(BOOL) splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation{
    
    return UIInterfaceOrientationIsPortrait(orientation);
}

-(void) splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc{
    barButtonItem.title=aViewController.title;
    self.navigationItem.leftBarButtonItem=barButtonItem;
    
}

-(void)splitViewController:(UISplitViewController *)svc
    willShowViewController:(UIViewController *)aViewController
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    
    self.navigationItem.leftBarButtonItem=nil;
    
}


@end
