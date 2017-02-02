//
//  Smartify.h
//  VerySmrt
//
//  Created by Drew Hill on 1/31/17.
//  Copyright (c) 2017 Drew Hill. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordEntry.h"

@interface Smartify : NSObject

@property NSDictionary *wordValues;
@property NSArray *commonWords;
@property NSMutableArray *replacementIndexes;
@property NSMutableArray *replacementWords;
@property NSString *processedText;
@property int parsingProgress;
@property BOOL parsingFinished;

-(void)processText:(NSString*)text;

@end
