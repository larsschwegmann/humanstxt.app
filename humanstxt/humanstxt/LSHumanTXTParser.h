//
//  LSHumanTXTParser.h
//  humanstxt
//
//  Created by Lars Schwegmann on 21.05.12.
//  Copyright (c) 2012 Lars Schwegmann iOS Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSHumanTXTParserDelegate <NSObject>

@optional
-(void)didSucceedWithInfo:(NSArray *)info;
-(void)didFailWithError:(NSString *)errorDescription;

@end

@interface LSHumanTXTParser : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>{
    NSMutableData *theData;
    NSURLConnection *theConnection;
    NSString *url;
    //Delegate
    id<LSHumanTXTParserDelegate> _delegate;
}

@property (nonatomic, strong) id<LSHumanTXTParserDelegate> delegate;

-(NSArray *)parseHumansDotTXTFileString:(NSString *)theContent;
-(id)initWithURLString:(NSString *)urlString delegate:(id)clientDelegate;
-(void)startParsing;
-(int)humanstxtExists:(NSString *)urlString;

@end
