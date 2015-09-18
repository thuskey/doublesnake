//
//  DoubleSnakeLoadingWindow.m
//  DoubleSnake
//
//  Created by Charles Yuan on 2/8/13.
//  Copyright (c) 2013 Charles. All rights reserved.
//

#import "DoubleSnakeStatusWindow.h"

@implementation DoubleSnakeStatusWindow
- (id)init {
    self = [super initWithFrame:CGRectMake(0, -20, 320, 20)];
    if (self) {
        self.hidden = NO;
        self.windowLevel = UIWindowLevelStatusBar;
        
        self.frame = CGRectMake(0, -20, 320, 20);
        
        self.rootViewController = [[UIViewController alloc] init];
        self.rootViewController.view = [[UIView alloc] init];
        self.rootViewController.view.frame = self.frame;
        self.rootViewController.view.bounds = self.rootViewController.view.frame;
        self.rootViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //self.rootViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        //self.rootViewController.view.layer.shadowOpacity = 0.5;
        //self.rootViewController.view.layer.shadowRadius = 3.0;
        //self.rootViewController.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        //self.rootViewController.view.clipsToBounds = NO;

        self.label = [[UILabel alloc] initWithFrame:self.frame];
        self.label.backgroundColor = [UIColor clearColor];
        _label.textAlignment =  NSTextAlignmentCenter;
        _label.text = @"Hello";
        _label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:14.0];
        _label.textColor = [UIColor whiteColor];
        [self.rootViewController.view addSubview:_label];

    }
    return self;
}

- (void)makeKeyAndVisible
{
    [super makeKeyAndVisible];
    /*
    self.backgroundColor = [UIColor clearColor];
    //self.layer.opacity = 0;
    self.rootViewController.view.alpha = 0;
    
    [UIView beginAnimations: @"fade-in" context: NULL];
    [UIView setAnimationDuration:0.5];
    
    //self.layer.opacity = 1;
    self.rootViewController.view.alpha = 1;

    
    [UIView commitAnimations];*/
    [self.rootViewController.view setFrame:CGRectMake(0.0f,-20.0f,320.0f,20.0f)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.rootViewController.view cache:YES];
    [self.rootViewController.view setFrame:CGRectMake(0.0f,0.0f,320.0f,20.0f)];
    [UIView commitAnimations];
}

- (void)animate {
    [self.rootViewController.view setFrame:CGRectMake(0.0f,-20.0f,320.0f,20.0f)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.rootViewController.view cache:YES];
    [self.rootViewController.view setFrame:CGRectMake(0.0f,0.0f,320.0f,20.0f)];
    [UIView commitAnimations];
}
@end
