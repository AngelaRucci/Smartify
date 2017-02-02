//
//  WordEntry.h
//  VerySmrt
//
//  Created by Drew Hill on 1/22/17.
//  Copyright (c) 2017 Drew Hill. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordEntry : NSObject

//@property NSMutableArray *synonyms;
@property NSMutableDictionary *synonyms;
@property NSMutableDictionary *biggestSynonyms;
@property NSString *partofspeech;
@property NSString *word;
@property int index;
@property NSString *replacement;

-(instancetype)initWithWord:(NSString*)word andPoS:(NSString*)partofspeech;

@end
