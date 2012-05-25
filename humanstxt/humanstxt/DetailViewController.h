//
//  DetailViewController.h
//  humanstxt
//
//  Created by Lars Schwegmann on 24.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIWebViewDelegate>{
    
    NSString *url;
    NSString *content;
    
    NSString *contentSplitHeading;
    NSString *contentSplitContent;
    
    NSString *guessedType;
    
    IBOutlet UILabel *urlLabel;
    IBOutlet UILabel *typeLabel;
    IBOutlet UILabel *headingLabel;
    IBOutlet UILabel *contentTextView;
    IBOutlet UIView *containerView;
    IBOutlet UIImageView *papercutView;
}
@property (strong, nonatomic) IBOutlet UILabel *urlLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentTextView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *papercutView;

-(id)initWithContent:(NSString *)contentString url:(NSString *)urlString;

@end
