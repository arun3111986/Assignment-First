//
//  ViewController.h
//  TestApp
//
//  Created by Arun on 12/09/15.
//  Copyright (c) 2015 Arun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
   
}
@property(strong, nonatomic) UITableView *feedsTable;

@end

