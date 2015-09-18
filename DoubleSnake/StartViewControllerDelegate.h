//
//  StartViewControllerDelegate.h
//  DoubleSnake
//
//  Created by Charles on 7/30/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StartViewController;
@protocol StartViewControllerDelegate <NSObject>

- (void)tellPaused:(StartViewController *)startViewController;
- (void)tellResumed:(StartViewController *)startViewController;
- (void)receiveMove:(StartViewController *)startViewController;
- (void)receiveFood:(StartViewController *)startViewController;
- (void)clearFood:(StartViewController *)startViewController;
- (void)endGame;
- (void)gotPauseDeath;
- (void)tellDeath;

@end
