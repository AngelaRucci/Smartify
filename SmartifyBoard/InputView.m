//
//  InputView.m
//  VerySmrt
//
//  Created by Drew Hill on 1/31/17.
//  Copyright (c) 2017 Drew Hill. All rights reserved.
//

#import "InputView.h"

@implementation InputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    CGFloat spacing = 3;
    NSArray *topRow = [[NSArray alloc] initWithObjects:@"q",@"w",@"e",@"r",@"t",@"y",@"u",@"i",@"o",@"p", nil];
    int numberOfKeysInRow = 10;
    CGFloat keywidth = 280/numberOfKeysInRow;
    CGFloat offset = (320-(10*(keywidth+spacing)))/2;
    int i;
    for (i=0; i<numberOfKeysInRow; i++) {
        UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(offset+(i*(keywidth+spacing)), 70, keywidth, 40)];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentCenter];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        UIFont *font1 = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20.0f];
        
        key.layer.borderColor = [[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0] CGColor];
        key.layer.borderWidth = 1;
        key.backgroundColor = [UIColor whiteColor];
        key.layer.cornerRadius = 7;
        key.tag = 1;
        [key setTitle:[topRow objectAtIndex:i] forState:UIControlStateNormal];
        [key setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [key addTarget:self action:@selector(typeLetter:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:key];
    }
    
    NSArray *midRow = [[NSArray alloc] initWithObjects:@"a",@"s",@"d",@"f",@"g",@"h",@"j",@"k",@"l", nil];
    numberOfKeysInRow = 9;
    offset = (320-(9*(keywidth+spacing)))/2;
    
    for (i=0; i<numberOfKeysInRow; i++) {
        UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(offset+(i*(keywidth+spacing)), 111, keywidth, 40)];
        key.layer.borderColor = [[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0] CGColor];
        key.layer.borderWidth = 1;
        key.backgroundColor = [UIColor whiteColor];
        key.layer.cornerRadius = 7;
        key.tag = 1;
        [key setTitle:[midRow objectAtIndex:i] forState:UIControlStateNormal];
        [key setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [key addTarget:self action:@selector(typeLetter:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:key];
    }
    
    NSArray *botRow = [[NSArray alloc] initWithObjects:@"",@"z",@"x",@"c",@"v",@"b",@"n",@"m",@"", nil];
    
    numberOfKeysInRow = 9;
    for (i=0; i<numberOfKeysInRow; i++) {
        UIButton *key = [[UIButton alloc] initWithFrame:CGRectMake(offset+(i*(keywidth+spacing)), 152, keywidth, 40)];
        key.layer.borderColor = [[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0] CGColor];
        key.layer.borderWidth = 1;
        key.backgroundColor = [UIColor whiteColor];
        key.layer.cornerRadius = 7;
        key.tag = 1;
        [key setTitle:[botRow objectAtIndex:i] forState:UIControlStateNormal];
        [key setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [key addTarget:self action:@selector(typeLetter:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:key];
    }
    
    UIButton *spaceBar = [[UIButton alloc] initWithFrame:CGRectMake(50, 193, 7*(keywidth+spacing), 30)];
    spaceBar.layer.borderColor = [[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0] CGColor];
    spaceBar.layer.borderWidth = 1;
    spaceBar.backgroundColor = [UIColor whiteColor];
    spaceBar.layer.cornerRadius = 7;
    [self addSubview:spaceBar];
    spaceBar.tag=1;
    [spaceBar setTitle:@" " forState:UIControlStateNormal];
    [spaceBar addTarget:self action:@selector(typeLetter:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:spaceBar];
    
    self.smartText = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, 255, 45)];
    [self addSubview:self.smartText];
    self.smartText.layer.cornerRadius = 5;
    self.smartText.layer.borderColor = [[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0] CGColor];
    self.smartText.layer.borderWidth = 3;
    self.smartText.editable = false;
    
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
    [topBorder setBackgroundColor:[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0]];
    //topBorder.layer.borderColor = [[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0] CGColor];
    //topBorder.layer.borderWidth = 1;
    [self addSubview:topBorder];
    
    self.smartifyButton = [[UIButton alloc] initWithFrame:CGRectMake(265, 10, 45, 45)];
    [self.smartifyButton setBackgroundImage:[UIImage imageNamed:@"brain"] forState:UIControlStateNormal];
    [self addSubview:self.smartifyButton];
    
    return self;
}

-(IBAction)typeLetter:(id)sender{
    UIButton *inputButton = (UIButton*)sender;
    if (inputButton.tag==1) {
        NSString *addChar = inputButton.titleLabel.text;
        self.smartText.text = [self.smartText.text stringByAppendingString:addChar];
    }
}

@end
