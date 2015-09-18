//
//  HowToPlayViewController.h
//  DoubleSnake
//
//  Created by Charles on 7/28/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface HowToPlayViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *text;

@end
