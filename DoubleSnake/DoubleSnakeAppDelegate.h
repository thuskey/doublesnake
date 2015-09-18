//
//  DoubleSnakeAppDelegate.h
//  DoubleSnake
//
//  Created by Charles on 7/20/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoubleSnakeStatusWindow.h"


@interface DoubleSnakeAppDelegate : UIResponder <UIApplicationDelegate> {
    UIImageView *splashView;
}

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) DoubleSnakeLoadingWindow *loading;

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
