//
//  WordConstructor.h
//  VerySmrt
//
//  Created by Drew Hill on 1/22/17.
//  Copyright (c) 2017 Drew Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordEntry.h"

@interface WordConstructor : NSObject <NSXMLParserDelegate>

@property NSXMLParser *parser;
@property WordEntry *currentWord;
@property NSString *currentElement;
@property NSMutableString *foundValue;
@property NSMutableArray *currentSynonyms;
@property BOOL currentIsValidReplacement;
@property NSString *currentEntryId;
@property NSString *finalBiggestWord;
@property NSString *currentMeaning;
@property NSDictionary *scorecard;

-(instancetype)initWithScorecard:(NSDictionary*)scorecard andData:(NSData*)data;
-(void)parseForWord:(NSString*)word andPoS:(NSString*)partofspeech;

@end