//
//  ConfirmationViewControllerDelegate.h
//  DoubleSnake
//
//  Created by Charles on 8/1/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfirmationViewController.h"

@class ConfirmationViewController;

@protocol ConfirmationViewControllerDelegate <NSObject>
- (void)setDelegate:(id)delegate;
@end
