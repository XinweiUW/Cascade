//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuTableViewCell.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
/*#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"*/

@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	
	return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    //NSString *file = @(__FILE__);
    //file = [[file stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"/iconimg/CascadeLogo.png"];
    
    //NSData *data = [NSData data:[NSURL URLWithString:file]];
    //UIImage *myImage = [UIImage imageNamed:@"CascadeLogo.png"];
    //myImage.size = CGRectMake(0, 0, 50, 50);
    //UIView *imageView = [[UIImageView alloc] initWithImage:myImage];
    //imageView.backgroundColor = [UIColor redColor];
    //imageView.frame = CGRectMake(0, 0, 500, 100);
    //[self.tableView addSubview:imageView];
	
	//self.tableView.separatorColor = [UIColor lightGrayColor];
	
	//UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
	//self.tableView.backgroundView = imageView;
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4;
}

/*- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
	view.backgroundColor = [UIColor clearColor];
	return view;
    
    UIImage *myImage = [UIImage imageNamed:@"CascadeLogo.png"];
    UIView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(0, 0, 0, 0);
    return imageView;
    
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    //cell.logoViewImage.center = CGPointMake(cell.bounds.size.width / 2, cell.bounds.size.height / 2);
    if (indexPath.row != 0) {
        cell.logoViewImage.hidden = true;
    }
	switch (indexPath.row)
	{
        case 0:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
		case 1:
			cell.textLabel.text = @"Home";
			break;
			
		case 2:
			cell.textLabel.text = @"About";
			break;
			
		case 3:
			cell.textLabel.text = @"Safety Tip";
			break;
			
		//case 4:
			//cell.textLabel.text = @"Settings";
			//break;
	}
	
	cell.backgroundColor = [UIColor clearColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle: nil];
	
	UIViewController *vc ;
	
	switch (indexPath.row)
	{
        case 0:
            return;
		case 1:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"LandingTableViewController"];
			break;
			
		case 2:
			vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AboutViewController"];
			break;
        
        case 3:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TipViewController"];
            break;
        
        //case 4:
            //vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"SettingsViewController"];
            //break;
		//case 3:
			//[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
			//[[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
			//return;
		//	break;
	}
	
	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:nil];
}

@end
