//
//  DetailViewController.m
//  humanstxt
//
//  Created by Lars Schwegmann on 24.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import "DetailViewController.h"
#import "NSString+BaseKit.h"
#import "MKMapView+ZoomLevel.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize urlLabel;
@synthesize typeLabel;
@synthesize headingLabel;
@synthesize contentTextView;
@synthesize containerView;
@synthesize papercutView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithContent:(NSString *)contentString url:(NSString *)urlString{
    if (self == [super init]) {
        content = contentString;
        url = urlString;
        NSArray *tempContentArray = [content componentsSeparatedByString:@":"];
        if ([tempContentArray objectAtIndex:0] != nil) {
            //Object available
            contentSplitHeading = [tempContentArray objectAtIndex:0];
            //contentSplitHeading = [contentSplitHeading stringByReplacingOccurrencesOfString:@" " withString:@""];
            if ([tempContentArray objectAtIndex:1] != nil) {
                //Object available
                contentSplitContent = [tempContentArray objectAtIndex:1];
                //contentSplitContent = [contentSplitContent stringByReplacingOccurrencesOfString:@" " withString:@""];
            }else {
                //no content, probably wrong syntax
                contentSplitContent = @"(no content)";
            }
        }else {
            //no heading, probably wrong syntax
            contentSplitHeading = @"(no content)";
        }
        
        if ([contentSplitHeading containString:@"Location"] || [contentSplitHeading containString:@"location"] || [contentSplitHeading containString:@"From"] || [contentSplitHeading containString:@"from"]) {
            //Content probably describes a location
            guessedType = @"Location";
        }else if ([contentSplitHeading containString:@"Twitter"] || [contentSplitHeading containString:@"twitter"]){
            //Content probably describes a twitter username
            if ([contentSplitContent containString:@"@"]) {
                guessedType = @"Twitter";
            }
        }else if([contentSplitHeading containString:@"Site"] || [contentSplitHeading containString:@"site"] || [contentSplitHeading containString:@"Website"] || [contentSplitHeading containString:@"website"] || [contentSplitHeading containString:@"Web"] || [contentSplitHeading containString:@"web"]){
            //Content probably describes a URL
            if ([contentSplitContent containString:@"http"] || [contentSplitContent containString:@"https"]) {
                //Content is a URL
                guessedType = @"URL";
                contentSplitContent = [contentSplitContent stringByAppendingFormat:@":%@",[tempContentArray objectAtIndex:2]];
            }
        }else{
            //Content is unkown or just plain text
            guessedType = @"Plain text";
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    typeLabel.text = guessedType;
    urlLabel.text = url;
    headingLabel.text = contentSplitHeading;
    contentTextView.text = contentSplitContent;
    
    if ([guessedType isEqualToString:@"Location"]) {
        //Show containerview and insert MKMapView
        containerView.hidden = NO;
        papercutView.hidden = NO;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [geocoder geocodeAddressString:contentSplitContent completionHandler:^(NSArray *placemarks, NSError *error)
         {
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             
             if ( ! placemarks)
             {
                 [[[UIAlertView alloc] initWithTitle:@"Place could not be found :("
                                             message:@"The place in the humans.txt file could not be found on the map."
                                            delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"OK", nil] show];
             }
             else
             {
                 CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
                 
                 MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 273)];
                 
                 [mapView setCenterCoordinate:firstPlacemark.location.coordinate zoomLevel:11 animated:NO];
                 
                 [containerView addSubview:mapView];
             }
         }];
        
    }else if ([guessedType isEqualToString:@"Twitter"]) {
        //Show containerview and insert UIWebView to display twitter profile
        containerView.hidden = NO;
        papercutView.hidden = NO;
        
        NSString *twUsername = [contentSplitContent stringByReplacingOccurrencesOfString:@"@" withString:@" "];
        twUsername = [contentSplitContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 273)];
        webView.delegate = self;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", twUsername]]]];
        NSLog(@"http://twitter.com/%@", twUsername);
        [containerView addSubview:webView];
    }else if ([guessedType isEqualToString:@"URL"]) {
        //Show containerview and insert UIWebView to display URL
        containerView.hidden = NO;
        papercutView.hidden = NO;
        
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 273)];
        webView.delegate = self;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [containerView addSubview:webView];
    }else {
        //Hide containerview
        containerView.hidden = YES;
        papercutView.hidden = YES;
    }
}

- (void)viewDidUnload
{
    urlLabel = nil;
    [self setUrlLabel:nil];
    typeLabel = nil;
    [self setTypeLabel:nil];
    headingLabel = nil;
    [self setHeadingLabel:nil];
    contentTextView = nil;
    [self setContentTextView:nil];
    containerView = nil;
    [self setContainerView:nil];
    papercutView = nil;
    [self setPapercutView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL is invalid" message:@"The URL from the humans.txt file is invalid and could not be loaded. Please contact the site Administrator and inform him about that." delegate:self cancelButtonTitle:@"OK, I'll do that!" otherButtonTitles:nil];
    //[alert show];
    //commented out because it shows up sometimes even if there are only some html parsing errors
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
