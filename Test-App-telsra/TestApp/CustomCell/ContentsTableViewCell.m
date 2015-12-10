//
//  AppDelegate.h
//  TestApp
//
//  Created by Arun on 12/09/15.
//  Copyright (c) 2015 Arun. All rights reserved.
//


#import "ContentsTableViewCell.h"
#import "UIView+AutolayoutHelper.h"

@implementation ContentsTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.itemImage = [[UIImageView alloc] init];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self fixLayout:self.contentView];
        
        [self.contentView addSubview:self.itemImage];
        self.itemImage.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.itemTitle = [[UILabel alloc] init];
        self.itemTitle.backgroundColor = [UIColor clearColor];
        self.itemTitle.numberOfLines = 0;
        self.itemTitle.font=[UIFont boldSystemFontOfSize:15];
        self.itemTitle.lineBreakMode = NSLineBreakByWordWrapping;
        self.itemTitle.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.itemTitle];
        self.itemTitle.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.itemDescription = [[UILabel alloc] init];
        self.itemDescription.numberOfLines = 0;
        self.itemDescription.backgroundColor = [UIColor clearColor];
        self.itemDescription.font=[UIFont systemFontOfSize:13];
        self.itemDescription.textAlignment = NSTextAlignmentLeft;
        self.itemDescription.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.itemDescription];
        self.itemDescription.translatesAutoresizingMaskIntoConstraints = NO;
        
        // itemTitle autolayouts
        float padding = 5.0;
                
        
        NSLayoutConstraint * titleWidthConstraint = [NSLayoutConstraint constraintWithItem:self.itemTitle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.itemImage attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        
        NSLayoutConstraint * titelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.itemTitle attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:40];
        
        NSLayoutConstraint * titelTopConstraint = [NSLayoutConstraint constraintWithItem:self.itemTitle attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        NSLayoutConstraint * titelleftConstraint = [NSLayoutConstraint constraintWithItem:self.itemTitle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:padding];
        
        [self.contentView addConstraints:@[titelHeightConstraint, titleWidthConstraint, titelleftConstraint, titelTopConstraint]];
        
        // itemImage autolayouts
        NSLayoutConstraint * imageTopConstraint = [NSLayoutConstraint constraintWithItem:self.itemImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:padding];
        
        NSLayoutConstraint * imageWidthConstraint = [NSLayoutConstraint constraintWithItem:self.itemImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:150];
        
        NSLayoutConstraint * imageHeightConstraint = [NSLayoutConstraint constraintWithItem:self.itemImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:100];
        
        NSLayoutConstraint * imageTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.itemImage attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-padding];
        
        [self.contentView addConstraints:@[imageWidthConstraint, imageHeightConstraint, imageTrailingConstraint, imageTopConstraint]];
        
        // itemDescription autolayouts
        NSLayoutConstraint * descriptionTopConstraint = [NSLayoutConstraint constraintWithItem:self.itemDescription attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.itemTitle attribute:NSLayoutAttributeBottom multiplier:1.0 constant:padding];
        
        NSLayoutConstraint * descriptionLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.itemDescription attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:padding];
        
        NSLayoutConstraint * descriptionTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.itemDescription attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.itemImage attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-padding];
        
        NSLayoutConstraint * descriptionBottomConstraint = [NSLayoutConstraint constraintWithItem:self.itemDescription attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottomMargin multiplier:1.0 constant:padding];
        
        [self.contentView addConstraints:@[descriptionTopConstraint, descriptionLeadingConstraint, descriptionTrailingConstraint, descriptionBottomConstraint]];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.textLabel.frame);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
