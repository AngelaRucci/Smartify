//
//  LoadingView.h
//  VerySmrt
//
//  Created by Drew Hill on 1/31/17.
//  Copyright (c) 2017 Drew Hill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property UIImageView *loadIcon;
@property UILabel *loadLabel;
@property BOOL isanimating;

-(void)startAnimations;
-(void)endAnimations;

@end
