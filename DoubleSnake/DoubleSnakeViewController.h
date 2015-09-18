//
//  DoubleSnakeViewController.h
//  DoubleSnake
//
//  Created by Charles on 7/20/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "BodyPart.h"
#import "Bluetooth.h"
#import "StartViewControllerDelegate.h"
#import "StartViewController.h"
#import "TwoPlayer.h"
#import "Speed.h"
#import "DoubleSnakeAlertView.h"
#import "ShowArrows.h"
#import "WallCollisions.h"
#import "DoubleSnakeStatusWindow.h"
#import "CustomAlertView.h"
#import "BlockAlertView.h"

@interface DoubleSnakeViewController : UIViewController <UIAlertViewDelegate, StartViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) DoubleSnakeStatusWindow *loading;
@property NSMutableArray *body;
@property NSMutableArray *food;
@property BodyPart *head;
@property BodyPart *tail;
@property NSTimer *updateTimer;
@property TwoPlayer *twoPlayer;
@property GameStarted *gameStarted;
@property Speed *speed;
@property PeerLost *peerLost;
@property WallCollisions *wallCollisions;
@property float currentSpeed;
@property (strong) BlockAlertView *peerLostView;
@property (strong) BlockAlertView *pausedAlert;
@property NSMutableArray *peerBody;
@property NSMutableArray *peerBodyToClear;
@property NSMutableArray *fakePeerBody;
@property BOOL dead;
@property int peerScore;
@property int score;
@property (strong, nonatomic) IBOutlet UIImageView *downArrow;
@property (strong, nonatomic) IBOutlet UIImageView *upArrow;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrow;
@property (strong, nonatomic) IBOutlet UIImageView *leftArrow;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomPadView;
- (void)receiveMove:(StartViewController *)startViewController;
- (void)receiveFood:(StartViewController *)startViewController;
- (void)paintStart;
- (void)update;
- (BOOL)isCollidingWithSelf;
@end
