//
//  LoadingView.m
//  VerySmrt
//
//  Created by Drew Hill on 1/31/17.
//  Copyright (c) 2017 Drew Hill. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.loadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 50, 50)];
    [self.loadIcon setCenter:self.center];
    [self.loadIcon setImage:[UIImage imageNamed:@"brain"]];
    [self addSubview:self.loadIcon];
    
    self.loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIFont *font = [UIFont fontWithName:@"Snell Roundhand" size:30.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                forKey:NSFontAttributeName];
    NSMutableAttributedString * attributedString= [[NSMutableAttributedString alloc] initWithString:@"Smartifying..." attributes:attrsDictionary];
    //[attributedString setAttributes:attrsDictionary range:NSRangeFromString(@"Smartifying...")];
    [self.loadLabel setAttributedText:attributedString];
    self.loadLabel.textAlignment = NSTextAlignmentCenter;
    [self.loadLabel setTextColor:[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0]];
    [self addSubview:self.loadLabel];
    
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [topBorder setBackgroundColor:[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0]];
    //topBorder.layer.borderColor = [[UIColor colorWithRed:0.91 green:0.89 blue:0.00 alpha:1.0] CGColor];
    //topBorder.layer.borderWidth = 1;
    [self addSubview:topBorder];
    return self;
}

-(void)startAnimations{
    self.isanimating = true;
    [self animLoop1];
}

-(void)endAnimations{
    self.isanimating = false;
}

-(void)animLoop1{
    if (self.isanimating) {
        [UIView animateWithDuration:.75 animations:^{
            self.loadIcon.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.75, 1.75);
            self.loadIcon.alpha = .75;
        } completion:^(BOOL finished) {
            [self animLoop2];
        }];
    }
}

-(void)animLoop2{
    if (self.isanimating) {
        [UIView animateWithDuration:.75 animations:^{
            self.loadIcon.transform = CGAffineTransformScale(CGAffineTransformIdentity, .75, .75);
            self.loadIcon.alpha = 1;
        } completion:^(BOOL finished) {
            [self animLoop1];
        }];
    }
}

@end
