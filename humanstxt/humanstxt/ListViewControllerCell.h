//
//  ListViewControllerCell.h
//  humanstxt
//
//  Created by Lars Schwegmann on 24.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewControllerCell : UITableViewCell{
    UIImageView *backgroundImageView;
    UILabel *mainLabel;
    UIView *containerView;
}

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UIView *containerView;

@end
