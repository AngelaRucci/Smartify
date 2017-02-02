//
//  KeyboardViewController.h
//  SmartifyBoard
//
//  Created by Drew Hill on 11/13/16.
//  Copyright (c) 2016 Drew Hill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Smartify.h"
#import "InputView.h"
#import "LoadingView.h"

@interface KeyboardViewController : UIInputViewController

//@property NSMutableArray *keyboardKeys;
//@property UITextView *smartText;
@property InputView *inputVieww;
@property LoadingView *loadVieww;
@property Smartify *smartifier;

@end
