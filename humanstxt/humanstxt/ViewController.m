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

@interface ViewController ()

@end

@implementation ViewController
@synthesize urlField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    urlField = nil;
    [self setUrlField:nil];
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

- (IBAction)getHumansDotTXT:(id)sender {
    if ([urlField.text containString:@"http://"]) {
        //valid url
        if ([urlField.text containString:@"humans.txt"]) {
            LSHumanTXTParser *parser = [[LSHumanTXTParser alloc] initWithURLString:urlField.text delegate:self];
            [parser startParsing];
        }else{
            if ([urlField.text containString:@"/humans.txt"]) {
                LSHumanTXTParser *parser = [[LSHumanTXTParser alloc] initWithURLString:[NSString stringWithFormat:@"%@humans.txt",urlField.text] delegate:self];
                [parser startParsing];
            }else{
                LSHumanTXTParser *parser = [[LSHumanTXTParser alloc] initWithURLString:[NSString stringWithFormat:@"%@/humans.txt",urlField.text] delegate:self];
                [parser startParsing];
            }
            
        }
        
    }else{
        NSLog(@"error");
    }
    
}
@end
