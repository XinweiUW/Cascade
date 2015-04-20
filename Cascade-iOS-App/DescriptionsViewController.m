//
//  DescriptionsViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 3/28/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "DescriptionsViewController.h"

@interface DescriptionsViewController ()

@end

@implementation DescriptionsViewController
@synthesize routedb;

- (void)viewDidLoad {
    //CGFloat selfViewWidth = self.view.frame.size.width;
    //CGFloat selfViewHeight = self.view.frame.size.height;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    //self.navigationController.navigationBar.backItem.title = @"Custom text";
    
    self.dm = [[DataManager alloc] init];
    //UIImage *backgroundImage = [self.dm loadImage:[self.routedb valueForKey:@"title"]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"leftMenu.jpg"]]];
    
    /*
    CGRect croprect = CGRectMake(0, 0 , backgroundImage.size.width, backgroundImage.size.width * selfViewHeight/selfViewWidth);
    
    // Draw new image in current graphics context
    CGImageRef imageRef = CGImageCreateWithImageInRect([backgroundImage CGImage], croprect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [croppedImage drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:croppedImage];
    
    
    UIImageView * backgroundView  =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth, selfViewHeight)];
    backgroundView.contentMode = UIViewContentModeScaleToFill;
    [backgroundView setImage:croppedImage];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundView.image];
    //[self.view addSubview:backgroundView];
    */
     
    if (self.routedb) {
        self.routeTitleLabel.text = [self.routedb valueForKey:@"title"];
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
