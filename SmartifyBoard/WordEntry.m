//
//  WordEntry.m
//  VerySmrt
//
//  Created by Drew Hill on 1/22/17.
//  Copyright (c) 2017 Drew Hill. All rights reserved.
//

#import "WordEntry.h"

@implementation WordEntry

-(instancetype)init{
    self = [super init];
    self.synonyms = [[NSMutableDictionary alloc] init];
    self.biggestSynonyms = [[NSMutableDictionary alloc] init];
    self.replacement = @"";
    return self;
}

-(instancetype)initWithWord:(NSString*)word andPoS:(NSString*)partofspeech{
    self = [super init];
    self.synonyms = [[NSMutableDictionary alloc] init];
    self.biggestSynonyms = [[NSMutableDictionary alloc] init];
    self.replacement = word;
    self.word = word;
    self.partofspeech = partofspeech;
    return self;
}

@end
