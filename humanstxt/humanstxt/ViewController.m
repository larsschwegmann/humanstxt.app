//
//  ViewController.m
//  humanstxt
//
//  Created by Lars Schwegmann on 21.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import "ViewController.h"
#import "LSHumanTXTParser.h"
#import "NSString+BaseKit.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize theSearchBar;
@synthesize theTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    theHumanTXTObjects = [[NSMutableArray alloc] init];
    theHumanTXTHeadings = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    theSearchBar = nil;
    [self setTheSearchBar:nil];
    theTableView = nil;
    [self setTheTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark custom methods

- (void)getHumansDotTXT {
    if ([theSearchBar.text containString:@"http://"]) {
        //valid url
        if ([theSearchBar.text containString:@"humans.txt"]) {
            theParser = [[LSHumanTXTParser alloc] initWithURLString:theSearchBar.text delegate:self];
        }else{
            if ([theSearchBar.text containString:@"/humans.txt"]) {
                theParser = [[LSHumanTXTParser alloc] initWithURLString:[NSString stringWithFormat:@"%@humans.txt",theSearchBar.text] delegate:self];
            }else{
                theParser = [[LSHumanTXTParser alloc] initWithURLString:[NSString stringWithFormat:@"%@/humans.txt",theSearchBar.text] delegate:self];
            }
        }
        [theParser startParsing];
    }else{
        NSLog(@"ERROR: the URL is not valid: %@", theSearchBar.text);
    }
    
}

#pragma mark LSHumanTXTParserDelegate

-(void)didFailWithError:(NSError *)error{
    NSLog(@"LSHumanTXTParser -> didFailWithError: %@", error.description);
}

-(void)didSucceedWithInfo:(NSArray *)info{
    NSLog(@"SUCCESS!!!");
    //reallocate to remove old object dictionarys
    theHumanTXTObjects = nil;
    theHumanTXTHeadings = nil;
    theHumanTXTObjects = [[NSMutableArray alloc] init];
    theHumanTXTHeadings = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in info) {
        NSLog(@"content: %@", [obj objectForKey:@"content"]);
        NSLog(@"header?: %@", [obj objectForKey:@"heading"]);
        if ([[obj objectForKey:@"heading"] isEqualToString:@"true"]) {
            [theHumanTXTHeadings addObject:obj];
        }else{
            [theHumanTXTObjects addObject:obj];
        }
    }
    [theTableView reloadData];
}

#pragma mark UISearchBarDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //did cancel
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self getHumansDotTXT];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //[self getHumansDotTXT];
}

#pragma mark UITableViewDataSource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = 0;
    for (NSDictionary *obj in theHumanTXTObjects) {
        if ([[obj objectForKey:@"section"] intValue] == section+1) {
            count++;
        }
    }
    return count;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [theHumanTXTHeadings count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headingString;
    if (theHumanTXTHeadings) {
        for (NSDictionary *dict in theHumanTXTHeadings) {
            if ([[dict objectForKey:@"heading"] isEqualToString:@"true"]) {
                if (section+1 == [[dict objectForKey:@"section"] intValue]) {
                    headingString = [dict objectForKey:@"content"];
                }
            }
        }
    }
    return headingString;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView;
    UIImageView *background;
    //UIView *status;
    
    headerView = [[UIView alloc] init];
    background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    background.image = [UIImage imageNamed:@"tableheader3"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 10)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = [self tableView:theTableView titleForHeaderInSection:section];
    /*
     if ([label.text isEqualToString:@"Online"]) {
     label.textColor = [UIColor greenColor];
     }else if([label.text isEqualToString:@"Away"]){
     label .textColor = [UIColor yellowColor];
     }else if([label.text isEqualToString:@"Offline"]){
     label.textColor = [UIColor redColor];
     }
     label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];*/
    label.textColor = [UIColor whiteColor];
    
    //status = [[UIView alloc] initWithFrame:CGRectMake(265, 0, 70, 22)];
    //status.layer.cornerRadius = 10.0f;
    //status.layer.masksToBounds = YES;
    //status.backgroundColor = [UIColor clearColor];
    
    /*if ([label.text isEqualToString:NSLocalizedString(@"Online",@"Online string which is shown in a tableview header")]) {
        //label.textColor = [UIColor greenColor];
        //status.image = [UIImage imageNamed:@"online"];
        status.backgroundColor = [UIColor colorWithRed:(155.0/255.0) green:(216.0/255.0) blue:(1.0/255.0) alpha:1.0f];
    }else if([label.text isEqualToString:NSLocalizedString(@"Away",@"Away string which is shown in a tableview header")]){
        //status.image = [UIImage imageNamed:@"away"];
        //label .textColor = [UIColor yellowColor];
        status.backgroundColor = [UIColor yellowColor];
    }else if([label.text isEqualToString:NSLocalizedString(@"Offline",@"Offline string which is shown in a tableview header")]){
        //status.image = [UIImage imageNamed:@"offline"];
        //label.textColor = [UIColor redColor];
        status.backgroundColor = [UIColor colorWithRed:(210.0/255.0) green:(62.0/255.0) blue:(69.0/255.0) alpha:1.0f];
    }*/
    
    
    [headerView addSubview:background];
    [headerView addSubview:label];
    //[headerView addSubview:status];
    return headerView;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UIView *theContentView;
    UIImageView *backgroundView;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        theContentView = [[UIView alloc] init];
        theContentView.tag = 0;
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        backgroundView.image = [UIImage imageNamed:@"cell"];
        backgroundView.tag = 1;
        [theContentView addSubview:backgroundView];
        [cell.contentView addSubview:theContentView];
    }else{
        theContentView = (UIView *)[cell.contentView viewWithTag:0];
        backgroundView = (UIImageView *)[[cell.contentView viewWithTag:0] viewWithTag:1];
    }
    
    
    
    // Configure the cell...
    //NSString *continent = [self tableView:tableView titleForHeaderInSection:indexPath.section];
    //NSString *country = [[self.countries valueForKey:continent] objectAtIndex:indexPath.row];
    int minusRows = 0;
    for (int i = indexPath.section-1; i>=0; i--) {
        minusRows = minusRows + [self tableView:theTableView numberOfRowsInSection:i];
    }
    
    NSDictionary *dict = [theHumanTXTObjects objectAtIndex:indexPath.row+minusRows];
    NSLog(@"original indexpath.section: %d", indexPath.section);
    NSLog(@"modified version of indexPath.section: %d", indexPath.section+1);
    NSLog(@"section of content dictionary: %d", [[dict objectForKey:@"section"] intValue]);
    
    [cell.textLabel setText:[dict objectForKey:@"content"]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end
