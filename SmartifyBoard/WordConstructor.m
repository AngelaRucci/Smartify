//
//  WordConstructor.m
//  VerySmrt
//
//  Created by Drew Hill on 1/22/17.
//  Copyright (c) 2017 Drew Hill. All rights reserved.
//

#import "WordConstructor.h"

@implementation WordConstructor

-(instancetype)initWithScorecard:(NSDictionary*)scorecard andData:(NSData*)data{
    self = [super init];
    self.foundValue = [[NSMutableString alloc] init];
    self.parser = [[NSXMLParser alloc] initWithData:data];
    self.parser.delegate = self;
    self.scorecard = scorecard;
    self.currentElement = [[NSString alloc] init];
    self.currentEntryId = [[NSString alloc] init];
    self.currentMeaning = [[NSString alloc] init];
    self.currentSynonyms = [[NSMutableArray alloc] init];
    self.currentWord = [[WordEntry alloc] init];
    return self;
}

-(void)parseForWord:(NSString*)word andPoS:(NSString*)partofspeech{
    self.currentWord.word = word;
    self.currentWord.partofspeech = partofspeech;
    [self.parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"entry"]) {
        self.currentIsValidReplacement = false;
        self.currentEntryId = [attributeDict objectForKey:@"id"];
    }
    if ([elementName isEqualToString:@"sens"]) {
        [self.currentSynonyms removeAllObjects];
    }
    self.currentElement = elementName;
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"fl"]) {
        //        NSLog(@"pos:%@",self.foundValue);
        //        NSLog(@"poss:%@",self.currentWord.partofspeech);
        if ([self.currentWord.partofspeech isEqualToString:self.foundValue]) {
            self.currentIsValidReplacement = true;
        }
    }
    if ([elementName isEqualToString:@"syn"]) {
        [self.currentSynonyms addObjectsFromArray:[self.foundValue componentsSeparatedByString:@", "]];
    }
    if ([elementName isEqualToString:@"sens"]) {
        //        NSLog(@"pos:%@",self.currentEntryId);
        NSLog(@"meaning:%@",self.currentMeaning);
        if (self.currentIsValidReplacement && [self.currentEntryId isEqualToString:[self.currentWord.word lowercaseString]]) {
            [self.currentWord.synonyms setObject:[NSArray arrayWithArray:self.currentSynonyms] forKey:self.currentMeaning];
        }
        self.currentMeaning = @"";
        [self.currentSynonyms removeAllObjects];
    }
    if ([elementName isEqualToString:@"mc"]) {
        //NSLog(@"meaning:%@",self.foundValue);
        self.currentMeaning = [NSString stringWithString:self.foundValue];
    }
    
    [self.foundValue setString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([self.currentElement isEqualToString:@"fl"] || [self.currentElement isEqualToString:@"syn"] || [self.currentElement isEqualToString:@"mc"]) {
        if (![string isEqualToString:@"\n"]) {
            [self.foundValue appendString:string];
        }
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"finished stuff");
    NSString *biggestWord = self.currentWord.word;
    int biggestScore = [self scoreForWord:biggestWord scoreCard:self.scorecard];
    int i;
    NSArray *keys = [self.currentWord.synonyms allKeys];
    for (i=0; i<keys.count; i++) {
        NSArray *synonyms = [self.currentWord.synonyms objectForKey:[keys objectAtIndex:i]];
        NSString *biggestSynonym = [self biggestWordInSet:synonyms];
        NSLog(@"biggestsyn:%@",biggestSynonym);
        [self.currentWord.biggestSynonyms setObject:biggestSynonym forKey:[keys objectAtIndex:i]];
        int synonymScore = [self scoreForWord:biggestSynonym scoreCard:self.scorecard];
        if (synonymScore>biggestScore) {
            biggestScore = synonymScore;
            biggestWord = biggestSynonym;
        }
    }
    self.currentWord.replacement = biggestWord;
    NSLog(@"replacement:%@",self.currentWord.replacement);
}

-(NSString*)biggestWordInSet:(NSArray*)words{
    if (words.count>0) {
        NSString *biggestWord = [words objectAtIndex:0];
        int biggestScore = [self scoreForWord:biggestWord scoreCard:self.scorecard];
        int i;
        for (i=1; i<words.count; i++) {
            NSString *synonym = [words objectAtIndex:i];
            int score = [self scoreForWord:synonym scoreCard:self.scorecard];
            NSArray *wordsInSyn = [synonym componentsSeparatedByString:@" "];
            //score = score/wordsInSyn;
            if (score>biggestScore&&wordsInSyn.count<=2) {
                biggestScore = score;
                biggestWord = synonym;
            }
        }
        return biggestWord;
    }
    return @"";
}

-(int)scoreForWord:(NSString*)word scoreCard:(NSDictionary*)scoreCard{
    int score=0;
    int i;
    for (i=0; i<word.length; i++) {
        NSString *charString = [NSString stringWithFormat:@"%c",[word characterAtIndex:i]];
        score += [[scoreCard valueForKey:charString] integerValue];
    }
    return score;
}

@end
