//
//  StartViewController.h
//  DoubleSnake
//
//  Created by Charles on 7/22/12.
//  Copyright (c) 2012 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Bluetooth.h"
#import "TwoPlayer.h"
#import "GameStarted.h"
#import "Speed.h"
#import "PeerLost.h"
#import "BodyPart.h"
#import "DoubleSnakeAlertView.h"
#import "StartViewControllerDelegate.h"
#import "DoubleSnakeViewController.h"
#import "ConfirmationViewController.h"
#import "LastSnakeWins.h"
#import "ShowArrows.h"
#import "IStarted.h"
#import "ConfirmationViewControllerDelegate.h"
#import "WallCollisions.h"
#import "DoubleSnakeStatusWindow.h"
#import "BlockAlertView.h"

@interface StartViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate, ConfirmationViewControllerDelegate>

@property (nonatomic, weak) id <StartViewControllerDelegate> doubleSnakeViewControllerDelegate;
//@property (strong, nonatomic) DoubleSnakeLoadingWindow *loading;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;
@property (strong, nonatomic) IBOutlet UISlider *speedSlider;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIButton *helpButton;
@property (strong, nonatomic) IBOutlet UIButton *highScoresButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *gameSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *wallCollisionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBarView;
@property (strong, nonatomic) IBOutlet UISwitch *lastSnakeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *directionArrowsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *wallCollisionsSwitch;
@property (strong, nonatomic) IBOutlet UILabel *speedMultiplierLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *connectSpinner;
@property (strong, nonatomic) IBOutlet UIView *settingsView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *settingsSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *SettingsCloseRecognizer;
@property (strong, nonatomic) IBOutlet UILabel *settingsLabel;
@property Bluetooth *bluetooth;
@property TwoPlayer *twoPlayer;
@property GameStarted *gameStarted;
@property Speed *speed;
@property Speed *formattedSpeed;
@property PeerLost *peerLost;
@property ShowArrows *showArrows;
@property NSMutableArray *peerBody;
@property NSMutableArray *food;
@property LastSnakeWins *lastSnakeWins;
@property WallCollisions *wallCollisions;
- (IBAction)connectPressed:(id)sender;
- (IBAction)lastSnakeSwitchChanged:(id)sender;
- (IBAction)helpPressed:(UIButton *)sender;
- (IBAction)gameSpeedChanged:(UISlider *)sender;
- (IBAction)startPressed:(UIButton *)sender;
- (IBAction)directionArrowsSwitchChanged:(UISwitch *)sender;
- (IBAction)wallCollisionsSwitchChanged:(UISwitch *)sender;
- (IBAction)settingsSwiped:(UISwipeGestureRecognizer *)sender;
- (IBAction)settingsClosed:(UISwipeGestureRecognizer *)sender;
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
+ (Bluetooth *)sharedBluetooth;
+ (TwoPlayer *)sharedTwoPlayer;
+ (GameStarted *)sharedGameStarted;
+ (Speed *)sharedSpeed;
+ (Speed *)sharedFormattedSpeed;
+ (PeerLost *)sharedPeerLost;
+ (NSMutableArray *)sharedPeerBody;
+ (NSMutableArray *)sharedFood;
+ (LastSnakeWins *)sharedLastSnakeWins;
+ (ShowArrows *)sharedShowArrows;
+ (WallCollisions *)sharedWallCollisions;
+ (IStarted *)sharedIStarted;
+ (DoubleSnakeStatusWindow *) sharedLoading;
@end
