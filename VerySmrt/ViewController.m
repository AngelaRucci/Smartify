//
//  ViewController.m
//  VerySmrt
//
//  Created by Drew Hill on 10/21/16.
//  Copyright (c) 2016 Drew Hill. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *testText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
                             tenPoints,@"z"
                             ,nil];
    
    self.commonWords = [[NSArray alloc] initWithObjects:@"will",@"make", nil];
}
- (IBAction)smartify:(id)sender {
    NSMutableArray *partsOfSpeech = [self stringWithPartsOfSpeech:self.testText.text];
    NSMutableArray *replacmentIndexes = [self indexesOfPotentialReplacementsInString:self.testText.text withPoS:partsOfSpeech andScoreCard:self.wordValues];
    int i;
    for (i=0; i<replacmentIndexes.count; i++) {
        NSLog(@"index:%d",(int)[[replacmentIndexes objectAtIndex:i] integerValue]);
        [self replaceWithSmartWordAtIndex:(int)[[replacmentIndexes objectAtIndex:i] integerValue] inMessage:self.testText.text forPoS:[partsOfSpeech objectAtIndex:(int)[[replacmentIndexes objectAtIndex:i] integerValue]] andScorecard:self.wordValues];
    }
}

-(void)replaceWithSmartWordAtIndex:(int)index inMessage:(NSString*)message forPoS:(NSString*)PoS andScorecard:(NSDictionary*)scoreCard{
    NSMutableArray *words = [[NSMutableArray alloc] initWithArray:[message componentsSeparatedByString:@" "]];
    NSString *wordToReplace = [words objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://words.bighugelabs.com/api/2/d11a93e5b59a8147b5087cdd81ff70dc/%@/json",wordToReplace]];
    NSLog(@"sending request...");
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *wordData = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             NSDictionary *thesaurus = [wordData valueForKey:[PoS lowercaseString]];
             NSArray *synonyms = [thesaurus valueForKey:@"syn"];
             NSLog(@"data:%@",synonyms);
             if(![synonyms isEqual:[NSNull null]]){
                 NSString *biggestWord = @"";
                 int biggestScore = 0;
                 int i;
                 for (i=0; i<synonyms.count; i++) {
                     NSString *synonym = [synonyms objectAtIndex:i];
                     int score = [self scoreForWord:synonym scoreCard:scoreCard];
                     NSArray *wordsInSyn = [synonym componentsSeparatedByString:@" "];
                     if (score>biggestScore&&!(wordsInSyn.count>1)) {
                         biggestScore = score;
                         biggestWord = synonym;
                     }
                 }
                 NSMutableArray *currentWords = [[NSMutableArray alloc]initWithArray:[self.testText.text componentsSeparatedByString:@" "]];
                 [currentWords replaceObjectAtIndex:index withObject:[biggestWord stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
                 [self.testText setText:[currentWords componentsJoinedByString:@" "]];
             }
         }else{
             NSLog(@"nothing");
         }
     }];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
