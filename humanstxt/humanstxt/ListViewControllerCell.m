//
//  ListViewControllerCell.m
//  humanstxt
//
//  Created by Lars Schwegmann on 24.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import "ListViewControllerCell.h"

@implementation ListViewControllerCell
@synthesize backgroundImageView;
@synthesize mainLabel;
@synthesize containerView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.tag = 0;
        backgroundImageView.backgroundColor = [UIColor whiteColor];
        backgroundImageView.image = [UIImage imageNamed:@"cell"];
        backgroundImageView.frame = CGRectMake(0, 0, 320, 40);
        
        UIImageView *selBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        selBackground.image = [UIImage imageNamed:@"cellselected"];
        self.selectedBackgroundView = selBackground;
        
        mainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mainLabel.tag = 1;
        mainLabel.backgroundColor = [UIColor clearColor];
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.numberOfLines = 1;
        mainLabel.lineBreakMode = UILineBreakModeTailTruncation;
        mainLabel.font = [UIFont boldSystemFontOfSize:19.0];
        mainLabel.frame = CGRectMake(5, 12, 265, 20);
        
        containerView = [[UIView alloc] init];
        containerView.tag = 0;
        containerView.frame = CGRectMake(0, 0, 320, 40);
        [containerView addSubview:backgroundImageView];
        [containerView addSubview:mainLabel];
        
        [self.contentView addSubview:containerView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    if (selected) {
        mainLabel.textColor = [UIColor whiteColor];
        backgroundImageView.image = [UIImage imageNamed:@"cellselected"];
    }else{
        mainLabel.textColor = [UIColor blackColor];
        backgroundImageView.image = [UIImage imageNamed:@"cell"];
    }
    // Configure the view for the selected state
}

@end
