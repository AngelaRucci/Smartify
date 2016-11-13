//
//  KeyboardViewController.m
//  SmartifyBoard
//
//  Created by Drew Hill on 11/13/16.
//  Copyright (c) 2016 Drew Hill. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat _expandedHeight = 250;
    
    NSLayoutConstraint *_heightConstraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant: _expandedHeight];
    
    [self.view addConstraint: _heightConstraint];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    NSArray *topRow = [[NSArray alloc] initWithObjects:@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p", nil];
    int numberOfKeysInRow = 10;
    CGFloat keywidth = 300/numberOfKeysInRow;
    int i;
    for (i=0; i<numberOfKeysInRow; i++) {
        UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(10+(i*keywidth), 60, keywidth, 40)];
        [key setTitle:[topRow objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:key];
    }
    
    NSArray *midRow = [[NSArray alloc] initWithObjects:@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l", nil];
    numberOfKeysInRow = 9;
    CGFloat offset = (320-(9*keywidth))/2;
    
    for (i=0; i<numberOfKeysInRow; i++) {
        UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(offset+(i*keywidth), 100, keywidth, 40)];
        [key setTitle:[midRow objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:key];
    }
    
    NSArray *botRow = [[NSArray alloc] initWithObjects:@"",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"", nil];
    
    numberOfKeysInRow = 9;
    for (i=0; i<numberOfKeysInRow; i++) {
        UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(10+(i*keywidth), 140, keywidth, 40)];
        [key setTitle:[botRow objectAtIndex:i] forState:UIControlStateNormal];
        [self.view addSubview:key];
    }
    
    self.smartText = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 310, 45)];
    [self.view addSubview:self.smartText];
    self.smartText.layer.cornerRadius = 5;
    self.smartText.editable = false;
    
    [self.view addSubview:self.nextKeyboardButton];
    
    NSLayoutConstraint *nextKeyboardButtonLeftSideConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *nextKeyboardButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:self.nextKeyboardButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.view addConstraints:@[nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
