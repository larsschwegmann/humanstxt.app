//
//  ViewController.h
//  humanstxt
//
//  Created by Lars Schwegmann on 21.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSHumanTXTParser.h"

@interface ViewController : UIViewController <LSHumanTXTParserDelegate>{
    
    IBOutlet UITextField *urlField;
}
- (IBAction)getHumansDotTXT:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *urlField;

@end
