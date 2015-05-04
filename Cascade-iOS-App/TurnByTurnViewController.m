//
//  TurnByTurnViewController.m
//  Cascade-iOS-App
//
//  Created by iGuest on 5/3/15.
//  Copyright (c) 2015 Cascade. All rights reserved.
//

#import "TurnByTurnViewController.h"
#import "DataManager.h"
#import "TurnByTurnTableViewCell.h"


@interface TurnByTurnViewController ()

@property (nonatomic,strong) NSArray *turns;
@property (strong, nonatomic) DataManager *dm;

@end

@implementation TurnByTurnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selfViewWidth = self.view.frame.size.width;
    selfViewHeight = self.view.frame.size.height;
    
    [self setBackground];
    [tableView reloadData];
    
    NSString *turnByTurn = [self.routedb valueForKey:@"turnByTurnText"];
    self.turns = [turnByTurn componentsSeparatedByString:@";"];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, 60)];
    [self.view addSubview:navBar];
    
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //backButton.bounds = CGRectMake( 0, 0, backImage.size.width, backImage.size.height );
    [backButton setFrame:CGRectMake(0, 0, navBar.frame.size.height/3, navBar.frame.size.height/2.5)];
    [backButton setImage:backImage forState:UIControlStateNormal];
    //[backButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:nil];
    item.leftBarButtonItem = backButtonItem;
    [navBar pushNavigationItem:item animated:NO];
    
}

- (void)setBackground {

    tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    //self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    //[self.view addSubview:self.tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    self.dm = [[DataManager alloc] init];
    UIImage *backgroundImage = [self.dm loadImage:[self.routedb valueForKey:@"title"]];
    
    CGRect croprect = CGRectMake(backgroundImage.size.width/6, 0 , backgroundImage.size.height/2, backgroundImage.size.height);
    //Draw new image in current graphics context
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([backgroundImage CGImage], croprect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    UIImageView * backgroundView  =[[UIImageView alloc]initWithImage:croppedImage];
    //[backgroundView setImage:croppedImage];
    //[self.view addSubview:backgroundView];
    //self.tableView.backgroundColor = [UIColor clearColor];
    //self.tableView.opaque = YES;
    tableView.backgroundView = backgroundView;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTableView:(UITableView *)tableView{
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.turns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.alpha = 0;
    
    NSString *turn = [self.turns objectAtIndex:indexPath.row];
    
    cell.userInteractionEnabled = NO;
    [cell.textLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
    if ([turn containsString:@"Start"] || [turn containsString:@"End"] || ![turn containsString:@"&"])
    {
        //cell.textLabel.text = turn;
        //cell.detailTextLabel.text = nil;
        cell.textLabel.text = turn;
        cell.detailTextLabel.text = nil;
        return cell;
    }
    NSArray *arr = [[self.turns objectAtIndex:indexPath.row] componentsSeparatedByString:@"&"];
    cell.textLabel.text = [arr objectAtIndex:0];
    cell.detailTextLabel.text = [arr objectAtIndex:1];
    
    // Configure the cell...
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset1 = scrollView.contentOffset;
    CGRect bounds1 = scrollView.bounds;
    CGSize size1 = scrollView.contentSize;
    UIEdgeInsets inset1 = scrollView.contentInset;
    float y1 = offset1.y + bounds1.size.height - inset1.bottom;
    NSLog(@"%f", y1);
    //float h1 = size1.height;
    NSLog(@"%f", tableView.frame.size.height / 6 * 5);
    if (y1 < 450) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
