//
//  ViewController.m
//  TestApp
//
//  Created by Arun on 12/09/15.
//  Copyright (c) 2015 Arun. All rights reserved.
//

#import "ViewController.h"
#import "UIView+AutolayoutHelper.h"
#import "ContentsTableViewCell.h"
#import "ServiceHelper.h"
#import "FeedsData.h"
#import "Reachability.h"
#import "ConstantFile.h"


@interface ViewController ()
{
    NSMutableArray *feedsArray;
    UIActivityIndicatorView *activityIndicator;
    ContentsTableViewCell *cell;
    
}

@property(strong, nonatomic) NSMutableArray *feedsArray;


@end

@implementation ViewController

@synthesize feedsTable;
@synthesize feedsArray;

#pragma mark - ==========UIViewController Delegates Methods==============
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=kTitle;
    
    feedsArray=[[NSMutableArray alloc]init];
    
    self.feedsTable = [[UITableView alloc]init];
    
    self.feedsTable.delegate=self;
    self.feedsTable.dataSource=self;
    self.feedsTable.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.feedsTable];
    [self.view fixLayout:self.feedsTable];
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.color=[UIColor blackColor];
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:activityIndicator];
    [self.view fixLayout:activityIndicator];
    
    activityIndicator.hidden=YES;
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:kTitleRefreshBtn
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(getDataFromServer)];
    self.navigationItem.rightBarButtonItem = flipButton;
    
    self.feedsTable.estimatedRowHeight = kTableRowHeight;
    
    self.feedsTable.rowHeight = UITableViewAutomaticDimension;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.feedsTable.rowHeight = UITableViewAutomaticDimension;
    
    [self getDataFromServer];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.feedsTable reloadData];
}



#pragma mark - ==========Webservice call and Data consuming on UI==============

-(void)getDataFromServer
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    BOOL isConnectedToInternet = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    self.view.userInteractionEnabled=NO;
    if (isConnectedToInternet) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
            feedsArray=[ServiceHelper feedList:^(NSError *error){
            }];;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                [activityIndicator stopAnimating];
                activityIndicator.hidden = YES;
                self.view.userInteractionEnabled=YES;
                [self.feedsTable reloadData];
            });
        });
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kErrorMessageTitle message:kErrorMessageForNetworkConnection delegate:self cancelButtonTitle:kTextOK otherButtonTitles:nil];
        [alert show];
    }
    
}


#pragma mark - ==========UITableView Delegats Methods====================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // The number of sections is based on the number of items in the data property list.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return feedsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedsData *feedsDetail=[feedsArray objectAtIndex:indexPath.row];
    CGRect textHeight = [feedsDetail.feedDescription boundingRectWithSize:CGSizeMake(self.view.frame.size.width-160, 0)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                  context:nil];
    if (textHeight.size.height<50) {
        return kTableRowHeight-50;
    }else if (textHeight.size.height<110) {
        return kTableRowHeight;
    }else
    {
        return textHeight.size.height+40;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cellObj forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    [cellObj setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    
    grad.frame = cellObj.bounds;
    
    grad.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    
    [cellObj setBackgroundView:[[UIView alloc] init]];
    
    [cellObj.backgroundView.layer insertSublayer:grad atIndex:0];
    
    CAGradientLayer *selectedGrad = [CAGradientLayer layer];
    
    selectedGrad.frame = cellObj.bounds;
    
    selectedGrad.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    
    [cellObj setSelectedBackgroundView:[[UIView alloc] init]];
    
    [cellObj.selectedBackgroundView.layer insertSublayer:selectedGrad atIndex:0];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = kCellIdentifier;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.backgroundColor=[UIColor clearColor];
    
    if (cell == nil)
    {
        cell = [[ContentsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    cell.itemTitle.preferredMaxLayoutWidth = CGRectGetWidth(cell.itemTitle.frame);
    cell.itemDescription.preferredMaxLayoutWidth = CGRectGetWidth(cell.itemDescription.frame);
    
    if (indexPath.row<[self.feedsArray count]) {
        FeedsData *feedsDetail=[feedsArray objectAtIndex:indexPath.row];
        
        // set default user image while image is being downloaded
        [cell.itemImage setImage:[UIImage imageNamed:kErrorImage]];
        
        if (feedsDetail.downloadedImage) {
            cell.itemImage.image = feedsDetail.downloadedImage;
        } else {
            // download the image asynchronously
            if (feedsDetail.feedImageUrl.length==0) {
                cell.itemImage.image=[UIImage imageNamed:kErrorImage];
                feedsDetail.downloadedImage=[UIImage imageNamed:kErrorImage];
            }else
            {
                NSURL *imageURL = [NSURL URLWithString:feedsDetail.feedImageUrl];
                [ServiceHelper downloadImageURL:imageURL completion:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        // change the image in the cell
                        cell.itemImage.image = image;
                        
                        feedsDetail.downloadedImage=image;
                    }
                }];
            }
        }
        
        [cell.itemTitle setText:feedsDetail.feedTitle];
        [cell.itemDescription setText:feedsDetail.feedDescription];
        
    }
    
    return cell;
}

-(void)OrientationDidChange:(NSNotification*)notification

{
    UIDeviceOrientation Orientation=[[UIDevice currentDevice]orientation];
    
    if(Orientation==UIDeviceOrientationLandscapeLeft || Orientation==UIDeviceOrientationLandscapeRight)
    {
        [self.feedsTable reloadData];
    }else if(Orientation==UIDeviceOrientationPortrait)
    {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
