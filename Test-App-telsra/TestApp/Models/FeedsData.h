//
//  AppDelegate.h
//  TestApp
//
//  Created by Arun on 12/09/15.
//  Copyright (c) 2015 Arun. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FeedsData : NSObject
{

}

@property(strong, nonatomic) NSString *feedTitle;
@property(strong, nonatomic) NSString *feedImageUrl;
@property(strong, nonatomic) NSString *feedDescription;
@property(strong, nonatomic) UIImage *downloadedImage;
@end
