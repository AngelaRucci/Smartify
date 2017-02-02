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
    self.smartifier = [[Smartify alloc] init];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    [bg setBackgroundColor:[UIColor colorWithRed:0.51 green:0.00 blue:0.00 alpha:1.0]];
    [self.view addSubview:bg];
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"->", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.inputVieww = [[InputView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    [self.inputVieww.smartifyButton addTarget:self action:@selector(smartify:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.inputVieww];
    
    self.loadVieww = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    self.loadVieww.alpha = 0;
    [self.view addSubview:self.loadVieww];
    //[self.loadVieww startAnimations];
    
//    CGFloat spacing = 3;
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
 
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

//-(IBAction)typeLetter:(id)sender{
//    UIButton *inputButton = (UIButton*)sender;
//    if (inputButton.tag==1) {
//        NSString *addChar = inputButton.titleLabel.text;
//        self.smartText.text = [self.smartText.text stringByAppendingString:addChar];
//    }
//}

-(IBAction)smartify:(id)sender{
    [UIView animateWithDuration:.25 animations:^{
        self.inputVieww.alpha = 0;
        self.loadVieww.alpha = 1;
    } completion:^(BOOL finished) {
        [self.loadVieww startAnimations];
        NSLog(@"To process:%@",self.inputVieww.smartText.text);
        [self.smartifier processText:self.inputVieww.smartText.text];
        [self.smartifier addObserver:self forKeyPath:@"parsingFinished" options:0 context:NULL];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"parsingFinished"])
    {
        if (self.smartifier.parsingFinished) {
            //show result view
            
        }
    }
}

@end
