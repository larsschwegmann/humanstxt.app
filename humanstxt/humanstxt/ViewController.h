//
//  ViewController.h
//  humanstxt
//
//  Created by Lars Schwegmann on 21.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSHumanTXTParser.h"

@interface ViewController : UIViewController <LSHumanTXTParserDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>{
    //Instance Variables
    LSHumanTXTParser *theParser;
    
    //IB Properties
    IBOutlet UISearchBar *theSearchBar;
    IBOutlet UITableView *theTableView;
    
    NSMutableArray *theHumanTXTObjects;
    NSMutableArray *theHumanTXTHeadings;
    
    int allroundIndexPathRow;
    
    NSIndexPath *keepInMindIndex;
}
//Methods
- (void)getHumansDotTXT;

//Properties
@property (strong, nonatomic) IBOutlet UISearchBar *theSearchBar;
@property (strong, nonatomic) IBOutlet UITableView *theTableView;

@end
