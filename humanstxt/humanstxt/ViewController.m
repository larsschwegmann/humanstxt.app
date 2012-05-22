//
//  ViewController.m
//  humanstxt
//
//  Created by Lars Schwegmann on 21.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import "ViewController.h"
#import "LSHumanTXTParser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    LSHumanTXTParser *parser = [[LSHumanTXTParser alloc] initWithURLString:@"http://larsschwegmann.com/humans.txt" delegate:self];
    [parser startParsing];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark LSHumanTXTParserDelegate

-(void)didFailWithError:(NSError *)error{
    NSLog(@"error: %@", error.description);
}

-(void)didSucceedWithInfo:(NSArray *)info{
    NSLog(@"SUCCESS!!!");
    for (NSDictionary *obj in info) {
        NSLog(@"content: %@", [obj objectForKey:@"content"]);
        NSLog(@"header?: %@", [obj objectForKey:@"heading"]);
    }
}

@end
