//
//  Smartify.m
//  VerySmrt
//
//  Created by Drew Hill on 1/31/17.
//  Copyright (c) 2017 Drew Hill. All rights reserved.
//

#import "Smartify.h"
#import "WordConstructor.h"

@implementation Smartify

-(instancetype)init{
    self = [super init];
    [self initScoringResources];
    self.replacementWords = [[NSMutableArray alloc] init];
    return self;
}

-(void)processText:(NSString *)text{
    self.processedText = text;
    NSMutableArray *partsOfSpeech = [self stringWithPartsOfSpeech:text];
    self.replacementIndexes = [self indexesOfPotentialReplacementsInString:text withPoS:partsOfSpeech andScoreCard:self.wordValues];
    self.parsingProgress = 0;
    self.parsingFinished = false;
    int i;
    for (i=0; i<self.replacementIndexes.count; i++) {
        NSLog(@"index:%d",(int)[[self.replacementIndexes objectAtIndex:i] integerValue]);
        [self replaceWithSmartWordAtIndex:(int)[[self.replacementIndexes objectAtIndex:i] integerValue] inMessage:text forPoS:[partsOfSpeech objectAtIndex:(int)[[self.replacementIndexes objectAtIndex:i] integerValue]] andScorecard:self.wordValues];
    }
}

-(void)initScoringResources{
    NSNumber *onePoint = [NSNumber numberWithInt:1];
    NSNumber *twoPoints = [NSNumber numberWithInt:2];
    NSNumber *threePoints = [NSNumber numberWithInt:3];
    NSNumber *fourPoints = [NSNumber numberWithInt:4];
    NSNumber *fivePoints = [NSNumber numberWithInt:5];
    NSNumber *eightPoints = [NSNumber numberWithInt:8];
    NSNumber *tenPoints = [NSNumber numberWithInt:10];
    self.wordValues = [[NSDictionary alloc] initWithObjectsAndKeys:onePoint,@"e",
                       onePoint,@"a",
                       onePoint,@"i",
                       onePoint,@"o",
                       onePoint,@"n",
                       onePoint,@"r",
                       onePoint,@"t",
                       onePoint,@"l",
                       onePoint,@"s",
                       onePoint,@"u",
                       twoPoints,@"d",
                       twoPoints,@"g",
                       threePoints,@"b",
                       threePoints,@"c",
                       threePoints,@"m",
                       threePoints,@"p",
                       fourPoints,@"f",
                       fourPoints,@"h",
                       fourPoints,@"v",
                       fourPoints,@"w",
                       fourPoints,@"y",
                       fivePoints,@"k",
                       eightPoints,@"j",
                       eightPoints,@"x",
                       tenPoints,@"q",
                       fivePoints,@"z"
                       ,nil];

    self.commonWords = [[NSArray alloc] initWithObjects:@"will",@"make",@"makes", nil];
}

-(void)replaceWithSmartWordAtIndex:(int)index inMessage:(NSString*)message forPoS:(NSString*)PoS andScorecard:(NSDictionary*)scoreCard{
    NSMutableArray *words = [[NSMutableArray alloc] initWithArray:[message componentsSeparatedByString:@" "]];
    NSString *wordToReplace = [words objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.dictionaryapi.com/api/v1/references/thesaurus/xml/%@?key=565d7e80-c25c-4778-9f04-1a518ae41045",wordToReplace]];
    NSLog(@"sending request...");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             WordConstructor *wordbuilder = [[WordConstructor alloc] initWithScorecard:self.wordValues andData:data];
             [wordbuilder parseForWord:[wordToReplace lowercaseString] andPoS:[PoS lowercaseString]];
             wordbuilder.currentWord.index = index;
             [self.replacementWords addObject:wordbuilder.currentWord];
             [self incrementProgress];
         }else{
             NSLog(@"nothing");
         }
     }];
}

-(void)incrementProgress{
    self.parsingProgress++;
    if (self.parsingProgress==self.replacementIndexes.count) {
        self.parsingFinished = true;
    }
}

-(NSMutableArray*)indexesOfPotentialReplacementsInString:(NSString*)message withPoS:(NSMutableArray*)PoS andScoreCard:(NSDictionary*)scoreCard{
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    NSArray *words = [message componentsSeparatedByString:@" "];
    int i;
    for (i=0; i<PoS.count; i++) {
        NSString *partOfSpeech = [PoS objectAtIndex:i];
        if (([partOfSpeech isEqualToString:@"Verb"]||[partOfSpeech isEqualToString:@"Adjective"]||[partOfSpeech isEqualToString:@"Noun"])&& ![self.commonWords containsObject:[words objectAtIndex:i]]) {
            int score = [self scoreForWord:[words objectAtIndex:i] scoreCard:scoreCard];
            if (score>5) {
                [indexes addObject:[NSNumber numberWithInt:i]];
            }
        }
    }
    return indexes;
}

-(NSMutableArray*)stringWithPartsOfSpeech:(NSString*)string{
    NSMutableArray *pos = [[NSMutableArray alloc] init];
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:[NSArray arrayWithObject:NSLinguisticTagSchemeLexicalClass] options:~NSLinguisticTaggerOmitWords];
    [tagger setString:string];
    [tagger enumerateTagsInRange:NSMakeRange(0, [string length])
                          scheme:NSLinguisticTagSchemeLexicalClass
                         options:~NSLinguisticTaggerOmitWords
                      usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
                          NSLog(@"found: %@ (%@)", [string substringWithRange:tokenRange], tag);
                          [pos addObject:tag];
                      }];
    NSLog(@"DETAILED STRING:%@",pos);
    return pos;
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
