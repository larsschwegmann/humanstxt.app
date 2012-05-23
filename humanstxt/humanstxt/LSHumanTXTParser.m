//
//  LSHumanTXTParser.m
//  humanstxt
//
//  Created by Lars Schwegmann on 21.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import "LSHumanTXTParser.h"
#import "NSString+BaseKit.h"

@implementation LSHumanTXTParser
@synthesize delegate;

-(id)initWithURLString:(NSString *)urlString delegate:(id)clientDelegate{
    
    if (self == [super init]) {
        
        self.delegate = clientDelegate;
        url = urlString;
        
    }
    
    return self;
}

-(void)startParsing{
    int existsResult = [self humanstxtExists:url];
    if (existsResult == 200) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if (theConnection) {
            theData = [[NSMutableData alloc] init];
            NSLog(@"LSHumanTXTParser -> URL Connection successfully instantiated!");
        }else{
            NSLog(@"LSHumanTXTParser -> there was an error instantiating the url connection!");
        }
    }else{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (existsResult == 404) {
            NSLog(@"LSHumanTXTParser -> ERROR 404: NO humans.txt file!");
            [delegate didFailWithError:@"Error 404"];
        }else{
            NSLog(@"LSHumanTXTParser -> HTTP error %d", existsResult);
            [delegate didFailWithError:@"Unknown HTTP Error"];
        }
        
    }
    
}

-(int)humanstxtExists:(NSString *)urlString{    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    NSHTTPURLResponse* response = nil;
    NSError* error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"statusCode = %d", [response statusCode]);
    
    return [response statusCode];
}

-(NSArray *)parseHumansDotTXTFileString:(NSString *)theContent{
    if (theContent && ![theContent isEqualToString:@""]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSArray *lines = [theContent componentsSeparatedByString:@"\n"];
        int sectionCount = 0;
        for (NSString *str in lines) {
            NSMutableDictionary *lineInfo = [[NSMutableDictionary alloc] init];
            if ([str isEqualToString:@""]) {
                continue;
            }else if ([str containString:@"/*"] || [str containString:@"*/"]){
                //Heading of a section
                NSString *newStr = str;
                newStr = [str stringByReplacingOccurrencesOfString:@"/*" withString:@""];
                newStr = [str stringByReplacingOccurrencesOfString:@"*/" withString:@""];
                newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                newStr = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                if (![newStr isEqualToString:@""]) {
                    sectionCount++;
                    [lineInfo setObject:newStr forKey:@"content"];
                    [lineInfo setObject:@"true" forKey:@"heading"];
                    [lineInfo setObject:[NSString stringWithFormat:@"%d", sectionCount] forKey:@"section"];
                    //add the dictionary to the array of modded lines
                    [array addObject:lineInfo];
                }else{
                    //empty line
                }
            }else{
                NSString *newStr = str;
                newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
                newStr = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                if (![newStr isEqualToString:@""]) {
                    [lineInfo setObject:newStr forKey:@"content"];
                    [lineInfo setObject:@"false" forKey:@"heading"];
                    [lineInfo setObject:[NSString stringWithFormat:@"%d", sectionCount] forKey:@"section"];
                    [array addObject:lineInfo];
                }else{
                    //empty line
                }
            }
        }
        return array;
    }else{
        NSLog(@"LSHumanTXTParser -> parsing failed: no content");
        [delegate didFailWithError:nil];
        return nil;
    }
}

#pragma mark NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (connection == theConnection) {
        NSLog(@"LSHumanTXTParser -> URL connection failed with error: %@", error.description);
        [delegate didFailWithError:error.description];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (connection == theConnection)
    {
        // do something with the data object.
        [theData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (connection == theConnection) {
        NSString *content = [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];
        NSArray *theResult = [self parseHumansDotTXTFileString:content];
        if (theResult && theResult.count != 0) {
            [delegate didSucceedWithInfo:theResult];
        }else{
            //The array doesn't exist or is empty
            [delegate didFailWithError:nil];
        }
    }
}

@end
